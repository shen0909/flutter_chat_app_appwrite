import 'package:chat_app_appwrite/modle/friendsModle.dart';
import 'package:flutter/cupertino.dart';

import '../../modle/messageModle.dart';

class ChatPageState {

  late FriendModel friendInfo;
  TextEditingController messageController = TextEditingController();
  List<MessageModel> getMessageList = [];
  // List<String> messageList = [];
  List<Map<String,dynamic>> messageList = [];

  ChatPageState() {
    ///Initialize variables

  }
}
