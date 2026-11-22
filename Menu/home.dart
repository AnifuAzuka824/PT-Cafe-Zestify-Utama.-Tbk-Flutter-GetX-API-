import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_aplication_cafe/Compounent/footer_info.dart';
import 'package:flutter_aplication_cafe/Compounent/hero_banner.dart';
import 'package:flutter_aplication_cafe/Compounent/menu_card.dart';
import 'package:flutter_aplication_cafe/Compounent/porto_card.dart';
import 'package:flutter_aplication_cafe/Compounent/section_title.dart';
import 'package:flutter_aplication_cafe/Compounent/zestify_logo.dart';
import 'package:flutter_aplication_cafe/Controller/auth_controller.dart';
import 'package:flutter_aplication_cafe/Controller/cart_controller.dart';
import 'package:flutter_aplication_cafe/Controller/main_menu_controller.dart';
import 'package:flutter_aplication_cafe/Controller/produk_controller.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class HomePages extends StatelessWidget {
  const HomePages({super.key});

  void _konfirmasiLogout(AuthController auth) {
    Get.dialog(
      AlertDialog(
        backgroundColor: ZestifyColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Keluar Akun'),
        content: const Text(
          'Anda yakin ingin keluar dari akun Zestify?',
          style: TextStyle(color: ZestifyColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            style: TextButton.styleFrom(foregroundColor: ZestifyColors.textMuted),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: auth.logout,
            style: TextButton.styleFrom(foregroundColor: ZestifyColors.red),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final produk = Get.find<ProdukController>();
    final cart = Get.find<CartController>();
    final mainMenu = Get.find<MainMenuController>();

    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          'Halo, ${auth.userAktif.value?.namaPanggilan ?? 'Tamu'}',
                          style: const TextStyle(
                            color: ZestifyColors.textMuted,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const ZestifyLogo(fontSize: 22),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Keluar',
                  onPressed: () => _konfirmasiLogout(auth),
                  icon: const Icon(Icons.logout, color: ZestifyColors.textMuted),
                ),
              ],
            ),
          ),
          const HeroBanner(),
          const SizedBox(height: 28),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SectionTitle(
              title: 'Signature Menu',
              actionLabel: 'Lihat Semua',
              onAction: () => mainMenu.changedPage(1),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 290,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: produk.produkBestSeller.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = produk.produkBestSeller[index];
                return SizedBox(
                  width: 175,
                  child: MenuCard(
                    produk: item,
                    onTap: () => produk.bukaDetail(item),
                    onTambah: () => cart.tambah(item),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: SectionTitle(title: 'Portofolio Perusahaan'),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PT Zestify Café Utama Tbk didirikan pada tahun 2027 oleh pecinta kuliner, barista profesional, Founder dan Investor. Kami menyediakan fine-casual dining dengan harga terjangkau, di mana setiap menu disesuaikan dengan selera lokal & internasional.',
                  style: TextStyle(
                    color: ZestifyColors.textMuted,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Cabang utama di Jakarta, Bali, Kudus, & Surabaya telah melayani 15.000+ pelanggan, bekerja sama dengan 30+ supplier lokal, dan meraih penghargaan "Best Emerging Café 2028" dari Culinary Digest.',
                  style: TextStyle(
                    color: ZestifyColors.textMuted,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 18),
                PortoCard(
                  icon: Icons.emoji_events,
                  judul: 'Penghargaan',
                  deskripsi:
                      'Indonesia Coffee Champion 2027\nBest Dessert Innovation 2026',
                ),
                SizedBox(height: 12),
                PortoCard(
                  icon: Icons.handshake,
                  judul: 'Mitra Strategis',
                  deskripsi:
                      'Farm to Table, Ubud Organik, Kopi Nusantara, dan 25+ UMKM lokal terpercaya.',
                ),
                SizedBox(height: 12),
                PortoCard(
                  icon: Icons.trending_up,
                  judul: 'Ekspansi',
                  deskripsi:
                      '4 cabang beroperasi di Surabaya, Jakarta, Kudus & Bali. Target 8 cabang tahun 2029.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const FooterInfo(),
        ],
      ),
    );
  }
}
