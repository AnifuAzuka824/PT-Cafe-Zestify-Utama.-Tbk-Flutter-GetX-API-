import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_aplication_cafe/Compounent/gold_button.dart';
import 'package:flutter_aplication_cafe/Compounent/menu_card.dart';
import 'package:flutter_aplication_cafe/Compounent/produk_image.dart';
import 'package:flutter_aplication_cafe/Controller/cart_controller.dart';
import 'package:flutter_aplication_cafe/Controller/produk_controller.dart';
import 'package:flutter_aplication_cafe/Models/produk_model.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class DetailMenuPage extends StatelessWidget {
  const DetailMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ProdukModel? produk = Get.find<ProdukController>().produkTerpilih.value;
    final cart = Get.find<CartController>();

    if (produk == null) return const Scaffold();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: ZestifyColors.bg,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: const Color(0x99000000),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: Get.back,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: ProdukImage(produk: produk),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      KategoriChip(produk: produk),
                      if (produk.bestSeller) ...[
                        const SizedBox(width: 8),
                        const BestSellerBadge(),
                      ],
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    produk.namaProduk,
                    style: const TextStyle(
                      color: ZestifyColors.text,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        formatRupiah(produk.harga),
                        style: const TextStyle(
                          color: ZestifyColors.gold,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        formatRupiah(produk.hargaAsli),
                        style: const TextStyle(
                          color: Color(0xFF555555),
                          fontSize: 14,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Color(0xFF555555),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: ZestifyColors.green.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '-${produk.persenDiskon}%',
                          style: const TextStyle(
                            color: ZestifyColors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: ZestifyColors.border),
                  const SizedBox(height: 16),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(
                      color: ZestifyColors.gold,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    produk.deskripsi,
                    style: const TextStyle(
                      color: ZestifyColors.textMuted,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: ZestifyColors.surface,
          border: Border(top: BorderSide(color: ZestifyColors.border)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GoldButton(
              label: 'Tambah ke Keranjang',
              icon: Icons.add_shopping_cart,
              onPressed: () => cart.tambah(produk),
            ),
          ),
        ),
      ),
    );
  }
}
