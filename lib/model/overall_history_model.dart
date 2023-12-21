class OverallHistoryModel {
  String? customer;
  String? product;
  String? price;
  String? quantity;
  String? soldDate;

  OverallHistoryModel({
    required this.customer,
    required this.product,
    required this.price,
    required this.quantity,
    required this.soldDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': customer,
      'product': product,
      'price': price,
      'quantity': quantity,
    };
  }
}
