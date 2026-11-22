import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class PanelCard extends StatelessWidget {
  final String judul;
  final IconData icon;
  final Color warnaIcon;
  final Widget child;
  final Widget? aksi;

  const PanelCard({
    super.key,
    required this.judul,
    required this.icon,
    required this.child,
    this.warnaIcon = ZestifyColors.gold,
    this.aksi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ZestifyColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: ZestifyColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: warnaIcon, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  judul,
                  style: const TextStyle(
                    color: ZestifyColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ?aksi,
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
