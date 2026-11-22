import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_aplication_cafe/Controller/auth_controller.dart';
import 'package:flutter_aplication_cafe/Controller/cart_controller.dart';
import 'package:flutter_aplication_cafe/Controller/checkout_controller.dart';
import 'package:flutter_aplication_cafe/Controller/inventory_controller.dart';
import 'package:flutter_aplication_cafe/Controller/produk_controller.dart';
import 'package:flutter_aplication_cafe/routes.dart';
import 'package:flutter_aplication_cafe/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  Get.put(AuthController(), permanent: true);
  Get.put(ProdukController(), permanent: true);
  Get.put(CartController(), permanent: true);
  Get.put(InventoryController(), permanent: true);
  Get.put(CheckoutController(), permanent: true);

  runApp(const ZestifyApp());
}

class ZestifyApp extends StatelessWidget {
  const ZestifyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return GetMaterialApp(
      title: "Zestify Café",
      debugShowCheckedModeBanner: false,
      theme: ZestifyTheme.dark,
      initialRoute: auth.isLoggedIn ? Routes.mainmenu : Routes.login,
      getPages: Routes.myPages,
    );
  }
}
