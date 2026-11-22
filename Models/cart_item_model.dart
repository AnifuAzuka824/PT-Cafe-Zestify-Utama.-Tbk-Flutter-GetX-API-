class CartItemModel {
  final int id;
  final String namaProduk;
  final int harga;
  int jumlah;

  CartItemModel({
    required this.id,
    required this.namaProduk,
    required this.harga,
    this.jumlah = 1,
  });

  int get subtotal => harga * jumlah;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': namaProduk,
        'price': harga,
        'quantity': jumlah,
      };

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        id: json['id'] as int,
        namaProduk: json['name'] as String,
        harga: json['price'] as int,
        jumlah: json['quantity'] as int,
      );
}
