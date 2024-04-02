import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_view_logic.dart';

class HomeViewPage extends StatelessWidget {
  HomeViewPage({Key? key}) : super(key: key);

  final logic = Get.put(HomeViewLogic());
  final state = Get
      .find<HomeViewLogic>()
      .state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("首页"),
      ),
      body: GetBuilder<HomeViewLogic>(builder: (logic) {
        return Column(
          children: [
            GestureDetector(
              onTap: () => logic.loginOut(),
              child: Container(
                  color: Colors.yellow,
                  width: double.infinity,
                  height: 50,
                  child: Center(child: Text("退出"))),
            ),
            GestureDetector(
              onTap: () => logic.saveUser(),
              child: Container(
                  margin: EdgeInsets.only(top: 20),
                  color: Colors.grey,
                  width: double.infinity,
                  height: 50,
                  child: Center(child: Text("保存用户数据到数据库"))),
            ),
            GestureDetector(
              onTap: () => logic.getAllUser(),
              child: Container(
                  margin: EdgeInsets.only(top: 20),
                  color: Colors.grey,
                  width: double.infinity,
                  height: 50,
                  child: Center(child: Text("获取全部保存用户"))),
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: state.controller,
                  ),
                ),
                SizedBox(width: 30,
                    child: IconButton(onPressed: () => logic.toSearchUser(),
                        icon: Icon(Icons.search)))
              ],
            ),
            state.searchUserList.isNotEmpty ?
            Expanded(
              child: ListView.builder(
                  itemCount: state.searchUserList.length, itemBuilder: (context, index) {
                    var info = state.searchUserList[index];
                return SizedBox(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(info.userName),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(info.userID),
                      ),
                      const Spacer(),
                      IconButton(onPressed: () => logic.addFriends(info),
                          icon: Icon(Icons.add))
                    ],
                  ),
                );
              }),
            ) : Container()
          ],
        );
      }),
    );
  }
}
