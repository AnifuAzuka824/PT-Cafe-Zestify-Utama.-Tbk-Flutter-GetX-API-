import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/Models/produk_model.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class BestSellerBadge extends StatelessWidget {
  const BestSellerBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
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
              fontSize: 9.5,
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
    final Color warna = produk.isMakanan ? ZestifyColors.food : ZestifyColors.drink;
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
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
