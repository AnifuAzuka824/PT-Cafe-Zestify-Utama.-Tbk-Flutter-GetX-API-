import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_aplication_cafe/Compounent/inventori_chart.dart';
import 'package:flutter_aplication_cafe/Compounent/panel_card.dart';
import 'package:flutter_aplication_cafe/Compounent/riwayat_stok_table.dart';
import 'package:flutter_aplication_cafe/Compounent/stat_card.dart';
import 'package:flutter_aplication_cafe/Compounent/stok_form.dart';
import 'package:flutter_aplication_cafe/Compounent/stok_mini_card.dart';
import 'package:flutter_aplication_cafe/Controller/auth_controller.dart';
import 'package:flutter_aplication_cafe/Controller/inventory_controller.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class InventoriPages extends StatelessWidget {
  const InventoriPages({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final inv = Get.find<InventoryController>();

    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => Obx(() {
          if (!auth.isAdmin) return const _AksesDitolak();
          final lebar = constraints.maxWidth;
          final kolomStat = lebar >= 700 ? 4 : 2;
          final kolomStok = ((lebar - 54) / 160).floor().clamp(1, 6);
          final formBerdampingan = lebar >= 760;

          final formTerima = StokForm(
            judul: 'Penerimaan Barang',
            icon: Icons.arrow_circle_down,
            warna: ZestifyColors.green,
            produk: inv.daftarProduk,
            stokDari: inv.stokDari,
            pilihan: inv.terimaProdukId,
            qtyController: inv.terimaQtyController,
            petugasController: inv.terimaPetugasController,
            keteranganController: inv.terimaKeteranganController,
            hintPetugas: 'Nama operator penerimaan',
            labelKeterangan: 'Keterangan',
            hintKeterangan: 'Misal: Restock dari supplier',
            labelTombol: 'Simpan Penerimaan',
            onSimpan: inv.simpanPenerimaan,
          );
          final formKeluar = StokForm(
            judul: 'Pengeluaran Barang',
            icon: Icons.arrow_circle_up,
            warna: ZestifyColors.red,
            produk: inv.daftarProduk,
            stokDari: inv.stokDari,
            pilihan: inv.keluarProdukId,
            qtyController: inv.keluarQtyController,
            petugasController: inv.keluarPetugasController,
            keteranganController: inv.keluarKeteranganController,
            hintPetugas: 'Nama operator pengeluaran',
            labelKeterangan: 'Alasan Pengeluaran',
            hintKeterangan: 'Misal: Bahan kedaluwarsa',
            labelTombol: 'Simpan Pengeluaran',
            onSimpan: inv.simpanPengeluaran,
          );

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
            children: [
              const Text(
                'Inventori Stok',
                style: TextStyle(
                  color: ZestifyColors.gold,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Kelola penerimaan & pengeluaran barang (khusus admin).',
                style: TextStyle(color: ZestifyColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 18),
              GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: kolomStat,
                  mainAxisExtent: 150,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  StatCard(
                    icon: Icons.inventory_2_outlined,
                    nilai: '${inv.totalPenerimaan} Porsi',
                    label: 'Total Penerimaan',
                    keterangan: '↑ Riwayat 2 bulan',
                    warnaKeterangan: ZestifyColors.green,
                  ),
                  StatCard(
                    icon: Icons.local_shipping_outlined,
                    nilai: '${inv.totalPengeluaran} Porsi',
                    label: 'Total Pengeluaran',
                    keterangan: '↓ Riwayat 2 bulan',
                    warnaKeterangan: ZestifyColors.red,
                  ),
                  StatCard(
                    icon: Icons.warehouse_outlined,
                    nilai: '${inv.totalStok} Porsi',
                    label: 'Total Stok Saat Ini',
                    keterangan: '✓ Semua item',
                    warnaKeterangan: ZestifyColors.green,
                  ),
                  StatCard(
                    icon: Icons.receipt_long_outlined,
                    nilai: '${inv.transaksiHariIni} Transaksi',
                    label: 'Transaksi Hari Ini',
                    keterangan: 'Real-time',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              PanelCard(
                judul: 'Traffic & Pendapatan Bulanan',
                icon: Icons.bar_chart,
                child: InventoriChart(
                  labelBulan: inv.labelBulan,
                  pendapatan: InventoryController.dataPendapatan,
                  penerimaan: InventoryController.dataPenerimaan,
                  pengeluaran: InventoryController.dataPengeluaran,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Grafik menggunakan data contoh dari prototype website.',
                style: TextStyle(
                  color: ZestifyColors.textMuted,
                  fontSize: 11.5,
                ),
              ),
              const SizedBox(height: 16),
              PanelCard(
                judul: 'Stok Saat Ini per Item',
                icon: Icons.layers_outlined,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: kolomStok,
                    mainAxisExtent: 105,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (final p in inv.daftarProduk)
                      StokMiniCard(
                        nama: p.namaProduk,
                        jumlah: inv.stokDari(p.id),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (formBerdampingan)
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: formTerima),
                      const SizedBox(width: 16),
                      Expanded(child: formKeluar),
                    ],
                  ),
                )
              else ...[
                formTerima,
                const SizedBox(height: 16),
                formKeluar,
              ],
              const SizedBox(height: 16),
              PanelCard(
                judul: 'History Stock',
                icon: Icons.history,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: inv.cariController,
                      onChanged: (v) => inv.kataCari.value = v,
                      style: const TextStyle(color: ZestifyColors.text),
                      decoration: InputDecoration(
                        hintText: 'Cari nama barang atau petugas...',
                        hintStyle: const TextStyle(color: Color(0xFF555555)),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: ZestifyColors.gold,
                        ),
                        filled: true,
                        fillColor: ZestifyColors.input,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(
                            color: ZestifyColors.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(
                            color: ZestifyColors.gold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Riwayat lebih dari 2 bulan otomatis terhapus.',
                      style: TextStyle(
                        color: Color(0xFF777777),
                        fontSize: 11.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RiwayatStokTable(riwayat: inv.riwayatTampil),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _AksesDitolak extends StatelessWidget {
  const _AksesDitolak();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, color: ZestifyColors.gold, size: 48),
            SizedBox(height: 12),
            Text(
              'Akses Khusus Admin',
              style: TextStyle(
                color: ZestifyColors.text,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Halaman inventori tidak dapat diakses oleh akun VIP.',
              textAlign: TextAlign.center,
              style: TextStyle(color: ZestifyColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
