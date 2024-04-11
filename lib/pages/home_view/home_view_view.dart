import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_view_logic.dart';

class HomeViewPage extends StatelessWidget {
  HomeViewPage({Key? key}) : super(key: key);

  final logic = Get.put(HomeViewLogic());
  final state = Get.find<HomeViewLogic>().state;

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
                SizedBox(
                    width: 30,
                    child: IconButton(
                        onPressed: () => logic.toSearchUser(),
                        icon: Icon(Icons.search)))
              ],
            ),
            state.searchFriendList.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: state.searchFriendList.length,
                        itemBuilder: (context, index) {
                          var friendItem = state.searchFriendList[index];
                          return SizedBox(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(friendItem.userName),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(friendItem.userID),
                                ),
                                const Spacer(),
                                IconButton(
                                    onPressed: () =>
                                        logic.addFriends(friendItem),
                                    icon: Icon(Icons.add))
                              ],
                            ),
                          );
                        }),
                  )
                : Container(),
            const Text("好友列表"),
            state.chatHeadList.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: state.chatHeadList.length,
                        itemBuilder: (context, index) {
                          var friendItem = state.chatHeadList[index];
                          return GestureDetector(
                            onTap: () => logic.toChat(state.friendList[index]),
                            child: SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(friendItem.displayName),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(friendItem.receiveId),
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                  Text(
                                    state.chatHeadList[index].message,
                                    style: const TextStyle(color: Colors.yellow),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                : Container(),
          ],
        );
      }),
    );
  }
}
