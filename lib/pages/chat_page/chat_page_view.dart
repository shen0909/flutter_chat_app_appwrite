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
      appBar: AppBar(
        title: const Text("Chat APP"),
      ),
      body: Container(
        child: Text("聊天页"),
      ),
    );
  }
}
