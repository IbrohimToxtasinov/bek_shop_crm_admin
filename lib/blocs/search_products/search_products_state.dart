part of 'search_products_bloc.dart';

abstract class SearchProductsState {}

class SearchProductsInitial extends SearchProductsState {}

class SearchProductsLoading extends SearchProductsState {}

class SearchProductsSuccess extends SearchProductsState {
  List<ProductModel> products;

  SearchProductsSuccess({required this.products});
}

class SearchProductsFailure extends SearchProductsState {
  final String errorText;

  SearchProductsFailure({required this.errorText});
}

class GlobalSearchProductsLoading extends SearchProductsState {}

class GlobalSearchProductsSuccess extends SearchProductsState {
  List<ProductModel> products;

  GlobalSearchProductsSuccess({required this.products});
}

class GlobalSearchProductsFailure extends SearchProductsState {
  final String errorText;

  GlobalSearchProductsFailure({required this.errorText});
}
