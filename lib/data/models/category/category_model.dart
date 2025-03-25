class CategoryModel {
  final String categoryId;
  final String createdAt;
  final String categoryName;
  final String categoryImage;

  CategoryModel({
    required this.categoryId,
    required this.createdAt,
    required this.categoryName,
    required this.categoryImage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      categoryId: json["category_id"] as String? ?? "",
      createdAt: json["created_at"] as String? ?? "",
      categoryName: json["category_name"] as String? ?? "",
      categoryImage: json["category_image"] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "category_id": categoryId,
      "created_at": createdAt,
      "category_name": categoryName,
      "category_image": categoryImage,
    };
  }
}
