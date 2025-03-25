part of 'search_products_bloc.dart';

abstract class SearchProductsEvent {}

class SearchProducts extends SearchProductsEvent {
  final String categoryId;
  final String productName;

  SearchProducts({required this.categoryId, required this.productName});
}

class GlobalSearchProducts extends SearchProductsEvent {
  final String productName;

  GlobalSearchProducts({required this.productName});
}
