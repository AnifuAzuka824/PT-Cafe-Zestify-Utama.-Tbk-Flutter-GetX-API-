import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/Models/cart_item_model.dart';
import 'package:flutter_aplication_cafe/Models/produk_model.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class CartItemTile extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onTambah;
  final VoidCallback onKurang;
  final VoidCallback onHapus;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onTambah,
    required this.onKurang,
    required this.onHapus,
  });

  Widget _tombolQty(IconData icon, VoidCallback onTap) => InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ZestifyColors.gold.withValues(alpha: 0.6)),
          ),
          child: Icon(icon, size: 16, color: ZestifyColors.gold),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
      decoration: BoxDecoration(
        color: ZestifyColors.input,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ZestifyColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.namaProduk,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: ZestifyColors.text,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${formatRupiah(item.harga)} / porsi',
                  style: const TextStyle(color: ZestifyColors.textMuted, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  formatRupiah(item.subtotal),
                  style: const TextStyle(
                    color: ZestifyColors.price,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          _tombolQty(Icons.remove, onKurang),
          SizedBox(
            width: 34,
            child: Text(
              '${item.jumlah}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ZestifyColors.text,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          _tombolQty(Icons.add, onTambah),
          IconButton(
            onPressed: onHapus,
            tooltip: 'Hapus',
            icon: const Icon(Icons.delete_outline, color: ZestifyColors.red),
          ),
        ],
      ),
    );
  }
}
