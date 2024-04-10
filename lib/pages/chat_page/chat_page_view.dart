import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_page_logic.dart';

class ChatPagePage extends StatelessWidget {
  ChatPagePage({Key? key}) : super(key: key);

  final logic = Get.put(ChatPageLogic());
  final state = Get
      .find<ChatPageLogic>()
      .state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(state.friendInfo.friendsUserName)),
      ),
      body: GetBuilder<ChatPageLogic>(builder: (logic) {
        return Column(
          children: [
            Expanded(child: Container(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.messageList.length,
                  itemBuilder: (context, index) {
                    String message = state.messageList[index]["message"];
                    bool isMySend = state.messageList[index]["my_send"];
                    return Container(
                      // color: Colors.green,
                      child: Row(
                        children: [
                          isMySend ?
                          Expanded(child: Container()):Container(),
                          Container(
                            alignment: Alignment.bottomRight,
                            height: 50,
                              margin: EdgeInsets.only(top: 20,right: 10),
                              // padding: EdgeInsets.only(top: 20),
                              color: Colors.green,
                              child: Center(child: Text(message))),
                        ],
                      ),
                    );
                  }),
            )),
            Container(
              height: 50,
              width: double.infinity,
              color: Colors.grey,
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                          controller: state.messageController)),
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
