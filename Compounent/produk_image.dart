import 'package:flutter/material.dart';
import 'package:flutter_aplication_cafe/Models/produk_model.dart';
import 'package:flutter_aplication_cafe/theme.dart';

class ProdukImage extends StatelessWidget {
  final ProdukModel produk;
  final double? height;

  const ProdukImage({super.key, required this.produk, this.height});

  Widget _fallback() => Container(
        height: height,
        color: ZestifyColors.input,
        alignment: Alignment.center,
        child: Icon(
          produk.isMakanan ? Icons.restaurant : Icons.local_cafe,
          color: const Color(0xFF444444),
          size: 40,
        ),
      );

  @override
  Widget build(BuildContext context) {
    if (produk.gambarLokal) {
      return Image.asset(
        produk.gambar,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _fallback(),
      );
    }
    return Image.network(
      produk.gambar,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : _fallback(),
      errorBuilder: (context, error, stackTrace) => _fallback(),
    );
  }
}
