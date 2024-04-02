// 封装一个单例的appwrite管理类
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:chat_app_appwrite/modle/friendsModle.dart';

import '../common/constance.dart';
import '../modle/UserModle.dart';

// 静态属性和静态方法
// 只能用类名来使用，内存中只存在这一份
class AppWriteManager {
  late final Client _client;
  late final Account _account;
  late final Databases _databases;
  late final Storage _storage;

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
      var result = await _account.createEmailSession(
          email: email, password: pwd);
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
      await _databases.createDocument(
          databaseId: ConstanceData.appWriteDatabaseID,
          collectionId: ConstanceData.appWriteUserCollectionID,
          documentId: ID.unique(),
          data: userModel.toJson()).then((value) => print("保存用户成功"));
    } catch (error) {
      rethrow;
    }
  }

  /// 添加好友
  createFriendsCollection(UserModel friendInfo) async {
    try{
      models.User myInfo = await getUser();
      print("我：${myInfo.toMap()}");
      FriendModel friendModel = FriendModel(myUserId: myInfo.$id,
          myUserName: myInfo.name,
          friendUserId: friendInfo.userID,
          friendsUserName: friendInfo.userName);
      if(friendInfo.userID == myInfo.$id){
        print("你自己已经是你最好的朋友了~");
        return;
      }
      await _databases.createDocument(
          databaseId: ConstanceData.appWriteDatabaseID,
          collectionId: ConstanceData.appWriteFriendsShipCollectionID,
          documentId: ID.unique(),
          data: friendModel.toJson()).then((value) => print("添加好友成功"));
    }catch(error){
      rethrow;
    }
  }

  /// 查找所有用户
  Future<models.DocumentList> findUserList() async {
    try {
      String ss = await Query.select(["myUserId"]);
      final response = await _databases.listDocuments(
          databaseId: ConstanceData.appWriteDatabaseID,
          collectionId: ConstanceData.appWriteUserCollectionID,);
      // onSuccess(response);
      print("qury:${ss}");
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
}
