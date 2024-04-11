import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:appwrite/models.dart';
import 'package:chat_app_appwrite/modle/chatMessageListModel.dart';
import 'package:chat_app_appwrite/modle/friendsModle.dart';
import 'package:chat_app_appwrite/modle/messageModle.dart';
import 'package:chat_app_appwrite/utils/event_bus.dart';
import '../common/constance.dart';
import '../modle/UserModle.dart';

// 封装一个单例的appwrite管理类
// 静态属性和静态方法
// 只能用类名来使用，内存中只存在这一份
class AppWriteManager {
  late final Client _client;
  late final Account _account;
  late final Databases _databases;
  late final Storage _storage;

  // 实时通信
  late final Realtime _realtime;
  late final RealtimeSubscription _realtimeSubscription;
  late final RealtimeMessage _realtimeMessage;

  //静态属性-该类的实例
  static final AppWriteManager _appWriteManager = AppWriteManager._internal();

  // 私有构造函数-确认类不能被外部实例化
  AppWriteManager._internal() {
    _client = Client()
        .setEndpoint(ConstanceData.appWriteEndPoint)
        .setProject(ConstanceData.appWriteProjectID);
    _account = Account(_client);
    _databases = Databases(_client);
    _storage = Storage(_client);
    _realtime = Realtime(_client);
    _realtimeSubscription = _realtime.subscribe([
      'databases.${ConstanceData.appWriteDatabaseID}.collections.${ConstanceData.appWriteMessageListCollectionID}.documents', // 监听消息头
      'databases.${ConstanceData.appWriteDatabaseID}.collections.${ConstanceData.appWriteMessageCollectionID}.documents', // 监听消息
    ]);
    _realtimeSubscription.stream.listen(realTimeCallBack);
  }

  factory AppWriteManager() {
    return _appWriteManager;
  }

  // 注册方法
  signUp(String userId, String email, String password, String name,
      Function onSuccess) async {
    try {
      var result = await _account.create(
          userId: userId, email: email, password: password, name: name);
      onSuccess(result);
    } catch (error) {
      print("注册失败:${error}");
    }
  }

  // 登录方法
  /*关于出现
  * [ERROR:flutter/runtime/dart_vm_initializer.cc(41)] Unhandled Exception: type 'Null' is not a subtype of type 'FutureOr<Session>'
  * 原因在于：.then()在异步完成时会调用onSuccess函数，但是它这个完成结果包含着登录成功和登陆失败两种结果*/
  loginAction(String email, String pwd, Function onSuccess) async {
    try {
      var result =
          await _account.createEmailSession(email: email, password: pwd);
      onSuccess(result);
    } catch (error) {
      print("登录失败:${error}");
      rethrow;
    }
  }

  // 退出登录
  loginOut(String sessionID, Function onSuccess) async {
    await _account.deleteSession(sessionId: sessionID).then(
        (value) => onSuccess(value),
        onError: (error) => print("退出登陆失败:${error}"));
  }

  /// 保存用户数据到数据库
  /* 已经保存到用户不能再次保存*/
  createUserCollection(UserModel userModel) async {
    try {
      final userList = await findUserList();
      for (var element in userList.documents) {
        if (element.data["userID"] == userModel.userID) {
          print("当前用户已被保存");
          return;
        }
      }
      // 修改：将用户的UserID作为数据库中列的id
      await _databases
          .createDocument(
              databaseId: ConstanceData.appWriteDatabaseID,
              collectionId: ConstanceData.appWriteUserCollectionID,
              documentId: userModel.userID,
              data: userModel.toJson())
          .then((value) => print("保存用户成功"));
    } catch (error) {
      rethrow;
    }
  }

  /// 添加好友
  /// 只有当 既不是本人也未添加过才能成功添加
  /// 传入搜索到的朋友信息
  createFriendsCollection(UserModel friendInfo) async {
    try {
      // 获取当前账户信息
      models.User myInfo = await getUser();
      print("我的信息：${myInfo.toMap()}");
      // 搜索到的人是自己
      if (friendInfo.userID == myInfo.$id) {
        print("你自己已经是你最好的朋友了~");
        return;
      }

      // 获取所有朋友列表
      // todo:error-添加朋友有错误：只要这个用户被添加过就不能被别人添加了
      // 改进：设置过滤条件-本人id和朋友id,只要查找到的数据不为空就说明已是好友
      var friendship = await findUserList(
          collectionId: ConstanceData.appWriteFriendsShipCollectionID,
          queries: [
            Query.equal("myUserId", myInfo.$id),
            Query.equal("friendUserId", friendInfo.userID)
          ]);
      if (friendship.documents.isNotEmpty) {
        print("你俩已经是好友了~");
        return;
      }
      FriendModel friendModel = FriendModel(
          myUserId: myInfo.$id,
          myUserName: myInfo.name,
          friendUserId: friendInfo.userID,
          friendsUserName: friendInfo.userName);

      await _databases
          .createDocument(
              databaseId: ConstanceData.appWriteDatabaseID,
              collectionId: ConstanceData.appWriteFriendsShipCollectionID,
              documentId: ID.unique(),
              data: friendModel.toJson())
          .then((value) => print("添加好友成功"));
    } catch (error) {
      rethrow;
    }
  }

  /// 查找所有数据库列表-默认查询所有用户
  Future<models.DocumentList> findUserList(
      {String? collectionId, List<String>? queries}) async {
    try {
      final response = await _databases.listDocuments(
          databaseId: ConstanceData.appWriteDatabaseID,
          collectionId: collectionId ?? ConstanceData.appWriteUserCollectionID,
          queries: queries);
      // onSuccess(response);
      return response;
    } catch (error) {
      print("查找所有用户失败");
      rethrow;
    }
  }

  /// 获取当前用户信息
  Future<models.User> getUser() async {
    try {
      var result = await _account.get();
      return result;
    } catch (error) {
      print("获取用户信息失败:$error");
      rethrow;
    }
  }

  /// 发送消息
  /*
  * 创建两个密钥：
  * key1:A-B
  * key2:B-A*/
  Future<models.Document> sendMessage(
      MessageModel messageModel, String friendName) async {
    try {
      var respond = await _databases.createDocument(
          databaseId: ConstanceData.appWriteDatabaseID,
          collectionId: ConstanceData.appWriteMessageCollectionID,
          documentId: ID.unique(),
          data: messageModel.toJson());
      print("发送消息成功:${respond.toString()}");
      // todo:改进-原本的密钥太长，分别取后10位
      String keyAB =
          "${messageModel.sendID.substring(messageModel.sendID.length - 10)}${messageModel.receiveID.substring(messageModel.receiveID.length - 10)}";
      String keyBA =
          "${messageModel.receiveID.substring(messageModel.receiveID.length - 10)}${messageModel.sendID.substring(messageModel.sendID.length - 10)}";
      // A那里显示的B的聊天头 -- A是本人
      addChatHead(keyAB, messageModel.sendID, messageModel.receiveID,
          friendName, messageModel);
      // B那里显示的A的聊天头
      addChatHead(keyBA, messageModel.receiveID, messageModel.sendID,
          await getUser().then((value) => value.name), messageModel);
      return respond;
    } on AppwriteException catch (error) {
      print("发送消息失败:${error}");
      rethrow;
    }
  }

  /// 创建消息头-类似微信聊天页的
  /// todo：为什么要添加两次呢
  /// 相当于创建两条队列 A向B发送的 B向A发送的,将这一条消息添加到他们俩的队列中
  addChatHead(String key, String sendId, String receiveId, String displayName,
      MessageModel message) async {
    ChatMessageList newItem = ChatMessageList(
        sendId: sendId,
        receiveId: receiveId,
        message: message.message,
        sendDate: DateTime.now().toString(),
        displayName: displayName,
        read: false,
        count: 0,
        key: key);
    try {
      // 获取 documentId 为 key 的 Document
      Document response = await _databases.getDocument(
          databaseId: ConstanceData.appWriteDatabaseID,
          collectionId: ConstanceData.appWriteMessageListCollectionID,
          documentId: key);
      ChatMessageList oldItem = ChatMessageList.fromJson(response.data);
      newItem.count = oldItem.count! + 1;
      // 更新Document
      await _databases.updateDocument(
          databaseId: ConstanceData.appWriteDatabaseID,
          collectionId: ConstanceData.appWriteMessageListCollectionID,
          documentId: key,
          data: newItem.toJson());
    } on AppwriteException catch (error) {
      print("添加到聊天列表失败:${error}");
      if (error.code == 404) {
        print("因为它俩还没有聊过天");
        try {
          await _databases.createDocument(
              databaseId: ConstanceData.appWriteDatabaseID,
              collectionId: ConstanceData.appWriteMessageListCollectionID,
              documentId: key,
              data: newItem.toJson());
        } on AppwriteException catch (error) {
          print("没聊过过，创建依旧失败:${error}");
        }
      }
    }
  }

  // 所以他是将所有的消息集合都放在了一个数据库里吗？怎么过滤呢？
  /// 获取用户消息
  /// 从消息数据库中搜索，sendID = 当前id的 改进：使用query语句
  Future<models.DocumentList> getMessage(String friendID) async {
    try {
      var responds = await _databases.listDocuments(
          databaseId: ConstanceData.appWriteDatabaseID,
          collectionId: ConstanceData.appWriteMessageCollectionID,
          queries: [
            Query.equal("sendID",
                [await getUser().then((value) => value.$id), friendID]),
            // 发送者是我的朋友或者我
            Query.equal("receiveID",
                [await getUser().then((value) => value.$id), friendID]),
            // 接受者是我的朋友或者我
            Query.orderDesc("\$createdAt")
          ]);
      return responds;
    } on AppwriteException catch (error) {
      print("获取消息失败${error}");
      rethrow;
    }
  }

  /// 实时监听回调方法
  /// todo:如何监听不同的集合通知不同的地方呢？ 通知全部吗？
  /// 那就通知全部吧，反正发送一条消息后它的消息头就是会改变
  realTimeCallBack(RealtimeMessage realtimeMessage) async {
    eventBus.fire(EventBusNewMessage());
    // print("有变化:++++++payload:${realtimeMessage.payload}\n+++++events:${realtimeMessage.events}\n+++++${realtimeMessage.channels}");
    // print("让我来写permissions:${realtimeMessage.payload["\$collectionId"]}");
    /*if (realtimeMessage.payload["\$collectionId"] == ConstanceData.appWriteMessageCollectionID) {
      print("有一条新消息:${realtimeMessage.payload}");
      eventBus.fire(EventBusNewMessage());
    } else if (realtimeMessage.payload["\$collectionId"] == ConstanceData.appWriteMessageListCollectionID) {
      print("消息头发送改变:${realtimeMessage.payload}");
      // eventBus.fire(EventChatNe());
    }*/
  }
}
