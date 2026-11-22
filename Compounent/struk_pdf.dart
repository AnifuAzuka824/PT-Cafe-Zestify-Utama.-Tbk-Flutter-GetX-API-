import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_aplication_cafe/Models/produk_model.dart';
import 'package:flutter_aplication_cafe/Models/transaksi_model.dart';

Future<Uint8List> buatStrukPdf(TransaksiModel transaksi) {
  final doc = pw.Document(title: 'Struk ${transaksi.nomorOrder}');
  final mono = pw.Font.courier();
  final monoBold = pw.Font.courierBold();

  pw.TextStyle gaya({double size = 9, bool tebal = false}) =>
      pw.TextStyle(font: tebal ? monoBold : mono, fontSize: size);

  pw.Widget garis() => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(vertical: 6),
        child: pw.Divider(
          height: 1,
          thickness: 0.6,
          borderStyle: pw.BorderStyle.dashed,
        ),
      );

  pw.Widget meta(String label, String nilai) => pw.Text(
        '${label.padRight(10)}: $nilai',
        style: gaya(),
      );

  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll80,
      margin: const pw.EdgeInsets.all(14),
      build: (_) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          pw.Center(child: pw.Text('ZESTIFY CAF\u00c9', style: gaya(size: 14, tebal: true))),
          pw.Center(child: pw.Text('PREMIUM COFFEE & FINE DINING', style: gaya(size: 7))),
          pw.SizedBox(height: 4),
          pw.Center(child: pw.Text('Jl. Sudirman No. 88, Jakarta', style: gaya(size: 8))),
          pw.Center(child: pw.Text('Tel: +62 812-354-450-15', style: gaya(size: 8))),
          garis(),
          meta('No. Order', transaksi.nomorOrder),
          meta('Tanggal', transaksi.tanggalLabel),
          meta('Waktu', transaksi.waktuLabel),
          garis(),
          ...transaksi.items.map(
            (item) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 4),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(child: pw.Text(item.namaProduk, style: gaya())),
                  pw.SizedBox(width: 22, child: pw.Text('x${item.jumlah}', style: gaya())),
                  pw.Text(formatRupiah(item.subtotal), style: gaya()),
                ],
              ),
            ),
          ),
          garis(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('TOTAL', style: gaya(size: 11, tebal: true)),
              pw.Text(formatRupiah(transaksi.total), style: gaya(size: 11, tebal: true)),
            ],
          ),
          pw.SizedBox(height: 4),
          meta('Metode', transaksi.metode.label),
          garis(),
          pw.Center(child: pw.Text('Terima kasih telah berbelanja!', style: gaya())),
          pw.Center(child: pw.Text('Selamat menikmati', style: gaya())),
          pw.SizedBox(height: 6),
          pw.Center(
            child: pw.Text(
              'Simpan struk ini sebagai bukti transaksi.',
              style: gaya(size: 7),
            ),
          ),
        ],
      ),
    ),
  );
  return doc.save();
}
