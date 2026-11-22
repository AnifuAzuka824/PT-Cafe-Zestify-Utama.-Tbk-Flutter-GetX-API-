import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/Models/stok_log_model.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class RiwayatStokTable extends StatelessWidget {
  final List<StokLogModel> riwayat;

  const RiwayatStokTable({super.key, required this.riwayat});

  Widget _badge(bool masuk) {
    final warna = masuk ? ZestifyColors.green : ZestifyColors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: warna.withValues(alpha: 0.5)),
      ),
      child: Text(
        masuk ? 'Penerimaan' : 'Pengeluaran',
        style: TextStyle(color: warna, fontSize: 11.5, fontWeight: FontWeight.w700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (riwayat.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 28),
        child: Center(
          child: Text(
            'Belum ada riwayat transaksi stok.',
            style: TextStyle(color: ZestifyColors.textMuted),
          ),
        ),
      );
    }

    const muted = TextStyle(color: ZestifyColors.textMuted, fontSize: 12.5);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 42,
        dataRowMinHeight: 46,
        dataRowMaxHeight: 60,
        columnSpacing: 22,
        horizontalMargin: 4,
        dividerThickness: 0.6,
        headingTextStyle: const TextStyle(
          color: ZestifyColors.gold,
          fontWeight: FontWeight.w700,
          fontSize: 12.5,
        ),
        dataTextStyle: const TextStyle(color: ZestifyColors.text, fontSize: 13),
        columns: const [
          DataColumn(label: Text('Tgl / Waktu')),
          DataColumn(label: Text('Nama Barang')),
          DataColumn(label: Text('Jenis Transaksi')),
          DataColumn(label: Text('Kuantitas'), numeric: true),
          DataColumn(label: Text('Petugas')),
          DataColumn(label: Text('Keterangan')),
        ],
        rows: [
          for (final l in riwayat)
            DataRow(
              cells: [
                DataCell(Text(l.labelWaktu, style: muted)),
                DataCell(
                  Text(l.namaBarang, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                DataCell(_badge(l.isMasuk)),
                DataCell(
                  Text('${l.jumlah} Porsi', style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
                DataCell(Text(l.petugas, style: muted)),
                DataCell(
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 260),
                    child: Text(
                      l.keterangan.isEmpty ? '—' : l.keterangan,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Color(0xFF777777), fontSize: 12.5),
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
