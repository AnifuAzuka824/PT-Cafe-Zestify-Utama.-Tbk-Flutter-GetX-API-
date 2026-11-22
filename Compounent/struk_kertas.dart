import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/Models/produk_model.dart';
import 'package:flutter_aplication_cafe/Models/transaksi_model.dart';

class StrukKertas extends StatelessWidget {
  final TransaksiModel transaksi;

  const StrukKertas({super.key, required this.transaksi});

  static const TextStyle _mono = TextStyle(
    fontFamily: 'Courier New',
    fontFamilyFallback: ['Courier', 'monospace'],
    color: Color(0xFF222222),
    fontSize: 12.5,
    height: 1.45,
  );

  Widget _garis() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: LayoutBuilder(
      builder: (context, c) => Text(
        '-' * (c.maxWidth / 7.5).floor(),
        maxLines: 1,
        overflow: TextOverflow.clip,
        style: _mono.copyWith(color: const Color(0xFF999999)),
      ),
    ),
  );

  Widget _meta(String label, String nilai) =>
      Text('${label.padRight(10)}: $nilai', style: _mono);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(
                  'ZESTIFY CAFÉ',
                  style: _mono.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  'PREMIUM COFFEE & FINE DINING',
                  style: _mono.copyWith(
                    fontSize: 10,
                    letterSpacing: 1.2,
                    color: const Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Jl. Sudirman No. 88, Jakarta',
                  style: _mono.copyWith(fontSize: 11.5),
                ),
                Text(
                  'Tel: +62 812-354-450-15',
                  style: _mono.copyWith(fontSize: 11.5),
                ),
              ],
            ),
          ),
          _garis(),
          _meta('No. Order', transaksi.nomorOrder),
          _meta('Tanggal', transaksi.tanggalLabel),
          _meta('Waktu', transaksi.waktuLabel),
          _garis(),
          ...transaksi.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(item.namaProduk, style: _mono)),
                  SizedBox(
                    width: 34,
                    child: Text('x${item.jumlah}', style: _mono),
                  ),
                  Text(formatRupiah(item.subtotal), style: _mono),
                ],
              ),
            ),
          ),
          _garis(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL',
                style: _mono.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    formatRupiah(transaksi.total),
                    style: _mono.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          _meta('Metode', transaksi.metode.label),
          _garis(),
          Center(
            child: Column(
              children: [
                Text('Terima kasih telah berbelanja!', style: _mono),
                Text('Selamat menikmati', style: _mono),
                const SizedBox(height: 8),
                Text(
                  'Simpan struk ini sebagai bukti transaksi.',
                  textAlign: TextAlign.center,
                  style: _mono.copyWith(
                    fontSize: 10.5,
                    color: const Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
