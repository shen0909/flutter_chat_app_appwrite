import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_page_logic.dart';

class ChatPagePage extends StatelessWidget {
  ChatPagePage({Key? key}) : super(key: key);

  final logic = Get.put(ChatPageLogic());
  final state = Get.find<ChatPageLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Center(child: Text(state.friendInfo!.friendsUserName))),
      body: GetBuilder<ChatPageLogic>(builder: (logic) {
        return Column(
          children: [
            Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.messageList.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      String message = state.messageList[index]["message"];
                      bool isMySend = state.messageList[index]["my_send"];
                      return Row(
                        children: [
                          isMySend ? Expanded(child: Container()) : Container(),
                          Container(
                              alignment: Alignment.bottomRight,
                              decoration: BoxDecoration(
                                  color: isMySend ? Colors.green : Colors.white,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5))),
                              height: 50,
                              margin: const EdgeInsets.only(
                                  top: 20, right: 10, left: 10),
                              padding: const EdgeInsets.all(5),
                              child: Center(child: Text(message))),
                        ],
                      );
                    })),
            const SizedBox(height: 10),
            Container(
              height: 50,
              width: double.infinity,
              color: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                      child:
                          TextFormField(controller: state.messageController)),
                  GestureDetector(
                    onTap: () => logic.sendMessage(),
                    child: SizedBox(
                      width: 60,
                      height: double.infinity,
                      child: Container(
                        color: Colors.yellow,
                        child: Center(child: Text("发送")),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
