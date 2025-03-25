part of 'product_bloc.dart';

abstract class ProductEvent {}

class FetchProductByCategoryId extends ProductEvent {
  final String categoryId;

  FetchProductByCategoryId({required this.categoryId});
}

class AddProduct extends ProductEvent {
  final String categoryId;
  final String productName;
  final String productDescription;
  final double productPrice;
  final double productQuantity;
  final bool isCountable;
  final bool productActive;
  final File imageFile;
  final String? mfgDate;
  final String? expDate;

  AddProduct({
    required this.productDescription,
    required this.productPrice,
    required this.productQuantity,
    required this.categoryId,
    required this.productName,
    required this.isCountable,
    required this.productActive,
    required this.imageFile,
    this.mfgDate,
    this.expDate,
  });
}

class UpdateProduct extends ProductEvent {
  final ProductModel productModel;
  final File? imageFile;

  UpdateProduct({this.imageFile, required this.productModel});
}

class DeleteProduct extends ProductEvent {
  final String productId;

  DeleteProduct({required this.productId});
}
