import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_aplication_cafe/Compounent/cart_summary_bar.dart';
import 'package:flutter_aplication_cafe/Compounent/kategori_tab.dart';
import 'package:flutter_aplication_cafe/Compounent/menu_card.dart';
import 'package:flutter_aplication_cafe/Controller/cart_controller.dart';
import 'package:flutter_aplication_cafe/Controller/main_menu_controller.dart';
import 'package:flutter_aplication_cafe/Controller/produk_controller.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class MenuPages extends StatelessWidget {
  const MenuPages({super.key});

  @override
  Widget build(BuildContext context) {
    final produk = Get.find<ProdukController>();
    final cart = Get.find<CartController>();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'Signature Menu',
              style: TextStyle(
                color: ZestifyColors.gold,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              'Pilih menu favorit Anda, harga spesial hari ini.',
              style: TextStyle(color: ZestifyColors.textMuted, fontSize: 13),
            ),
          ),
          Obx(
            () => KategoriTab(
              kategori: produk.pilihanKategori,
              terpilih: produk.kategoriTerpilih.value,
              jumlah: (kode) => produk.filterKategori(kode).length,
              onChanged: produk.ubahKategori,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              final daftar = produk.produkTampil;
              if (daftar.isEmpty) {
                return const Center(
                  child: Text(
                    'Tidak ada menu di kategori ini.',
                    style: TextStyle(color: ZestifyColors.textMuted),
                  ),
                );
              }
              return LayoutBuilder(
                builder: (context, constraints) {
                  final kolom = (constraints.maxWidth / 190).floor().clamp(2, 4);
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: kolom,
                      mainAxisExtent: 300,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: daftar.length,
                    itemBuilder: (context, index) {
                      final item = daftar[index];
                      return MenuCard(
                        produk: item,
                        onTap: () => produk.bukaDetail(item),
                        onTambah: () => cart.tambah(item),
                      );
                    },
                  );
                },
              );
            }),
          ),
          Obx(
            () => cart.items.isEmpty
                ? const SizedBox.shrink()
                : CartSummaryBar(
                    totalItem: cart.totalItem,
                    totalHarga: cart.totalHarga,
                    onTap: () => Get.find<MainMenuController>()
                        .changedPage(MainMenuController.tabCheckout),
                  ),
          ),
        ],
      ),
    );
  }
}
