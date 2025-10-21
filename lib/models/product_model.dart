class Product {
  final String id;
  final String name;
  final double price;
  final String image;
  bool isFavourite;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.isFavourite = false,
    this.quantity = 0,
  });

  Product copyWith({
    String? id,
    String? name,
    double? price,
    String? image,
    bool? isFavourite,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      isFavourite: isFavourite ?? this.isFavourite,
      quantity: quantity ?? this.quantity,
    );
  }
}