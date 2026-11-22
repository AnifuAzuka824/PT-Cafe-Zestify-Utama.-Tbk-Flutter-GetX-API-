import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_aplication_cafe/Compounent/gold_button.dart';
import 'package:flutter_aplication_cafe/Models/produk_model.dart';
import 'package:flutter_aplication_cafe/Models/transaksi_model.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class QrisDialog extends StatelessWidget {
  final TransaksiModel transaksi;
  final VoidCallback onSudahBayar;

  const QrisDialog({
    super.key,
    required this.transaksi,
    required this.onSudahBayar,
  });

  // Simulasi payload; belum terhubung ke payment gateway QRIS sungguhan.
  String get _payload =>
      'QRIS|ZESTIFY CAFE|${transaksi.nomorOrder}|${transaksi.total}|IDR';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ZestifyColors.card,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: ZestifyColors.gold.withValues(alpha: 0.35)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.qr_code_scanner,
                color: ZestifyColors.gold,
                size: 34,
              ),
              const SizedBox(height: 8),
              const Text(
                'Scan QRIS',
                style: TextStyle(
                  color: ZestifyColors.gold,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'MODE DEMO — bukan QRIS pembayaran nyata.\nQR ini hanya berisi nomor order dan total.',
                textAlign: TextAlign.center,
                style: TextStyle(color: ZestifyColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'ZESTIFY CAFÉ',
                      style: TextStyle(
                        color: Color(0xFF111111),
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: QrImageView(
                        data: _payload,
                        size: 210,
                        backgroundColor: Colors.white,
                        errorCorrectionLevel: QrErrorCorrectLevel.M,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      transaksi.nomorOrder,
                      style: const TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 12,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Total Pembayaran',
                style: TextStyle(color: ZestifyColors.textMuted, fontSize: 12),
              ),
              Text(
                formatRupiah(transaksi.total),
                style: const TextStyle(
                  color: ZestifyColors.gold,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              GoldButton(
                label: 'Konfirmasi Pembayaran Demo',
                icon: Icons.verified,
                onPressed: onSudahBayar,
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Batalkan',
                  style: TextStyle(color: ZestifyColors.textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
