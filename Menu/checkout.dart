import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_aplication_cafe/Compounent/cart_item_tile.dart';
import 'package:flutter_aplication_cafe/Compounent/gold_button.dart';
import 'package:flutter_aplication_cafe/Compounent/metode_tile.dart';
import 'package:flutter_aplication_cafe/Compounent/panel_card.dart';
import 'package:flutter_aplication_cafe/Controller/cart_controller.dart';
import 'package:flutter_aplication_cafe/Controller/checkout_controller.dart';
import 'package:flutter_aplication_cafe/Controller/main_menu_controller.dart';
import 'package:flutter_aplication_cafe/Models/produk_model.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class CheckoutPages extends StatelessWidget {
  const CheckoutPages({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Get.find<CartController>();
    final checkout = Get.find<CheckoutController>();

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          const Text(
            'Checkout',
            style: TextStyle(
              color: ZestifyColors.gold,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Periksa pesanan dan pilih metode pembayaran.',
            style: TextStyle(color: ZestifyColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 18),
          PanelCard(
            judul: 'Keranjang Anda',
            icon: Icons.shopping_cart,
            aksi: TextButton.icon(
              onPressed: () => Get.find<MainMenuController>().changedPage(MainMenuController.tabMenu),
              icon: const Icon(Icons.add, size: 16, color: ZestifyColors.gold),
              label: const Text(
                'Tambah Menu',
                style: TextStyle(color: ZestifyColors.gold, fontSize: 12),
              ),
            ),
            child: Obx(() {
              if (cart.items.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.remove_shopping_cart_outlined,
                            color: Color(0xFF555555), size: 40),
                        SizedBox(height: 8),
                        Text(
                          'Keranjang kosong.',
                          style: TextStyle(color: ZestifyColors.textMuted),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  for (final item in cart.items) ...[
                    CartItemTile(
                      item: item,
                      onTambah: () => cart.tambahJumlah(item),
                      onKurang: () => cart.kurang(item),
                      onHapus: () => cart.hapus(item),
                    ),
                    const SizedBox(height: 10),
                  ],
                  const Divider(color: ZestifyColors.border),
                  Row(
                    children: [
                      Text(
                        'Total (${cart.totalItem} item)',
                        style: const TextStyle(color: ZestifyColors.textMuted),
                      ),
                      const Spacer(),
                      Text(
                        formatRupiah(cart.totalHarga),
                        style: const TextStyle(
                          color: ZestifyColors.gold,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
          const SizedBox(height: 16),
          PanelCard(
            judul: 'Metode Pembayaran',
            icon: Icons.account_balance_wallet,
            child: Obx(
              () => Column(
                children: [
                  for (final metode in checkout.metodePembayaran) ...[
                    MetodeTile(
                      metode: metode,
                      terpilih:
                          checkout.metodeTerpilih.value?.kode == metode.kode,
                      onTap: () => checkout.pilihMetode(metode),
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          GoldButton(
            label: 'Bayar Sekarang',
            icon: Icons.lock,
            onPressed: checkout.bayarSekarang,
          ),
          const SizedBox(height: 10),
          GoldOutlineButton(
            label: 'Kembali ke Menu',
            icon: Icons.arrow_back,
            onPressed: () => Get.find<MainMenuController>().changedPage(MainMenuController.tabMenu),
          ),
        ],
      ),
    );
  }
}
