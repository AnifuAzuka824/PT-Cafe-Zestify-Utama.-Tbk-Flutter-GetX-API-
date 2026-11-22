import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:flutter_aplication_cafe/Compounent/qris_dialog.dart';
import 'package:flutter_aplication_cafe/Compounent/struk_dialog.dart';
import 'package:flutter_aplication_cafe/Compounent/struk_pdf.dart';
import 'package:flutter_aplication_cafe/Compounent/zestify_toast.dart';
import 'package:flutter_aplication_cafe/Controller/auth_controller.dart';
import 'package:flutter_aplication_cafe/Controller/cart_controller.dart';
import 'package:flutter_aplication_cafe/Controller/inventory_controller.dart';
import 'package:flutter_aplication_cafe/Controller/main_menu_controller.dart';
import 'package:flutter_aplication_cafe/Models/cart_item_model.dart';
import 'package:flutter_aplication_cafe/Models/transaksi_model.dart';

class CheckoutController extends GetxController {
  final List<MetodePembayaranModel> metodePembayaran = const [
    MetodePembayaranModel(
      kode: 'CASH',
      label: 'Tunai (Cash)',
      icon: Icons.payments_outlined,
    ),
    MetodePembayaranModel(kode: 'QRIS', label: 'QRIS', icon: Icons.qr_code_2),
    MetodePembayaranModel(
      kode: 'DEBIT_BCA',
      label: 'Kartu Debit BCA',
      icon: Icons.credit_card,
    ),
    MetodePembayaranModel(
      kode: 'DEBIT_MANDIRI',
      label: 'Kartu Debit Mandiri',
      icon: Icons.credit_card,
    ),
    MetodePembayaranModel(
      kode: 'TRANSFER',
      label: 'Transfer Bank',
      icon: Icons.account_balance,
    ),
  ];

  final Rxn<MetodePembayaranModel> metodeTerpilih =
      Rxn<MetodePembayaranModel>();

  CartController get _cart => Get.find<CartController>();
  InventoryController get _inventory => Get.find<InventoryController>();
  bool _sedangBayar = false;

  void pilihMetode(MetodePembayaranModel metode) {
    metodeTerpilih.value = metode;
  }

  String? _validasi() {
    if (!Get.find<AuthController>().isLoggedIn) {
      return 'Silakan login terlebih dahulu.';
    }
    if (_cart.items.isEmpty) return 'Keranjang masih kosong!';
    if (metodeTerpilih.value == null) {
      return 'Pilih metode pembayaran terlebih dahulu.';
    }
    return InventoryController.cekKetersediaan(_inventory.stok, _cart.items);
  }

  Future<void> bayarSekarang() async {
    if (_sedangBayar) return;
    final error = _validasi();
    if (error != null) {
      showZestifyToast(error, icon: Icons.error_outline);
      return;
    }

    final sekarang = DateTime.now();
    final transaksi = TransaksiModel(
      nomorOrder: TransaksiModel.buatNomorOrder(sekarang),
      waktu: sekarang,
      items: _cart.items
          .map(
            (i) => CartItemModel(
              id: i.id,
              namaProduk: i.namaProduk,
              harga: i.harga,
              jumlah: i.jumlah,
            ),
          )
          .toList(),
      metode: metodeTerpilih.value!,
    );

    _sedangBayar = true;
    try {
      if (transaksi.metode.kode == 'QRIS') {
        final dikonfirmasi = await Get.dialog<bool>(
          QrisDialog(
            transaksi: transaksi,
            onSudahBayar: () => Get.back(result: true),
          ),
          barrierDismissible: false,
        );
        if (dikonfirmasi != true) return;
      }
      await _selesaikan(transaksi);
    } finally {
      _sedangBayar = false;
    }
  }

  Future<void> _selesaikan(TransaksiModel transaksi) async {
    final nama = Get.find<AuthController>().userAktif.value!.nama;
    final error = _inventory.catatPenjualan(transaksi, nama);
    if (error != null) {
      showZestifyToast(error, icon: Icons.error_outline);
      return;
    }
    _cart.kosongkan();
    metodeTerpilih.value = null;
    await Get.dialog(
      StrukDialog(transaksi: transaksi),
      barrierDismissible: false,
    );
  }

  Future<void> cetakStruk(TransaksiModel transaksi) {
    return Printing.layoutPdf(
      name: 'Struk-${transaksi.nomorOrder}',
      onLayout: (_) => buatStrukPdf(transaksi),
    );
  }

  void kembaliKeMenu() {
    Get.back();
    Get.find<MainMenuController>().changedPage(MainMenuController.tabMenu);
  }
}
