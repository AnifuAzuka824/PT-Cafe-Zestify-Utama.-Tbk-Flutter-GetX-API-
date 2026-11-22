import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_aplication_cafe/Compounent/gold_button.dart';
import 'package:flutter_aplication_cafe/Compounent/struk_kertas.dart';
import 'package:flutter_aplication_cafe/Controller/checkout_controller.dart';
import 'package:flutter_aplication_cafe/Models/transaksi_model.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class StrukDialog extends StatelessWidget {
  final TransaksiModel transaksi;

  const StrukDialog({super.key, required this.transaksi});

  @override
  Widget build(BuildContext context) {
    final checkout = Get.find<CheckoutController>();

    final dialog = Dialog(
      backgroundColor: ZestifyColors.card,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: ZestifyColors.gold.withValues(alpha: 0.35)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: ZestifyColors.goldGradient,
                ),
                child: const Icon(
                  Icons.check,
                  color: ZestifyColors.bg,
                  size: 34,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Pembayaran Berhasil!',
                style: TextStyle(
                  color: ZestifyColors.gold,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Terima kasih — struk Anda siap dicetak atau disimpan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: ZestifyColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 18),
              StrukKertas(transaksi: transaksi),
              const SizedBox(height: 18),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cetak = GoldButton(
                    label: 'Cetak Struk',
                    icon: Icons.print,
                    onPressed: () => checkout.cetakStruk(transaksi),
                  );
                  final kembali = GoldOutlineButton(
                    label: 'Kembali ke Menu',
                    icon: Icons.restaurant_menu,
                    onPressed: checkout.kembaliKeMenu,
                  );
                  if (constraints.maxWidth < 340) {
                    return Column(
                      children: [cetak, const SizedBox(height: 10), kembali],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: cetak),
                      const SizedBox(width: 10),
                      Expanded(child: kembali),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
    return PopScope(canPop: false, child: dialog);
  }
}
