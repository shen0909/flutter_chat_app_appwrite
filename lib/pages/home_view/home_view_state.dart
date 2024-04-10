import 'package:flutter/cupertino.dart';

import '../../modle/UserModle.dart';
import '../../modle/chatMessageListModel.dart';
import '../../modle/friendsModle.dart';

class HomeViewState {
  TextEditingController controller = TextEditingController();
  List<UserModel> searchFriendList = [];
  List<FriendModel> friendList = [];
  List<ChatMessageList> chatHeadList = [];
  HomeViewState() {
    ///Initialize variables
  }
}
