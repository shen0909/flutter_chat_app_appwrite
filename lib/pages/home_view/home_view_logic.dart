import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../modle/UserModle.dart';
import '../../router/router.dart';
import '../../utils/AppwriteManager.dart';
import '../login_sign/login_sign_logic.dart';
import '../login_sign/login_sign_state.dart';
import 'home_view_state.dart';

class HomeViewLogic extends GetxController {
  final HomeViewState state = HomeViewState();
  final LoginSignState loginSignState = Get.find<LoginSignLogic>().state;
  final GetStorage _getStorage = GetStorage();
  AppWriteManager appWriteManager = AppWriteManager();

  @override
  void onInit() {
    super.onInit();
  }

  // 当前用户退出登录
  loginOut() {
    String seid = _getStorage.read("sessionID");
    print("seid:$seid");
    appWriteManager.loginOut(seid, (value) {
      print(value);
      Get.offAllNamed(ChatRouters.loginSignPage);
    });
  }

  /// 保存用户
  saveUser() {
    UserModel userModel = UserModel(
        userID: _getStorage.read("userID"),
        providerUID: _getStorage.read("providerUid"),
        userName: _getStorage.read("userName"));
    appWriteManager.createUserCollection(userModel);
  }

  /// 获取全部用户
  getAllUser() {
    appWriteManager.findUserList().then((value) {
      value.documents.forEach((element) {
        print("user-list:${element.data}\n");
      });
    });
  }

  /// 查找用户
  toSearchUser() async {
    if (state.controller.text.isEmpty) {
      state.searchUserList.clear();
      print("请输入用户信息");
      // SmartDialog.showToast("请输入用户信息");
    } else {
      print("去查找");
      await appWriteManager.findUserList().then((value) {
        state.searchUserList.clear();
        for (var element in value.documents) {
          UserModel userModel = UserModel.fromJson(element.data);
          if (userModel.userName.contains(state.controller.text) ||
              userModel.userID.contains(state.controller.text)) {
            state.searchUserList.add(userModel);
          }
        }
      });
    }
    update();
  }

  /// 添加朋友
  addFriends(UserModel userModel) {
    appWriteManager.createFriendsCollection(userModel);
  }
}
