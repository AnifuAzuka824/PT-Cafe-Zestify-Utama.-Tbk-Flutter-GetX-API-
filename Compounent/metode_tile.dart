import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/Models/transaksi_model.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class MetodeTile extends StatelessWidget {
  final MetodePembayaranModel metode;
  final bool terpilih;
  final VoidCallback onTap;

  const MetodeTile({
    super.key,
    required this.metode,
    required this.terpilih,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: BoxDecoration(
            color: terpilih
                ? ZestifyColors.gold.withValues(alpha: 0.1)
                : ZestifyColors.input,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: terpilih ? ZestifyColors.gold : ZestifyColors.border,
              width: terpilih ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                metode.icon,
                color: terpilih ? ZestifyColors.gold : ZestifyColors.textMuted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  metode.label,
                  style: TextStyle(
                    color: terpilih ? ZestifyColors.gold : ZestifyColors.text,
                    fontWeight: terpilih ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                terpilih ? Icons.radio_button_checked : Icons.radio_button_off,
                color: terpilih ? ZestifyColors.gold : const Color(0xFF555555),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
