class ProductModel {
  final String categoryId;
  final String productId;
  final String productName;
  final num productPrice;
  final bool productActive;
  final String productImage;
  final num productQuantity;
  final String createdAt;
  final String productDescription;
  final bool isCountable;
  final String? mfgDate;
  final String? expDate;

  ProductModel({
    required this.categoryId,
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productActive,
    required this.productImage,
    required this.productQuantity,
    required this.createdAt,
    required this.productDescription,
    required this.isCountable,
    this.mfgDate,
    this.expDate,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      categoryId: json["category_id"] as String? ?? "",
      productId: json["product_id"] as String? ?? "",
      productName: json["product_name"] as String? ?? "",
      productPrice: json["product_price"] as num? ?? 0,
      productActive: json["product_active"] as bool? ?? false,
      productImage: json["product_image"] as String? ?? "",
      productQuantity: json["product_quantity"] as num? ?? 0,
      createdAt: json["created_at"] as String? ?? "",
      productDescription: json["product_description"] as String? ?? "",
      isCountable: json["is_countable"] as bool? ?? true,
      mfgDate: json["mfg_date"] as String? ?? "",
      expDate: json["exp_date"] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category_id": categoryId,
      "product_id": productId,
      "product_name": productName,
      "product_price": productPrice,
      "product_active": productActive,
      "product_image": productImage,
      "product_quantity": productQuantity,
      "created_at": createdAt,
      "product_description": productDescription,
      "search_keywords": productName.toLowerCase(),
      "is_countable": isCountable,
      "mfg_date": mfgDate ?? "",
      "exp_date": expDate ?? "",
    };
  }
}
