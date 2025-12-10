import 'package:get/get.dart';
import '../bindings/app_binding.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/chat_screen.dart';

class AppRoutes {
  static const home = '/';
  static const chat = '/chat';

  static final pages = [
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      binding: AppBinding(),
    ),
    GetPage(
      name: chat,
      page: () => const ChatScreen(),
    ),
  ];
}