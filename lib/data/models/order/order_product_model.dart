class OrderProductModel {
  final String productImage;
  final String productName;
  final num productPrice;
  final String productId;
  final String categoryId;
  final num count;
  final bool isCountable;
  final int productQuantity;
  final bool productActive;
  final String createdAt;
  final String productDescription;
  final String mfgDate;
  final String expDate;

  OrderProductModel({
    required this.productImage,
    required this.productName,
    required this.productPrice,
    required this.productId,
    required this.categoryId,
    required this.count,
    required this.isCountable,
    required this.productQuantity,
    required this.createdAt,
    required this.productDescription,
    required this.mfgDate,
    required this.expDate,
    required this.productActive,
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
      productQuantity: json["product_quantity"] as int? ?? 0,
      productActive: json["product_active"] as bool? ?? false,
      mfgDate: json["mfg_date"] as String? ?? "",
      expDate: json["exp_date"] as String? ?? "",
      createdAt: json["created_at"] as String? ?? "",
      productDescription: json["product_description"] as String? ?? "",
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
      "product_quantity": productQuantity,
      "created_at": createdAt,
      "product_description": productDescription,
      "mfg_date": mfgDate,
      "exp_date": expDate,
      "product_active": productActive,
    };
  }
}
