import 'package:flutter_aplication_cafe/Models/format_waktu.dart';

class StokLogModel {
  final int timestamp;
  final int produkId;
  final String namaBarang;
  final String jenis;
  final int jumlah;
  final String petugas;
  final String keterangan;

  const StokLogModel({
    required this.timestamp,
    required this.produkId,
    required this.namaBarang,
    required this.jenis,
    required this.jumlah,
    required this.petugas,
    required this.keterangan,
  });

  bool get isMasuk => jenis == 'in';

  DateTime get waktu => DateTime.fromMillisecondsSinceEpoch(timestamp);

  String get labelWaktu => formatTanggalPendekJam(waktu);

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'itemId': produkId,
        'itemName': namaBarang,
        'type': jenis,
        'qty': jumlah,
        'operator': petugas,
        'note': keterangan,
      };

  factory StokLogModel.fromJson(Map<String, dynamic> json) => StokLogModel(
        timestamp: json['timestamp'] as int,
        produkId: json['itemId'] as int,
        namaBarang: json['itemName'] as String,
        jenis: json['type'] as String,
        jumlah: json['qty'] as int,
        petugas: json['operator'] as String,
        keterangan: (json['note'] ?? '') as String,
      );
}
