import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/Compounent/gold_button.dart';
import 'package:flutter_aplication_cafe/Compounent/produk_image.dart';
import 'package:flutter_aplication_cafe/Models/produk_model.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class BestSellerBadge extends StatelessWidget {
  const BestSellerBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: ZestifyColors.goldGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, size: 11, color: ZestifyColors.bg),
          SizedBox(width: 3),
          Text(
            'BEST SELLER',
            style: TextStyle(
              color: ZestifyColors.bg,
              fontSize: 9,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class KategoriChip extends StatelessWidget {
  final ProdukModel produk;

  const KategoriChip({super.key, required this.produk});

  @override
  Widget build(BuildContext context) {
    final warna = produk.isMakanan ? ZestifyColors.food : ZestifyColors.drink;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: warna.withValues(alpha: 0.25)),
      ),
      child: Text(
        produk.labelKategori.toUpperCase(),
        style: TextStyle(
          color: warna,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final ProdukModel produk;
  final VoidCallback onTap;
  final VoidCallback onTambah;

  const MenuCard({
    super.key,
    required this.produk,
    required this.onTap,
    required this.onTambah,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ZestifyColors.card,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ZestifyColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ProdukImage(produk: produk),
                    if (produk.bestSeller)
                      const Positioned(
                        top: 8,
                        right: 8,
                        child: BestSellerBadge(),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KategoriChip(produk: produk),
                    const SizedBox(height: 8),
                    Text(
                      produk.namaProduk,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: ZestifyColors.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formatRupiah(produk.hargaAsli),
                      style: const TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 11,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Color(0xFF555555),
                      ),
                    ),
                    Text(
                      formatRupiah(produk.harga),
                      style: const TextStyle(
                        color: ZestifyColors.price,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GoldOutlineButton(
                      label: 'Tambah',
                      icon: Icons.add_shopping_cart,
                      compact: true,
                      onPressed: onTambah,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
