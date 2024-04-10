import 'package:chat_app_appwrite/modle/messageModle.dart';
import 'package:chat_app_appwrite/utils/AppwriteManager.dart';
import 'package:get/get.dart';
import 'chat_page_state.dart';

class ChatPageLogic extends GetxController {
  final ChatPageState state = ChatPageState();
  AppWriteManager appWriteManager = AppWriteManager();

  @override
  void onInit() {
    super.onInit();
    state.friendInfo = Get.arguments;
    appWriteManager.getMessage(state.friendInfo.friendUserId).then((value) {
      value.documents.forEach((element) {
        print("消息数据:${element.data.toString()}\n");
        state.getMessageList.add(MessageModel.fromJson(element.data));
        // todo:如果接收到的消息发送者为本人 则在右边显示，否则在左边
        if(element.data["sendID"] == state.friendInfo.myUserId ){
          state.messageList.add({"message": element.data["message"],"my_send": true});
        }else{
          state.messageList.add({"message": element.data["message"],"my_send": false});
        }
        update();

      });
    });
  }

  /// 发送消息
  sendMessage() async {
    MessageModel messageModel = MessageModel(
        sendID: state.friendInfo.myUserId,
        receiveID: state.friendInfo.friendUserId,
        message: state.messageController.text,
        sendDate: DateTime.now().toString());
    // print("发送:${messageModel.toJson()}");
    await appWriteManager.sendMessage(messageModel).then((value) {
      state.messageList.add({"message":state.messageController.text,"my_send": true},);
      state.messageController.clear();
      update();
    });
  }

}
