import 'package:chat_app_appwrite/modle/UserModle.dart';
import 'package:flutter/cupertino.dart';

class LoginSignState {
  TextEditingController emilContro = TextEditingController();
  TextEditingController passwordContro = TextEditingController();
  TextEditingController nameContro = TextEditingController();
  bool isSign = true;
  late UserModel myInfo; // 当前登录用户信息
  LoginSignState() {
    ///Initialize variables
  }
}
