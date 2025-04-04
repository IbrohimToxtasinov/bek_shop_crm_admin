part of 'order_search_bloc.dart';

@immutable
sealed class OrderSearchEvent {}

class SearchOrders extends OrderSearchEvent {
  final String clientName;

  SearchOrders({required this.clientName});
}
