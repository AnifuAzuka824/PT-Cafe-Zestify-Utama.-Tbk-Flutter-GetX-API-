class ProdukModel {
  final int id;
  final String namaProduk;
  final String kategori;
  final bool bestSeller;
  final int harga;
  final int hargaAsli;
  final String deskripsi;
  final String gambar;

  const ProdukModel({
    required this.id,
    required this.namaProduk,
    required this.kategori,
    required this.bestSeller,
    required this.harga,
    required this.hargaAsli,
    required this.deskripsi,
    required this.gambar,
  });

  bool get isMakanan => kategori == 'food';

  String get labelKategori => isMakanan ? 'Makanan' : 'Minuman';

  bool get gambarLokal => gambar.startsWith('assets/');

  int get persenDiskon => ((hargaAsli - harga) / hargaAsli * 100).round();
}

String formatRupiah(int amount) {
  final digits = amount.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return 'Rp$buffer';
}
