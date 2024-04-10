import 'package:appwrite/appwrite.dart';
import 'package:chat_app_appwrite/common/constance.dart';
import 'package:chat_app_appwrite/modle/chatMessageListModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../modle/UserModle.dart';
import '../../modle/friendsModle.dart';
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
  onInit() {
    super.onInit();
    /// todo:好友列表和聊天头是不是只用保留一个就行
    getFriendList();
    getChatHead();
  }

  /// 获取好友列表
  getFriendList() async {
    await appWriteManager
        .findUserList(collectionId: ConstanceData.appWriteFriendsShipCollectionID)
        .then((value) {
      state.friendList.clear();
      for (var element in value.documents) {
        // todo:使用能看见的持久化
        // 过滤当前用户的好友
        if (element.data["myUserId"] == _getStorage.read("userID")) {
          FriendModel friendInfoModel = FriendModel.fromJson(element.data);
          state.friendList.add(friendInfoModel);
          update();
        }
      }
    });
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
        print("全部用户列表:${element.data}\n");
      });
    });
  }

  /// 查找用户
  toSearchUser() async {
    if (state.controller.text.isEmpty) {
      state.searchFriendList.clear();
      print("请输入用户信息");
      // SmartDialog.showToast("请输入用户信息");
    } else {
      print("去查找");
      await appWriteManager.findUserList().then((value) {
        state.searchFriendList.clear();
        for (var element in value.documents) {
          UserModel userModel = UserModel.fromJson(element.data);
          if (userModel.userName.contains(state.controller.text) ||
              userModel.userID.contains(state.controller.text)) {
            state.searchFriendList.add(userModel);
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

  /// 去与朋友聊天
  toChat(FriendModel friendInfo) {
    Get.toNamed(ChatRouters.chatPage, arguments: friendInfo);
  }

  /// 获取聊天头
  getChatHead(){
    appWriteManager.findUserList(collectionId: ConstanceData.appWriteMessageListCollectionID,queries: [
      Query.equal('sendId', _getStorage.read("userID"))
    ]).then((value) {
      value.documents.forEach((element) {
        print("获取到的聊天头:${element.data.toString()}");
        state.chatHeadList.add(ChatMessageList.fromJson(element.data));
        update();
      });
    });
  }
}
