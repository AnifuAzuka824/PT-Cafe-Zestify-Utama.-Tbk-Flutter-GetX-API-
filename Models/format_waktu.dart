const List<String> namaBulanPendek = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des',
];

const List<String> namaBulanPanjang = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
  'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

String _dua(int n) => n.toString().padLeft(2, '0');

String formatJam(DateTime t) => '${_dua(t.hour)}.${_dua(t.minute)}';

String formatTanggalPanjang(DateTime t) =>
    '${_dua(t.day)} ${namaBulanPanjang[t.month - 1]} ${t.year}';

String formatTanggalPendekJam(DateTime t) =>
    '${_dua(t.day)} ${namaBulanPendek[t.month - 1]} ${t.year}, ${formatJam(t)}';

bool hariSama(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
