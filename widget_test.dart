import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_aplication_cafe/Compounent/struk_dialog.dart';
import 'package:flutter_aplication_cafe/Compounent/struk_pdf.dart';
import 'package:flutter_aplication_cafe/Controller/auth_controller.dart';
import 'package:flutter_aplication_cafe/Controller/cart_controller.dart';
import 'package:flutter_aplication_cafe/Controller/checkout_controller.dart';
import 'package:flutter_aplication_cafe/Controller/inventory_controller.dart';
import 'package:flutter_aplication_cafe/Controller/main_menu_controller.dart';
import 'package:flutter_aplication_cafe/Controller/produk_controller.dart';
import 'package:flutter_aplication_cafe/Menu/checkout.dart';
import 'package:flutter_aplication_cafe/Menu/inventori.dart';
import 'package:flutter_aplication_cafe/Models/cart_item_model.dart';
import 'package:flutter_aplication_cafe/Models/produk_model.dart';
import 'package:flutter_aplication_cafe/Models/stok_log_model.dart';
import 'package:flutter_aplication_cafe/Models/transaksi_model.dart';
import 'package:flutter_aplication_cafe/Models/user_model.dart';
import 'package:flutter_aplication_cafe/admin_config.dart';
import 'package:flutter_aplication_cafe/theme.dart';

StokLogModel catatan(DateTime waktu) => StokLogModel(
  timestamp: waktu.millisecondsSinceEpoch,
  produkId: 1,
  namaBarang: 'Avocado Toast',
  jenis: 'out',
  jumlah: 1,
  petugas: 'Kasir',
  keterangan: '',
);

TransaksiModel transaksi(List<CartItemModel> items) => TransaksiModel(
  nomorOrder: 'ZST-123456',
  waktu: DateTime.utc(2026, 10, 26, 12, 30),
  items: items,
  metode: const MetodePembayaranModel(
    kode: 'CASH',
    label: 'Tunai (Cash)',
    icon: Icons.payments_outlined,
  ),
);

CartItemModel item({int id = 1, int jumlah = 1}) => CartItemModel(
  id: id,
  namaProduk: id == 1 ? 'Avocado Toast' : 'Pasta Truffle',
  harga: id == 1 ? 50000 : 80000,
  jumlah: jumlah,
);

void aktifkanAdmin() {
  Get.find<AuthController>().userAktif.value = const UserModel(
    nama: 'Admin Pengujian',
    email: AdminConfig.email,
    passwordHash: AdminConfig.passwordHash,
  );
}

void aktifkanVip() {
  Get.find<AuthController>().userAktif.value = const UserModel(
    nama: 'Pelanggan Pengujian',
    email: 'vip@example.test',
    passwordHash: 'test-only-hash',
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory direktori;

  setUpAll(() async {
    direktori = await Directory.systemTemp.createTemp('zestify-tests-');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('plugins.flutter.io/path_provider'),
          (_) async => direktori.path,
        );
    await GetStorage.init();
  });

  setUp(() async {
    Get.testMode = true;
    await GetStorage().erase();
    Get.put(AuthController());
    Get.put(ProdukController());
    Get.put(CartController());
    Get.put(InventoryController());
    Get.put(CheckoutController());
    Get.put(MainMenuController());
  });

  tearDown(() {
    Get.closeAllSnackbars();
    Get.reset();
  });

  tearDownAll(() async {
    await GetStorage().erase();
  });

  test('formatRupiah memakai pemisah ribuan titik', () {
    expect(formatRupiah(0), 'Rp0');
    expect(formatRupiah(5000), 'Rp5.000');
    expect(formatRupiah(150000), 'Rp150.000');
    expect(formatRupiah(1250000), 'Rp1.250.000');
  });

  test('filter kategori sesuai data website', () {
    final controller = Get.find<ProdukController>();
    expect(controller.filterKategori('all').length, 12);
    expect(controller.filterKategori('bestseller').length, 5);
    expect(controller.filterKategori('food').length, 7);
    expect(controller.filterKategori('drink').length, 5);
  });

  test('pangkas log mempertahankan batas tepat dua bulan', () {
    final sekarang = DateTime(2026, 10, 26, 19, 30, 45, 123);
    final batas = DateTime(2026, 8, 26, 19, 30, 45, 123);
    final lama = catatan(batas.subtract(const Duration(milliseconds: 1)));
    final tepat = catatan(batas);
    final baru = catatan(sekarang);
    expect(InventoryController.pangkasLog([lama, tepat, baru], sekarang), [
      tepat,
      baru,
    ]);
  });

  test('pangkas log akhir bulan tidak bergeser ke bulan berikutnya', () {
    final sekarang = DateTime(2026, 4, 30, 12);
    final tepat = catatan(DateTime(2026, 2, 28, 12));
    final lama = catatan(DateTime(2026, 2, 28, 11, 59));
    expect(InventoryController.pangkasLog([lama, tepat], sekarang), [tepat]);
    final kabisat = catatan(DateTime.utc(2024, 2, 29, 12));
    expect(
      InventoryController.pangkasLog([kabisat], DateTime.utc(2024, 4, 30, 12)),
      [kabisat],
    );
  });

  test('cek stok menerima batas stok dan menolak kekurangan', () {
    expect(
      InventoryController.cekKetersediaan({1: 2}, [item(jumlah: 2)]),
      isNull,
    );
    expect(
      InventoryController.cekKetersediaan({1: 2}, [item(jumlah: 3)]),
      contains('Tersedia: 2 porsi'),
    );
    expect(
      InventoryController.cekKetersediaan({}, [item()]),
      contains('Tersedia: 0 porsi'),
    );
  });

  test('penjualan mengurangi stok dan menyimpan log Pengeluaran', () {
    final inv = Get.find<InventoryController>();
    inv.stok[1] = 5;
    final order = transaksi([item(jumlah: 2)]);
    expect(inv.catatPenjualan(order, 'Pelanggan'), isNull);
    expect(inv.stokDari(1), 3);
    expect(inv.log.single.jenis, 'out');
    expect(inv.log.single.jumlah, 2);
    expect(inv.log.single.petugas, 'Kasir');
    expect(inv.log.single.keterangan, contains(order.nomorOrder));
    expect(GetStorage().read<Map>('zestifyInventory')?['1'], 3);
    expect(GetStorage().read<List>('zestifyStockLog')?.length, 1);
  });

  test('stok kurang tidak mengubah stok atau membuat log sebagian', () {
    final inv = Get.find<InventoryController>();
    inv.stok[1] = 5;
    inv.stok[2] = 1;
    final order = transaksi([item(jumlah: 2), item(id: 2, jumlah: 2)]);
    expect(inv.catatPenjualan(order, 'Pelanggan'), isNotNull);
    expect(inv.stokDari(1), 5);
    expect(inv.stokDari(2), 1);
    expect(inv.log, isEmpty);
  });

  test('keranjang tambah kurang hapus dan kosongkan memperbarui total', () {
    final cart = Get.find<CartController>();
    final pertama = item();
    cart.items.add(pertama);
    cart.tambahJumlah(pertama);
    expect(cart.totalItem, 2);
    expect(cart.totalHarga, 100000);
    cart.kurang(pertama);
    expect(cart.totalItem, 1);
    cart.kurang(pertama);
    expect(cart.items, isEmpty);
    cart.items.add(item());
    cart.hapus(cart.items.first);
    expect(cart.items, isEmpty);
    cart.items.add(item());
    cart.kosongkan();
    expect(GetStorage().read<List>('zestifyCart'), isEmpty);
  });

  test('admin memerlukan email dan hash yang sesuai', () {
    final auth = Get.find<AuthController>();
    aktifkanVip();
    expect(auth.isAdmin, isFalse);
    aktifkanAdmin();
    expect(auth.isAdmin, isTrue);
    auth.userAktif.value = const UserModel(
      nama: 'Bukan Admin',
      email: AdminConfig.email,
      passwordHash: 'test-only-wrong-hash',
    );
    expect(auth.isAdmin, isFalse);
  });

  test('riwayat terbaru dibatasi 100 dan dapat dicari menurut petugas', () {
    final inv = Get.find<InventoryController>();
    final sekarang = DateTime.now();
    inv.log.assignAll(
      List.generate(110, (i) => catatan(sekarang.add(Duration(seconds: i)))),
    );
    expect(inv.riwayatTampil.length, 100);
    expect(inv.riwayatTampil.first.timestamp, inv.log.last.timestamp);
    inv.kataCari.value = 'KASIR';
    expect(inv.riwayatTampil.length, 100);
    inv.kataCari.value = 'tidak ada';
    expect(inv.riwayatTampil, isEmpty);
  });

  test('nomor order dan total struk sesuai format', () {
    expect(
      TransaksiModel.buatNomorOrder(DateTime.now()),
      matches(r'^ZST-\d{6}$'),
    );
    final order = transaksi([item(jumlah: 2), item(id: 2)]);
    expect(order.total, 180000);
    expect(order.tanggalLabel, '26 Oktober 2026');
    expect(order.waktuLabel, '19.30 WIB');
  });

  test('struk PDF pendek dan 12 menu dapat dibuat', () async {
    for (final order in [
      transaksi([item()]),
      transaksi(
        Get.find<ProdukController>().dataProduk
            .map(
              (p) => CartItemModel(
                id: p.id,
                namaProduk: p.namaProduk,
                harga: p.harga,
                jumlah: 2,
              ),
            )
            .toList(),
      ),
    ]) {
      final bytes = await buatStrukPdf(order);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
      expect(bytes.length, greaterThan(1000));
    }
  });

  testWidgets('VIP tidak dapat mengakses inventori atau mengubah stok manual', (
    tester,
  ) async {
    aktifkanVip();
    await tester.pumpWidget(
      GetMaterialApp(
        theme: ZestifyTheme.dark,
        home: const Scaffold(body: InventoriPages()),
      ),
    );
    expect(find.text('Akses Khusus Admin'), findsOneWidget);
    final inv = Get.find<InventoryController>();
    final awal = inv.stokDari(1);
    inv.terimaProdukId.value = 1;
    inv.terimaQtyController.text = '10';
    inv.simpanPenerimaan();
    inv.keluarProdukId.value = 1;
    inv.keluarQtyController.text = '1';
    inv.simpanPengeluaran();
    await tester.pumpAndSettle();
    expect(inv.stokDari(1), awal);
    expect(inv.log, isEmpty);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('inventori admin 320px dan badge kritis tanpa overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    aktifkanAdmin();
    Get.find<InventoryController>().stok[1] = 5;
    await tester.pumpWidget(
      GetMaterialApp(
        theme: ZestifyTheme.dark,
        home: const Scaffold(body: InventoriPages()),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Kritis'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Kritis'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('struk 320px tidak overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      GetMaterialApp(
        theme: ZestifyTheme.dark,
        home: Scaffold(
          body: StrukDialog(transaksi: transaksi([item(jumlah: 99)])),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Pembayaran Berhasil!'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('QR demo dapat dibatalkan tanpa mengurangi stok atau keranjang', (
    tester,
  ) async {
    aktifkanVip();
    final cart = Get.find<CartController>();
    final checkout = Get.find<CheckoutController>();
    final inv = Get.find<InventoryController>();
    cart.items.add(item());
    checkout.pilihMetode(checkout.metodePembayaran[1]);
    final awal = inv.stokDari(1);
    await tester.pumpWidget(
      GetMaterialApp(
        theme: ZestifyTheme.dark,
        home: const Scaffold(body: CheckoutPages()),
      ),
    );
    final pembayaran = checkout.bayarSekarang();
    await tester.pumpAndSettle();
    expect(find.text('Scan QRIS'), findsOneWidget);
    await tester.ensureVisible(find.text('Batalkan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Batalkan'));
    await tester.pumpAndSettle();
    await pembayaran.timeout(const Duration(seconds: 5));
    expect(inv.stokDari(1), awal);
    expect(inv.log, isEmpty);
    expect(cart.totalItem, 1);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('konfirmasi QR demo menghasilkan struk dan mengurangi stok', (
    tester,
  ) async {
    aktifkanVip();
    final cart = Get.find<CartController>();
    final checkout = Get.find<CheckoutController>();
    final inv = Get.find<InventoryController>();
    cart.items.add(item(jumlah: 2));
    checkout.pilihMetode(checkout.metodePembayaran[1]);
    final awal = inv.stokDari(1);
    await tester.pumpWidget(
      GetMaterialApp(
        theme: ZestifyTheme.dark,
        home: const Scaffold(body: CheckoutPages()),
      ),
    );
    final pembayaran = checkout.bayarSekarang();
    await tester.pumpAndSettle();
    expect(inv.stokDari(1), awal);
    await tester.ensureVisible(find.text('Konfirmasi Pembayaran Demo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Konfirmasi Pembayaran Demo'));
    await tester.pumpAndSettle();
    expect(find.text('Pembayaran Berhasil!'), findsOneWidget);
    expect(inv.stokDari(1), awal - 2);
    expect(inv.log.single.keterangan, contains('QRIS'));
    expect(cart.items, isEmpty);
    await tester.ensureVisible(find.text('Kembali ke Menu').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kembali ke Menu').last);
    await tester.pumpAndSettle();
    await pembayaran.timeout(const Duration(seconds: 5));
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('stok diperiksa ulang setelah dialog QR', (tester) async {
    aktifkanVip();
    final cart = Get.find<CartController>();
    final checkout = Get.find<CheckoutController>();
    final inv = Get.find<InventoryController>();
    cart.items.add(item(jumlah: 2));
    checkout.pilihMetode(checkout.metodePembayaran[1]);
    await tester.pumpWidget(
      GetMaterialApp(
        theme: ZestifyTheme.dark,
        home: const Scaffold(body: CheckoutPages()),
      ),
    );
    final pembayaran = checkout.bayarSekarang();
    await tester.pumpAndSettle();
    inv.stok[1] = 1;
    await tester.ensureVisible(find.text('Konfirmasi Pembayaran Demo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Konfirmasi Pembayaran Demo'));
    await tester.pumpAndSettle();
    await pembayaran.timeout(const Duration(seconds: 5));
    expect(find.text('Pembayaran Berhasil!'), findsNothing);
    expect(inv.stokDari(1), 1);
    expect(inv.log, isEmpty);
    expect(cart.totalItem, 2);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('admin penerimaan dan pengeluaran menyimpan stok dan log', (
    tester,
  ) async {
    aktifkanAdmin();
    await tester.pumpWidget(
      GetMaterialApp(
        theme: ZestifyTheme.dark,
        home: const Scaffold(body: InventoriPages()),
      ),
    );
    final inv = Get.find<InventoryController>();
    final awal = inv.stokDari(1);
    inv.terimaProdukId.value = 1;
    inv.terimaQtyController.text = '10';
    inv.terimaPetugasController.text = 'Operator Pengujian';
    inv.terimaKeteranganController.text = 'Restock';
    inv.simpanPenerimaan();
    await tester.pumpAndSettle();
    expect(inv.stokDari(1), awal + 10);
    expect(inv.log.single.jenis, 'in');
    expect(inv.log.single.petugas, 'Operator Pengujian');
    expect(inv.terimaProdukId.value, isNull);
    inv.keluarProdukId.value = 1;
    inv.keluarQtyController.text = '3';
    inv.keluarKeteranganController.text = 'Bahan rusak';
    inv.simpanPengeluaran();
    await tester.pumpAndSettle();
    expect(inv.stokDari(1), awal + 7);
    expect(inv.log.last.jenis, 'out');
    expect(inv.log.last.keterangan, 'Bahan rusak');
    expect(inv.totalPenerimaan, 10);
    expect(inv.totalPengeluaran, 3);
    expect(inv.keluarProdukId.value, isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('validasi kuantitas dan stok menolak input admin tidak valid', (
    tester,
  ) async {
    aktifkanAdmin();
    await tester.pumpWidget(
      GetMaterialApp(
        theme: ZestifyTheme.dark,
        home: const Scaffold(body: InventoriPages()),
      ),
    );
    final inv = Get.find<InventoryController>();
    final awal = inv.stokDari(1);
    inv.simpanPenerimaan();
    await tester.pumpAndSettle();
    inv.terimaProdukId.value = 1;
    inv.terimaQtyController.text = '0';
    inv.simpanPenerimaan();
    await tester.pumpAndSettle();
    inv.keluarProdukId.value = 1;
    inv.keluarQtyController.text = '${awal + 1}';
    inv.simpanPengeluaran();
    await tester.pumpAndSettle();
    expect(inv.stokDari(1), awal);
    expect(inv.log, isEmpty);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'bayar tunai hanya sekali mengurangi stok dan menampilkan struk',
    (tester) async {
      aktifkanVip();
      final cart = Get.find<CartController>();
      final checkout = Get.find<CheckoutController>();
      final inv = Get.find<InventoryController>();
      cart.items.add(item(jumlah: 2));
      checkout.pilihMetode(checkout.metodePembayaran.first);
      final awal = inv.stokDari(1);
      await tester.pumpWidget(
        GetMaterialApp(
          theme: ZestifyTheme.dark,
          home: const Scaffold(body: CheckoutPages()),
        ),
      );
      final pembayaran = checkout.bayarSekarang();
      await checkout.bayarSekarang();
      await tester.pumpAndSettle();
      expect(find.text('Pembayaran Berhasil!'), findsOneWidget);
      expect(inv.stokDari(1), awal - 2);
      expect(inv.log.length, 1);
      expect(cart.items, isEmpty);
      expect(checkout.metodeTerpilih.value, isNull);
      await tester.ensureVisible(find.text('Kembali ke Menu').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kembali ke Menu').last);
      await tester.pumpAndSettle();
      await pembayaran.timeout(const Duration(seconds: 5));
      expect(
        Get.find<MainMenuController>().selectedIndex.value,
        MainMenuController.tabMenu,
      );
      await tester.pumpWidget(const SizedBox());
    },
  );
}
