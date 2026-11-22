import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/Models/produk_model.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class InventoriChart extends StatelessWidget {
  final List<String> labelBulan;
  final List<int> pendapatan;
  final List<int> penerimaan;
  final List<int> pengeluaran;

  const InventoriChart({
    super.key,
    required this.labelBulan,
    required this.pendapatan,
    required this.penerimaan,
    required this.pengeluaran,
  });

  static const Color warnaMasuk = Color(0xFF0FDF5F);
  static const Color warnaKeluar = Color(0xFFE40C0C);
  static const double _kiri = 54;
  static const double _kanan = 46;
  static const double _bawah = 26;
  static const double _maxPendapatan = 12000000;
  static const double _maxPorsi = 480;

  static const TextStyle _gayaSumbu = TextStyle(
    color: Color(0xFF888888),
    fontSize: 10,
  );

  AxisTitles _kosong(double size) => AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: size,
          getTitlesWidget: (_, _) => const SizedBox.shrink(),
        ),
      );

  Widget _legenda(Color warna, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: warna, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: ZestifyColors.textMuted, fontSize: 11.5)),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final bar = BarChart(
      BarChartData(
        minY: 0,
        maxY: _maxPendapatan,
        alignment: BarChartAlignment.spaceAround,
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: 3000000,
          getDrawingHorizontalLine: (_) =>
              const FlLine(color: Color(0xFF222222), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: _kosong(_kanan),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: _kiri,
              interval: 3000000,
              getTitlesWidget: (value, _) => Text(
                'Rp${(value / 1000000).toStringAsFixed(1)}jt',
                style: _gayaSumbu,
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: _bawah,
              getTitlesWidget: (value, _) => Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(labelBulan[value.toInt()], style: _gayaSumbu),
              ),
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => const Color(0xFF1A1A1A),
            tooltipBorder: const BorderSide(color: ZestifyColors.border),
            maxContentWidth: 190,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            getTooltipItem: (group, i, rod, ri) => BarTooltipItem(
              '${labelBulan[i]}\n',
              const TextStyle(color: ZestifyColors.text, fontWeight: FontWeight.w700),
              textAlign: TextAlign.left,
              children: [
                TextSpan(
                  text: 'Pendapatan: ${formatRupiah(pendapatan[i])}\n',
                  style: const TextStyle(color: ZestifyColors.gold, fontSize: 11.5),
                ),
                TextSpan(
                  text: 'Penerimaan: ${penerimaan[i]} porsi\n',
                  style: const TextStyle(color: warnaMasuk, fontSize: 11.5),
                ),
                TextSpan(
                  text: 'Pengeluaran: ${pengeluaran[i]} porsi',
                  style: const TextStyle(color: warnaKeluar, fontSize: 11.5),
                ),
              ],
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < pendapatan.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: pendapatan[i].toDouble(),
                  width: 20,
                  gradient: LinearGradient(
                    colors: [
                      ZestifyColors.gold.withValues(alpha: 0.35),
                      ZestifyColors.gold.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                ),
              ],
            ),
        ],
      ),
    );

    LineChartBarData garis(List<int> data, Color warna) => LineChartBarData(
          spots: [
            for (var i = 0; i < data.length; i++)
              FlSpot(i.toDouble(), data[i].toDouble()),
          ],
          isCurved: true,
          color: warna,
          barWidth: 2.5,
          dotData: FlDotData(
            getDotPainter: (_, _, _, _) => FlDotCirclePainter(
              radius: 3.5,
              color: warna,
              strokeColor: ZestifyColors.card,
              strokeWidth: 1.5,
            ),
          ),
        );

    final line = LineChart(
      LineChartData(
        minX: -0.5,
        maxX: pendapatan.length - 0.5,
        minY: 0,
        maxY: _maxPorsi,
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          leftTitles: _kosong(_kiri),
          bottomTitles: _kosong(_bawah),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: _kanan,
              interval: 120,
              getTitlesWidget: (value, _) => Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text('${value.toInt()} prs', style: _gayaSumbu),
              ),
            ),
          ),
        ),
        lineBarsData: [
          garis(penerimaan, warnaMasuk),
          garis(pengeluaran, warnaKeluar),
        ],
      ),
    );

    return Column(
      children: [
        Wrap(
          spacing: 14,
          runSpacing: 6,
          alignment: WrapAlignment.center,
          children: [
            _legenda(ZestifyColors.gold, 'Pendapatan'),
            _legenda(warnaMasuk, 'Penerimaan Barang'),
            _legenda(warnaKeluar, 'Pengeluaran Barang'),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 240,
          child: Stack(
            children: [
              Positioned.fill(child: bar),
              Positioned.fill(child: IgnorePointer(child: line)),
            ],
          ),
        ),
      ],
    );
  }
}
