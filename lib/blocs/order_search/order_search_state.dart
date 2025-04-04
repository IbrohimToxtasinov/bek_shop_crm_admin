part of 'order_search_bloc.dart';

abstract class OrderSearchState {}

class SearchOrdersInitial extends OrderSearchState {}

class SearchOrdersLoading extends OrderSearchState {}

class SearchOrdersSuccess extends OrderSearchState {
  List<OrderModel> orders;

  SearchOrdersSuccess({required this.orders});
}

class SearchOrdersFailure extends OrderSearchState {
  final String errorText;

  SearchOrdersFailure({required this.errorText});
}
