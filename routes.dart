import 'package:get/get.dart';
import 'package:flutter_aplication_cafe/Pages/detail_menu_page.dart';
import 'package:flutter_aplication_cafe/Pages/login_page.dart';
import 'package:flutter_aplication_cafe/Pages/main_menu_page.dart';

class Routes {
  static const String login = '/login';
  static const String mainmenu = '/mainmenupage';
  static const String detailmenu = '/detail_menu';

  static final myPages = [
    GetPage(name: login, page: () => const LoginPage()),
    GetPage(name: mainmenu, page: () => MainMenuPage()),
    GetPage(name: detailmenu, page: () => const DetailMenuPage()),
  ];
}
