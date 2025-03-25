part of 'product_bloc.dart';

class ProductState extends Equatable {
  final List<ProductModel> products;
  final FormStatus status;
  final String errorMessage;

  const ProductState({required this.products, required this.status, required this.errorMessage});

  ProductState copyWith({List<ProductModel>? products, FormStatus? status, String? errorMessage}) {
    return ProductState(
      products: products ?? this.products,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [products, status, errorMessage];
}
