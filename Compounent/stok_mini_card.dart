import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/Controller/inventory_controller.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class StokMiniCard extends StatelessWidget {
  final String nama;
  final int jumlah;

  const StokMiniCard({super.key, required this.nama, required this.jumlah});

  @override
  Widget build(BuildContext context) {
    final kritis = jumlah < InventoryController.batasKritis;
    final rendah = !kritis && jumlah < InventoryController.batasRendah;
    final warna = kritis
        ? ZestifyColors.red
        : rendah
            ? ZestifyColors.food
            : ZestifyColors.green;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ZestifyColors.input,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kritis || rendah ? warna.withValues(alpha: 0.6) : ZestifyColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            nama,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: ZestifyColors.text, fontSize: 12.5),
          ),
          Row(
            children: [
              Text(
                '$jumlah Porsi',
                style: TextStyle(
                  color: warna,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              if (kritis || rendah)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: warna.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    kritis ? 'Kritis' : 'Rendah',
                    style: TextStyle(
                      color: warna,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
