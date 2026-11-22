import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/Compounent/zestify_logo.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class FooterInfo extends StatelessWidget {
  const FooterInfo({super.key});

  Widget _kontak(IconData icon, String teks) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Icon(icon, color: ZestifyColors.gold, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            teks,
            style: const TextStyle(
              color: ZestifyColors.textMuted,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _jam(String hari, String waktu, {bool libur = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          hari,
          style: const TextStyle(color: ZestifyColors.textMuted, fontSize: 13),
        ),

        Text(
          waktu,
          style: TextStyle(
            color: libur ? ZestifyColors.red : ZestifyColors.text,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );

  Widget _judul(String teks) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      teks,
      style: const TextStyle(
        color: ZestifyColors.gold,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF070707),
        border: Border(top: BorderSide(color: ZestifyColors.gold, width: 1)),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ZestifyLogo(fontSize: 20),
          const SizedBox(height: 6),
          const Text(
            'Premium Coffee & Fine Dining · Kualitas terbaik, rasa autentik.',
            style: TextStyle(color: ZestifyColors.textMuted, fontSize: 12),
          ),

          const SizedBox(height: 22),
          _judul('Hubungi Kami'),
          _kontak(Icons.email_outlined, 'Cafezestify@gmail.com'),
          _kontak(Icons.phone_outlined, '+62 812-354-450-15'),
          _kontak(Icons.location_on_outlined, 'Jl. Sudirman No. 88, Jakarta'),
          const SizedBox(height: 12),
          _judul('Jam Buka'),
          _jam('Senin – Rabu', '06:30 – 15:40'),
          _jam('Kamis – Sabtu', '14:00 – 23:00'),
          _jam('Minggu', 'Libur', libur: true),
          const Divider(color: ZestifyColors.border, height: 28),
          const Center(
            child: Text(
              '© 2027 Cafe Zestify · Made with ♥ for coffee lovers.',
              style: TextStyle(color: Color(0xFF666666), fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
