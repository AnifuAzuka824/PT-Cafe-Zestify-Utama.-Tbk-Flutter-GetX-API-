import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_aplication_cafe/Models/kategori_model.dart';
import 'package:flutter_aplication_cafe/Models/produk_model.dart';
import 'package:flutter_aplication_cafe/routes.dart';

class ProdukController extends GetxController {
  final List<ProdukModel> dataProduk = const [
    ProdukModel(
      id: 1,
      namaProduk: 'Avocado Toast',
      kategori: 'food',
      bestSeller: false,
      harga: 50000,
      hargaAsli: 90000,
      deskripsi:
          'Ingredients artisan sourdough bread smashed avocado fresh microgreens lemon zest premium olive oil. Taste natural savory crunchy toast with a subtle refreshing acidity from the lemon.',
      gambar: 'assets/images/avocado-toast.jpg',
    ),
    ProdukModel(
      id: 2,
      namaProduk: 'Pasta Truffle',
      kategori: 'food',
      bestSeller: true,
      harga: 80000,
      hargaAsli: 185000,
      deskripsi:
          'Ingredients homemade fettuccine Italian black truffle sauce shiitake mushrooms authentic parmesan. The flavor is incredibly savory and creamy, featuring the rich, distinctive aroma of truffle.',
      gambar:
          'https://www.wenthere8this.com/wp-content/uploads/2023/11/black-truffle-pasta-11-1.jpg',
    ),
    ProdukModel(
      id: 3,
      namaProduk: 'Matcha Latte',
      kategori: 'drink',
      bestSeller: false,
      harga: 45000,
      hargaAsli: 85000,
      deskripsi:
          'Ingredients ceremonial grade matcha from Uji Kyoto barista oat milk. Taste smooth earthy authentic green tea mild sweetness soothing flavor.',
      gambar: 'assets/images/matcha-latte.jpg',
    ),
    ProdukModel(
      id: 4,
      namaProduk: 'Cold Brew',
      kategori: 'drink',
      bestSeller: true,
      harga: 45000,
      hargaAsli: 66000,
      deskripsi:
          'Ingredients single origin Sumatra Mandheling 24 hour cold drip. Taste refreshing cold with subtle dark chocolate and dried fruit notes without bitterness.',
      gambar:
          'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=600&auto=format&fit=crop',
    ),
    ProdukModel(
      id: 5,
      namaProduk: 'Salmon Croissant',
      kategori: 'food',
      bestSeller: true,
      harga: 78000,
      hargaAsli: 115000,
      deskripsi:
          'Ingredients flaky croissant premium smoked salmon dill cream cheese capers rocket lettuce. Taste savory salty smoked salmon creamy flaky layered with a touch of fresh herbs.',
      gambar: 'assets/images/salmon-croissant.jpg',
    ),
    ProdukModel(
      id: 6,
      namaProduk: 'Berry Hibiscus',
      kategori: 'drink',
      bestSeller: false,
      harga: 42000,
      hargaAsli: 58000,
      deskripsi:
          'Ingredients infused hibiscus flower fresh mixed berries artisan soda raw honey. Taste sweet sour refreshing fizzy caffeine-free invigorating drink.',
      gambar: 'assets/images/berry-hibiscus.jpg',
    ),
    ProdukModel(
      id: 7,
      namaProduk: 'Beef Wellington Bowl',
      kategori: 'food',
      bestSeller: false,
      harga: 150000,
      hargaAsli: 385000,
      deskripsi:
          'Ingredients tenderloin steak duxelles mushroom paste puff pastry velvety mashed. Taste tender succulent beef paired with umami mushrooms and a rich savory reduction.',
      gambar: 'assets/images/beef-wellington.jpg',
    ),
    ProdukModel(
      id: 8,
      namaProduk: 'Fried Rice Truffle',
      kategori: 'food',
      bestSeller: false,
      harga: 85000,
      hargaAsli: 95000,
      deskripsi:
          'Ingredients traditional village fried rice black truffle oil golden fried egg grilled shrimp.',
      gambar:
          'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=600&auto=format&fit=crop',
    ),
    ProdukModel(
      id: 9,
      namaProduk: 'Smashed Avo Burger',
      kategori: 'food',
      bestSeller: true,
      harga: 75000,
      hargaAsli: 110000,
      deskripsi:
          'Plant-based patty juicy, alpukat smashed lemon, smoked cheese, salsa verde homemade, dan toasted brioche bun.',
      gambar:
          'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=600&auto=format&fit=crop',
    ),
    ProdukModel(
      id: 10,
      namaProduk: 'Coffee Espresso Latte',
      kategori: 'drink',
      bestSeller: true,
      harga: 55000,
      hargaAsli: 80000,
      deskripsi:
          'Ingredients double shot espresso iced ceremonial grade matcha specialty oat milk.',
      gambar:
          'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=600&auto=format&fit=crop',
    ),
    ProdukModel(
      id: 11,
      namaProduk: 'Iced Lychee Rose',
      kategori: 'drink',
      bestSeller: false,
      harga: 48000,
      hargaAsli: 65000,
      deskripsi:
          'Ingredients fresh lychee reduction premium rose essence artisan sparkling water infused rosemary. Taste elegant floral perfume coupled with sweet tropical lychee notes and light effervescence.',
      gambar:
          'https://images.unsplash.com/photo-1497534446932-c925b458314e?w=600&auto=format&fit=crop',
    ),
    ProdukModel(
      id: 12,
      namaProduk: 'Churros Ice Cream',
      kategori: 'food',
      bestSeller: false,
      harga: 52000,
      hargaAsli: 75000,
      deskripsi:
          'Ingredients artisanal fried churros cinnamon sugar vanilla bean gelato Belgian chocolate. The warm, crispy sweetness blends perfectly with the smoothness of the cold ice cream.',
      gambar:
          'https://images.unsplash.com/photo-1576618148400-f54bed99fcfd?w=600&auto=format&fit=crop',
    ),
  ];

  final List<KategoriModel> pilihanKategori = const [
    KategoriModel(kode: 'all', label: 'Semua Menu', icon: Icons.grid_view_rounded),
    KategoriModel(kode: 'bestseller', label: 'Best Seller', icon: Icons.local_fire_department),
    KategoriModel(kode: 'food', label: 'Makanan', icon: Icons.restaurant),
    KategoriModel(kode: 'drink', label: 'Minuman', icon: Icons.local_cafe),
  ];

  final RxString kategoriTerpilih = 'all'.obs;
  final Rxn<ProdukModel> produkTerpilih = Rxn<ProdukModel>();

  List<ProdukModel> filterKategori(String kode) {
    switch (kode) {
      case 'bestseller':
        return dataProduk.where((p) => p.bestSeller).toList();
      case 'food':
      case 'drink':
        return dataProduk.where((p) => p.kategori == kode).toList();
      default:
        return dataProduk;
    }
  }

  List<ProdukModel> get produkTampil => filterKategori(kategoriTerpilih.value);

  List<ProdukModel> get produkBestSeller => filterKategori('bestseller');

  void ubahKategori(String kode) {
    kategoriTerpilih.value = kode;
  }

  void bukaDetail(ProdukModel produk) {
    produkTerpilih.value = produk;
    Get.toNamed(Routes.detailmenu);
  }
}
