part of 'order_edit_cart_bloc.dart';

abstract class OrderEditCartState {
  late List<OrderProductModel> oldProducts = [];
  late List<OrderProductModel> newProducts = [];
}

/// Initial Edit Order
class OrderEditCartInitial extends OrderEditCartState {}

/// Fetch Order Edit Cart
class OrderEditCartGetProgress extends OrderEditCartState {}

class OrderEditCartGetSuccess implements OrderEditCartState {
  @override
  List<OrderProductModel> oldProducts;

  @override
  List<OrderProductModel> newProducts;

  OrderEditCartGetSuccess({required this.oldProducts, required this.newProducts});
}

class OrderEditCartGetFailure extends OrderEditCartState {
  final String errorText;

  OrderEditCartGetFailure({required this.errorText});
}

/// Equal Order Edit Cart
class OrderEditCartEqualProgress extends OrderEditCartState {}

class OrderEditCartEqualSuccess extends OrderEditCartState {}

class OrderEditCartEqualFailure extends OrderEditCartState {
  final String errorText;

  OrderEditCartEqualFailure({required this.errorText});
}

/// Add Order Edit Cart
class OrderEditCartAddProgress extends OrderEditCartState {}

class OrderEditCartAddSuccess extends OrderEditCartState {}

class OrderEditCartAddFailure extends OrderEditCartState {
  final String errorText;

  OrderEditCartAddFailure({required this.errorText});
}

/// Update Edit Order
class OrderEditCartUpdateProgress extends OrderEditCartState {}

class OrderEditCartUpdateSuccess extends OrderEditCartState {}

class OrderEditCartUpdateFailure extends OrderEditCartState {
  final String errorText;

  OrderEditCartUpdateFailure({required this.errorText});
}

/// Delete By Id Edit Order
class OrderEditCartDeleteByIdProgress extends OrderEditCartState {}

class OrderEditCartDeleteByIdSuccess extends OrderEditCartState {}

class OrderEditCartDeleteByIdFailure extends OrderEditCartState {
  final String errorText;

  OrderEditCartDeleteByIdFailure({required this.errorText});
}
