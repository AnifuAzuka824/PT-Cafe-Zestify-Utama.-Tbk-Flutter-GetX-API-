import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_aplication_cafe/Menu/checkout.dart';
import 'package:flutter_aplication_cafe/Menu/home.dart';
import 'package:flutter_aplication_cafe/Menu/inventori.dart';
import 'package:flutter_aplication_cafe/Menu/menu.dart';

class MainMenuController extends GetxController {
  static const int tabMenu = 1;
  static const int tabCheckout = 2;
  static const int tabInventori = 3;

  final RxInt selectedIndex = 0.obs;

  void changedPage(int index) {
    selectedIndex.value = index;
  }

  final List<Widget> listPages = const [
    HomePages(),
    MenuPages(),
    CheckoutPages(),
    InventoriPages(),
  ];
}
