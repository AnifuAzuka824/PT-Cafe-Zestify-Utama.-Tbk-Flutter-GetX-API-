import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/Models/cart_item_model.dart';
import 'package:flutter_aplication_cafe/Models/format_waktu.dart';

class MetodePembayaranModel {
  final String kode;
  final String label;
  final IconData icon;

  const MetodePembayaranModel({
    required this.kode,
    required this.label,
    required this.icon,
  });
}

class TransaksiModel {
  final String nomorOrder;
  final DateTime waktu;
  final List<CartItemModel> items;
  final MetodePembayaranModel metode;

  const TransaksiModel({
    required this.nomorOrder,
    required this.waktu,
    required this.items,
    required this.metode,
  });

  int get total => items.fold(0, (sum, item) => sum + item.subtotal);

  DateTime get waktuWib => waktu.toUtc().add(const Duration(hours: 7));

  String get tanggalLabel => formatTanggalPanjang(waktuWib);

  String get waktuLabel => '${formatJam(waktuWib)} WIB';

  static String buatNomorOrder(DateTime t) {
    final ms = t.millisecondsSinceEpoch.toString();
    return 'ZST-${ms.substring(ms.length - 6)}';
  }
}
