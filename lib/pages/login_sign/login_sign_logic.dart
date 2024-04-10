import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:chat_app_appwrite/router/router.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../utils/AppwriteManager.dart';
import 'login_sign_state.dart';

class LoginSignLogic extends GetxController {
  final LoginSignState state = LoginSignState();
  final GetStorage getStorage = GetStorage();
  final AppWriteManager appWriteManager = AppWriteManager();
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  changeState(){
    state.isSign = !state.isSign;
    update();
  }
  // 注册
  signUp() {
    if(state.passwordContro.text.isNotEmpty && state.emilContro.text.isNotEmpty){
      if(state.passwordContro.text.length > 8){
        appWriteManager.signUp(ID.unique(), state.emilContro.text, state.passwordContro.text,state.nameContro.text, (value){
          // todo:注册成功添加用户到数据库
          SmartDialog.showToast("用户注册成功");
          state.isSign = false;
          update();
        });
      }else{
        // SmartDialog.showToast();
        print("密码长度不得小于8位");
        return;
      }
    }else{
      print("密码和邮箱不得为空");
      return;
    }
  }

  //登录
  login() {
    if(state.passwordContro.text.isNotEmpty && state.emilContro.text.isNotEmpty){
      if(state.passwordContro.text.length > 8){
        appWriteManager.loginAction(state.emilContro.text, state.passwordContro.text, (value) async {
          // 登录成功后将用户数据保存到appwrite的新建数据库
          // 数据持久化-将用户信息保存到本地
          User user = await appWriteManager.getUser() ; // 获取登录的用户信息
          getStorage.write("sessionID", value.$id);
          getStorage.write("userID", value.userId);
          getStorage.write("providerUid", value.providerUid);
          getStorage.write("userName", user.name);
          Get.toNamed(ChatRouters.homePage);
          SmartDialog.showToast("登录成功");
        });
      }else{
        // SmartDialog.showToast();
        print("密码长度不得小于8位");
        return;
      }
    }else{
      print("密码和邮箱不得为空");
      return;
    }
  }
}
