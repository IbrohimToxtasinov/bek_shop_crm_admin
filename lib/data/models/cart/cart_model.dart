class CartFields {
  static String id = "id";
  static String productId = "product_id";
  static String categoryId = "category_id";
  static String productImage = "product_image";
  static String productPrice = "product_price";
  static String productName = "product_name";
  static String productDescription = "product_description";
  static String productQuantity = "product_quantity";
  static String count = "count";
  static String createdAt = "created_at";
  static String updatedAt = "updated_at";
  static String isCountable = "is_countable";
  static String productActive = "product_active";
  static String mfgDate = "mfg_date";
  static String expDate = "exp_date";
}

class CartModel {
  final int? id;
  final String productId;
  final String categoryId;
  final String productName;
  final String productDescription;
  final String createdAt;
  final String updatedAt;
  final num productPrice;
  final String productImage;
  final int productQuantity;
  final int isCountable;
  final int productActive;
  final int count;
  final String? mfgDate;
  final String? expDate;

  CartModel({
    this.id,
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productQuantity,
    required this.isCountable,
    required this.count,
    required this.createdAt,
    required this.updatedAt,
    required this.productDescription,
    required this.productActive,
    this.mfgDate,
    this.expDate,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json[CartFields.id] as int? ?? -1,
      productId: json[CartFields.productId] as String? ?? "",
      categoryId: json[CartFields.categoryId] as String? ?? "",
      productName: json[CartFields.productName] as String? ?? "",
      productDescription: json[CartFields.productDescription] as String? ?? "",
      createdAt: json[CartFields.createdAt] as String? ?? "",
      updatedAt: json[CartFields.updatedAt] as String? ?? "",
      productPrice: json[CartFields.productPrice] as num? ?? 0,
      productImage: json[CartFields.productImage] as String? ?? "",
      productQuantity: json[CartFields.productQuantity] as int? ?? 0,
      isCountable: json[CartFields.isCountable] as int? ?? 0,
      productActive: json[CartFields.productActive] as int? ?? 0,
      count: json[CartFields.count] as int? ?? 0,
      mfgDate: json[CartFields.mfgDate] as String? ?? "",
      expDate: json[CartFields.expDate] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      CartFields.productId: productId,
      CartFields.categoryId: categoryId,
      CartFields.productName: productName,
      CartFields.productDescription: productDescription,
      CartFields.productPrice: productPrice,
      CartFields.productImage: productImage,
      CartFields.productQuantity: productQuantity,
      CartFields.createdAt: createdAt,
      CartFields.updatedAt: updatedAt,
      CartFields.isCountable: isCountable,
      CartFields.productActive: productActive,
      CartFields.count: count,
      CartFields.mfgDate: mfgDate,
      CartFields.expDate: expDate,
    };
  }

  CartModel copyWith({
    int? id,
    String? productId,
    String? categoryId,
    String? productName,
    String? productDescription,
    String? createdAt,
    String? updatedAt,
    double? productPrice,
    String? productImage,
    String? mfgDate,
    String? expDate,
    int? productQuantity,
    int? isCountable,
    int? productActive,
    int? count,
  }) {
    return CartModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productActive: productActive ?? this.productActive,
      categoryId: categoryId ?? this.categoryId,
      productName: productName ?? this.productName,
      productDescription: productDescription ?? this.productDescription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      productPrice: productPrice ?? this.productPrice,
      productImage: productImage ?? this.productImage,
      productQuantity: productQuantity ?? this.productQuantity,
      isCountable: isCountable ?? this.isCountable,
      count: count ?? this.count,
      mfgDate: mfgDate ?? this.mfgDate,
      expDate: expDate ?? this.expDate,
    );
  }
}
