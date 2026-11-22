import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/Controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_aplication_cafe/Compounent/zestify_toast.dart';
import 'package:flutter_aplication_cafe/Controller/produk_controller.dart';
import 'package:flutter_aplication_cafe/Models/cart_item_model.dart';
import 'package:flutter_aplication_cafe/Models/format_waktu.dart';
import 'package:flutter_aplication_cafe/Models/produk_model.dart';
import 'package:flutter_aplication_cafe/Models/stok_log_model.dart';
import 'package:flutter_aplication_cafe/Models/transaksi_model.dart';

class InventoryController extends GetxController {
  static const String _stokKey = 'zestifyInventory';
  static const String _logKey = 'zestifyStockLog';
  static const int batasRendah = 20;
  static const int batasKritis = 10;
  static const int masaSimpanBulan = 2;
  static const int maksRiwayat = 100;

  static const List<int> dataPendapatan = [
    8400000,
    9200000,
    7800000,
    10500000,
    11200000,
    9800000,
  ];
  static const List<int> dataPenerimaan = [320, 280, 310, 400, 380, 350];
  static const List<int> dataPengeluaran = [295, 260, 300, 385, 360, 330];

  final GetStorage _box = GetStorage();
  Timer? _retentionTimer;

  final RxMap<int, int> stok = <int, int>{}.obs;
  final RxList<StokLogModel> log = <StokLogModel>[].obs;
  final RxString kataCari = ''.obs;

  final Rxn<int> terimaProdukId = Rxn<int>();
  final terimaQtyController = TextEditingController();
  final terimaPetugasController = TextEditingController();
  final terimaKeteranganController = TextEditingController();

  final Rxn<int> keluarProdukId = Rxn<int>();
  final keluarQtyController = TextEditingController();
  final keluarPetugasController = TextEditingController();
  final keluarKeteranganController = TextEditingController();

  final cariController = TextEditingController();

  List<ProdukModel> get daftarProduk => Get.find<ProdukController>().dataProduk;

  @override
  void onInit() {
    super.onInit();
    _muatStok();
    _muatLog();
    _retentionTimer = Timer.periodic(const Duration(hours: 1), (_) {
      final tersisa = pangkasLog(log, DateTime.now());
      if (tersisa.length != log.length) {
        log.assignAll(tersisa);
        _simpanLog();
      }
    });
  }

  void _muatStok() {
    final Map? raw = _box.read<Map>(_stokKey);
    final produk = daftarProduk;
    for (var i = 0; i < produk.length; i++) {
      final tersimpan = raw?['${produk[i].id}'];
      stok[produk[i].id] = tersimpan is int ? tersimpan : 40 + (i * 7 % 60);
    }
    _simpanStok();
  }

  void _muatLog() {
    final List? raw = _box.read<List>(_logKey);
    final semua = (raw ?? [])
        .map((e) => StokLogModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    log.assignAll(pangkasLog(semua, DateTime.now()));
    _simpanLog();
  }

  void _simpanStok() {
    _box.write(_stokKey, stok.map((id, qty) => MapEntry('$id', qty)));
  }

  void _simpanLog() {
    _box.write(_logKey, log.map((l) => l.toJson()).toList());
  }

  static List<StokLogModel> pangkasLog(
    List<StokLogModel> semua,
    DateTime sekarang,
  ) {
    final buatWaktu = sekarang.isUtc ? DateTime.utc : DateTime.new;
    final bulan = buatWaktu(sekarang.year, sekarang.month - masaSimpanBulan);
    final hariTerakhir = buatWaktu(bulan.year, bulan.month + 1, 0).day;
    final batas = buatWaktu(
      bulan.year,
      bulan.month,
      min(sekarang.day, hariTerakhir),
      sekarang.hour,
      sekarang.minute,
      sekarang.second,
      sekarang.millisecond,
      sekarang.microsecond,
    );
    return semua.where((l) => !l.waktu.isBefore(batas)).toList();
  }

  static String? cekKetersediaan(
    Map<int, int> stok,
    List<CartItemModel> items,
  ) {
    for (final item in items) {
      final tersedia = stok[item.id] ?? 0;
      if (item.jumlah > tersedia) {
        return 'Stok ${item.namaProduk} tidak mencukupi. Tersedia: $tersedia porsi.';
      }
    }
    return null;
  }

  ProdukModel? _produk(int? id) =>
      daftarProduk.firstWhereOrNull((p) => p.id == id);

  int stokDari(int id) => stok[id] ?? 0;

  void _catat({
    required ProdukModel produk,
    required String jenis,
    required int jumlah,
    required String petugas,
    required String keterangan,
  }) {
    final perubahan = jenis == 'in' ? jumlah : -jumlah;
    stok[produk.id] = stokDari(produk.id) + perubahan;
    log.add(
      StokLogModel(
        timestamp: DateTime.now().millisecondsSinceEpoch,
        produkId: produk.id,
        namaBarang: produk.namaProduk,
        jenis: jenis,
        jumlah: jumlah,
        petugas: petugas,
        keterangan: keterangan,
      ),
    );
  }

  void _simpanSemua() {
    log.assignAll(pangkasLog(log, DateTime.now()));
    _simpanStok();
    _simpanLog();
  }

  void simpanPenerimaan() {
    if (!_izinkanAdmin()) return;
    final produk = _produk(terimaProdukId.value);
    final jumlah = int.tryParse(terimaQtyController.text.trim()) ?? 0;
    if (produk == null) {
      showZestifyToast(
        'Pilih nama barang terlebih dahulu.',
        icon: Icons.error_outline,
      );
      return;
    }
    if (jumlah < 1) {
      showZestifyToast('Kuantitas harus minimal 1.', icon: Icons.error_outline);
      return;
    }
    _catat(
      produk: produk,
      jenis: 'in',
      jumlah: jumlah,
      petugas: _petugas(terimaPetugasController),
      keterangan: terimaKeteranganController.text.trim(),
    );
    _simpanSemua();
    _resetForm(terimaProdukId, [
      terimaQtyController,
      terimaPetugasController,
      terimaKeteranganController,
    ]);
    showZestifyToast(
      '$jumlah porsi ${produk.namaProduk} berhasil diterima.',
      icon: Icons.move_to_inbox,
    );
  }

  void simpanPengeluaran() {
    if (!_izinkanAdmin()) return;
    final produk = _produk(keluarProdukId.value);
    final jumlah = int.tryParse(keluarQtyController.text.trim()) ?? 0;
    if (produk == null) {
      showZestifyToast(
        'Pilih nama barang terlebih dahulu.',
        icon: Icons.error_outline,
      );
      return;
    }
    if (jumlah < 1) {
      showZestifyToast('Kuantitas harus minimal 1.', icon: Icons.error_outline);
      return;
    }
    final tersedia = stokDari(produk.id);
    if (jumlah > tersedia) {
      showZestifyToast(
        'Stok ${produk.namaProduk} tidak mencukupi. Tersedia: $tersedia porsi.',
        icon: Icons.error_outline,
      );
      return;
    }
    _catat(
      produk: produk,
      jenis: 'out',
      jumlah: jumlah,
      petugas: _petugas(keluarPetugasController),
      keterangan: keluarKeteranganController.text.trim(),
    );
    _simpanSemua();
    _resetForm(keluarProdukId, [
      keluarQtyController,
      keluarPetugasController,
      keluarKeteranganController,
    ]);
    showZestifyToast(
      '$jumlah porsi ${produk.namaProduk} berhasil dicatat keluar.',
      icon: Icons.outbox,
    );
  }

  String? catatPenjualan(TransaksiModel transaksi, String namaPelanggan) {
    final error = cekKetersediaan(stok, transaksi.items);
    if (error != null) return error;
    for (final item in transaksi.items) {
      final produk = _produk(item.id)!;
      _catat(
        produk: produk,
        jenis: 'out',
        jumlah: item.jumlah,
        petugas: 'Kasir',
        keterangan:
            'Penjualan ${transaksi.nomorOrder} (${transaksi.metode.label}) a.n. $namaPelanggan',
      );
    }
    _simpanSemua();
    return null;
  }

  bool _izinkanAdmin() {
    if (Get.find<AuthController>().isAdmin) return true;
    showZestifyToast('Akses khusus admin.', icon: Icons.lock_outline);
    return false;
  }

  String _petugas(TextEditingController c) =>
      c.text.trim().isEmpty ? 'Admin' : c.text.trim();

  void _resetForm(Rxn<int> pilihan, List<TextEditingController> fields) {
    pilihan.value = null;
    for (final f in fields) {
      f.clear();
    }
  }

  int get totalPenerimaan =>
      log.where((l) => l.isMasuk).fold(0, (s, l) => s + l.jumlah);

  int get totalPengeluaran =>
      log.where((l) => !l.isMasuk).fold(0, (s, l) => s + l.jumlah);

  int get totalStok => stok.values.fold(0, (s, q) => s + q);

  int get transaksiHariIni {
    final hariIni = DateTime.now();
    return log.where((l) => hariSama(l.waktu, hariIni)).length;
  }

  List<StokLogModel> get riwayatTampil {
    final cari = kataCari.value.trim().toLowerCase();
    return log.reversed
        .where(
          (l) =>
              cari.isEmpty ||
              l.namaBarang.toLowerCase().contains(cari) ||
              l.petugas.toLowerCase().contains(cari),
        )
        .take(maksRiwayat)
        .toList();
  }

  List<String> get labelBulan {
    final now = DateTime.now();
    return List.generate(6, (i) {
      final t = DateTime(now.year, now.month - 5 + i);
      return "${namaBulanPendek[t.month - 1]} '${(t.year % 100).toString().padLeft(2, '0')}";
    });
  }

  @override
  void onClose() {
    _retentionTimer?.cancel();
    for (final c in [
      terimaQtyController,
      terimaPetugasController,
      terimaKeteranganController,
      keluarQtyController,
      keluarPetugasController,
      keluarKeteranganController,
      cariController,
    ]) {
      c.dispose();
    }
    super.onClose();
  }
}
