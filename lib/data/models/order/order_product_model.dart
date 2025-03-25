class OrderProductModel {
  final String productImage;
  final String productName;
  final num productPrice;
  final String productId;
  final String categoryId;
  final num count;
  final bool isCountable;

  OrderProductModel({
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productId,
    required this.categoryId,
    required this.count,
    required this.isCountable,
  });

  factory OrderProductModel.fromJson(Map<String, dynamic> json) {
    return OrderProductModel(
      productImage: json["product_image"] as String? ?? "",
      productName: json["product_name"] as String? ?? "",
      productPrice: json["product_price"] as num? ?? 0,
      productId: json["product_id"] as String? ?? "",
      categoryId: json["category_id"] as String? ?? "",
      count: json["count"] as num? ?? 0,
      isCountable: json["is_countable"] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product_image": productImage,
      "product_name": productName,
      "product_price": productPrice,
      "product_id": productId,
      "category_id": categoryId,
      "count": count,
      "is_countable": isCountable,
    };
  }
}
