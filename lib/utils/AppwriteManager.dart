// 封装一个单例的appwrite管理类
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart'as models;

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
  signUp(String userId, String email, String password, String name, Function onSuccess) async {
    try {
      var result = await _account.create(userId: userId, email: email, password: password, name: name);
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
      var result = await _account.createEmailSession(email: email, password: pwd);
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

  // 保存数据到数据库
  Future<models.Document> createUserCollection(UserModel userModel) {
    final response = _databases.createDocument(
        databaseId: ConstanceData.appWriteDatabaseID,
        collectionId: ConstanceData.appWriteUserCollectionID,
        documentId: ID.unique(),
        data: userModel.toJson());
    return response;
  }

  // 查找所有用户
  Future<models.DocumentList> findUserList() {
    final response = _databases.listDocuments(
        databaseId: ConstanceData.appWriteDatabaseID,
        collectionId: ConstanceData.appWriteUserCollectionID);
    return response;
  }

  Future<models.User> getUser() async {
    try {
      var result = await _account.get();
      print("userinfo:${result.name}");
      return result;
    } catch (error) {
      print("获取用户信息失败:$error");
      rethrow;
    }
  }
}
