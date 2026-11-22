import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_aplication_cafe/Controller/auth_controller.dart';
import 'package:flutter_aplication_cafe/Controller/cart_controller.dart';
import 'package:flutter_aplication_cafe/Controller/main_menu_controller.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class MainMenuPage extends StatelessWidget {
  MainMenuPage({super.key});

  final controller = Get.put(MainMenuController());

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final cart = Get.find<CartController>();

    return Obx(() {
      final admin = auth.isAdmin;
      final jumlahTab = admin ? 4 : 3;
      final index = controller.selectedIndex.value < jumlahTab
          ? controller.selectedIndex.value
          : 0;
      final badgeKeranjang = Badge(
        isLabelVisible: cart.totalItem > 0,
        label: Text('${cart.totalItem}'),
        backgroundColor: ZestifyColors.gold,
        textColor: ZestifyColors.bg,
        child: const Icon(Icons.shopping_cart_outlined),
      );

      return Scaffold(
        body: IndexedStack(
          index: index,
          children: controller.listPages.sublist(0, jumlahTab),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: ZestifyColors.border)),
          ),
          child: BottomNavigationBar(
            currentIndex: index,
            onTap: controller.changedPage,
            type: BottomNavigationBarType.fixed,
            backgroundColor: ZestifyColors.bg,
            selectedItemColor: ZestifyColors.gold,
            unselectedItemColor: const Color(0xFF666666),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: "Home",
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.restaurant_menu_outlined),
                activeIcon: Icon(Icons.restaurant_menu),
                label: "Menu",
              ),
              BottomNavigationBarItem(
                icon: badgeKeranjang,
                activeIcon: badgeKeranjang,
                label: "Checkout",
              ),
              if (admin)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_2_outlined),
                  activeIcon: Icon(Icons.inventory_2),
                  label: "Inventori",
                ),
            ],
          ),
        ),
      );
    });
  }
}
