import 'dart:async';
import 'package:chat_app_appwrite/modle/messageModle.dart';
import 'package:chat_app_appwrite/utils/AppwriteManager.dart';
import 'package:chat_app_appwrite/utils/event_bus.dart';
import 'package:get/get.dart';
import 'chat_page_state.dart';

class ChatPageLogic extends GetxController {
  final ChatPageState state = ChatPageState();
  AppWriteManager appWriteManager = AppWriteManager();
  late StreamSubscription streamUpdateNewMassage;

  @override
  void onInit() {
    super.onInit();
    state.friendInfo = Get.arguments;
    getMessage();
    streamUpdateNewMassage = eventBus.on<EventBusNewMessage>().listen((event) {
      getMessage();
    });
  }

  /// 发送消息
  sendMessage() async {
    MessageModel messageModel = MessageModel(
        sendID: state.friendInfo!.myUserId,
        receiveID: state.friendInfo!.friendUserId,
        message: state.messageController.text,
        sendDate: DateTime.now().toString());
    state.messageList.insert(0, {"message": state.messageController.text, "my_send": true});
    state.messageController.clear();
    update();
    await appWriteManager.sendMessage(messageModel,state.friendInfo!.friendsUserName);
  }

  Future<void> getMessage() async {
    await appWriteManager.getMessage(state.friendInfo!.friendUserId).then((value) {
      if(value.total >0){
        print("当前接收到${value.total}条消息");
        state.messageList.clear();
        for (var element in value.documents) {
          // state.getMessageList.add(MessageModel.fromJson(element.data));
          // todo:如果接收到的消息发送者为本人 则在右边显示，否则在左边
          if(element.data["sendID"] == state.friendInfo!.myUserId ){
            state.messageList.add({"message": element.data["message"],"my_send": true});
          }else{
            state.messageList.add({"message": element.data["message"],"my_send": false});
          }
          update();
        }
      }
    });
  }

}
