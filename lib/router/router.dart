
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../pages/chat_page/chat_page_view.dart';
import '../pages/home_view/home_view_view.dart';
import '../pages/login_sign/login_sign_view.dart';

class ChatRouters{
  static const String chatPage = "/ChatPage";
  static const String loginSignPage = "/loginSignPage";
  static const String homePage = "/homePage";

  static final List<GetPage> getPages = [
    GetPage(name: ChatRouters.chatPage, page: () => ChatPagePage()),
    GetPage(name: ChatRouters.loginSignPage, page: () => LoginSignPage()),
    GetPage(name: ChatRouters.homePage, page: () => HomeViewPage()),
  ];
}