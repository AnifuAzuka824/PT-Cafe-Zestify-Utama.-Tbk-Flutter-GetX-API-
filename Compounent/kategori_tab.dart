import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/Models/kategori_model.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class KategoriTab extends StatelessWidget {
  final List<KategoriModel> kategori;
  final String terpilih;
  final int Function(String kode) jumlah;
  final ValueChanged<String> onChanged;

  const KategoriTab({
    super.key,
    required this.kategori,
    required this.terpilih,
    required this.jumlah,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: kategori.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = kategori[index];
          final aktif = item.kode == terpilih;
          return GestureDetector(
            onTap: () => onChanged(item.kode),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: aktif
                    ? ZestifyColors.gold.withValues(alpha: 0.12)
                    : ZestifyColors.surface,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: aktif ? ZestifyColors.gold : ZestifyColors.border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    item.icon,
                    size: 16,
                    color: aktif ? ZestifyColors.gold : const Color(0xFF777777),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.label,
                    style: TextStyle(
                      color: aktif ? ZestifyColors.gold : const Color(0xFF999999),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: aktif ? ZestifyColors.gold : ZestifyColors.border,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${jumlah(item.kode)}',
                      style: TextStyle(
                        color: aktif ? ZestifyColors.bg : ZestifyColors.textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
