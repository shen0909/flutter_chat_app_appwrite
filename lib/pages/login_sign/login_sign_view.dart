import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_sign_logic.dart';

class LoginSignPage extends StatelessWidget {
  LoginSignPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.put(LoginSignLogic());
    final state = Get.find<LoginSignLogic>().state;

    return Scaffold(
      appBar: AppBar(title: const Text("Chat APP")),
      body: GetBuilder<LoginSignLogic>(builder: (logic) {
        return state.isSign
            ? Container(
                // color: Colors.green,
                child: Column(
                  children: [
                    TextFormField(
                      controller: state.emilContro,
                      decoration: InputDecoration(hintText: "邮箱"),
                    ),
                    TextFormField(
                      controller: state.nameContro,
                      decoration: InputDecoration(hintText: "用户名"),
                    ),
                    TextFormField(
                      controller: state.passwordContro,
                      decoration: InputDecoration(hintText: "密码"),
                    ),
                    TextButton(
                        onPressed: () => logic.signUp(), child: Text("注册")),
                    GestureDetector(
                        onTap: () => logic.changeState(),
                        child: Text("已有帐户,登录"))
                  ],
                ),
              )
            : Container(
                child: Column(
                  children: [
                    TextFormField(
                      controller: state.emilContro,
                      decoration: InputDecoration(hintText: "邮箱"),
                    ),
                    TextFormField(
                      controller: state.passwordContro,
                      decoration: InputDecoration(hintText: "密码"),
                    ),
                    TextButton(
                        onPressed: () => logic.login(), child: Text("登录")),
                  ],
                ),
              );
      }),
    );
  }
}
