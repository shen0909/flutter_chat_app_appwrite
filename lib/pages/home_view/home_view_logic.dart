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
    // print("usertype-:${appWriteManager.getUser().runtimeType}");
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

  saveUser() {
    UserModel userModel = UserModel(
        userID: _getStorage.read("userID"),
        providerUID: _getStorage.read("providerUid"),
        userName:_getStorage.read("userName")
    );
    appWriteManager
        .createUserCollection(userModel)
        .then((value) {
      print("document:${value!.data}");
    }, onError: (error) {});
    print("userModel:${userModel.toJson()}");
  }
  getAllUser(){
    appWriteManager.findUserList()
    .then((value) {
      value.documents.forEach((element) {
        print("user-list:${element.data}");
      });
    });
  }
}
