import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/Models/produk_model.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class CartSummaryBar extends StatelessWidget {
  final int totalItem;
  final int totalHarga;
  final VoidCallback onTap;

  const CartSummaryBar({
    super.key,
    required this.totalItem,
    required this.totalHarga,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: ZestifyColors.card,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: ZestifyColors.gold.withValues(alpha: 0.5)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.shopping_cart,
              color: ZestifyColors.gold,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              '$totalItem item',
              style: const TextStyle(
                color: ZestifyColors.text,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Text(
              'Total ',
              style: TextStyle(color: ZestifyColors.textMuted, fontSize: 13),
            ),
            Text(
              formatRupiah(totalHarga),
              style: const TextStyle(
                color: ZestifyColors.gold,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right, color: ZestifyColors.gold),
          ],
        ),
      ),
    );
  }
}
