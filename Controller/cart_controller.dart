import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_aplication_cafe/Compounent/zestify_toast.dart';
import 'package:flutter_aplication_cafe/Models/cart_item_model.dart';
import 'package:flutter_aplication_cafe/Models/produk_model.dart';

class CartController extends GetxController {
  static const String _cartKey = 'zestifyCart';
  final GetStorage _box = GetStorage();

  final RxList<CartItemModel> items = <CartItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    final List? raw = _box.read<List>(_cartKey);
    if (raw != null) {
      items.assignAll(
        raw.map((e) => CartItemModel.fromJson(Map<String, dynamic>.from(e))),
      );
    }
  }

  int get totalItem => items.fold(0, (sum, item) => sum + item.jumlah);

  int get totalHarga => items.fold(0, (sum, item) => sum + item.subtotal);

  void tambah(ProdukModel produk) {
    final index = items.indexWhere((item) => item.id == produk.id);
    if (index >= 0) {
      items[index].jumlah++;
      items.refresh();
    } else {
      items.add(
        CartItemModel(
          id: produk.id,
          namaProduk: produk.namaProduk,
          harga: produk.harga,
        ),
      );
    }
    _simpan();
    showZestifyToast(
      '${produk.namaProduk} ditambahkan ke keranjang',
      icon: Icons.shopping_bag,
    );
  }

  void tambahJumlah(CartItemModel item) {
    item.jumlah++;
    items.refresh();
    _simpan();
  }

  void kurang(CartItemModel item) {
    if (item.jumlah <= 1) {
      items.remove(item);
    } else {
      item.jumlah--;
      items.refresh();
    }
    _simpan();
  }

  void hapus(CartItemModel item) {
    items.remove(item);
    _simpan();
  }

  void kosongkan() {
    items.clear();
    _simpan();
  }

  void _simpan() {
    _box.write(_cartKey, items.map((item) => item.toJson()).toList());
  }
}
