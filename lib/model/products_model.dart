class ProductsModel {
  String? name;
  String? price;
  bool? image;
  String? quantity;

  ProductsModel({
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'price': price,
      'image': image,
      'quantity': quantity,
    };
  }
}
