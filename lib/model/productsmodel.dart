class Products {
  String? name;
  String? price;
  String? imagedir = '';
  String? quantity;
  Products({
    required this.name,
    required this.price,
    required this.imagedir,
    required this.quantity,
  });

  toMap() {
    return {
      name: {
        'price': price,
        'imagedir': imagedir,
        'quantity': quantity,
        'history': {},
      }
    };
  }
}
