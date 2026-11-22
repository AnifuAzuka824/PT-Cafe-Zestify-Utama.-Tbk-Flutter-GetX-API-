import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String nilai;
  final String label;
  final String keterangan;
  final Color warnaKeterangan;

  const StatCard({
    super.key,
    required this.icon,
    required this.nilai,
    required this.label,
    required this.keterangan,
    this.warnaKeterangan = const Color(0xFF888888),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ZestifyColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ZestifyColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ZestifyColors.gold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: ZestifyColors.gold, size: 20),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              nilai,
              style: const TextStyle(
                color: ZestifyColors.text,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: ZestifyColors.textMuted, fontSize: 12.5),
          ),
          Text(
            keterangan,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: warnaKeterangan, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
