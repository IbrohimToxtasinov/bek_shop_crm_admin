part of 'order_bloc.dart';

abstract class OrderState {}

/// Initial Cart
class OrderInitial extends OrderState {}

/// GET ORDERS
class GetOrderLoadInProgress extends OrderState {}

class GetOrderLoadInSuccess implements OrderState {
  final List<OrderModel> orders;

  GetOrderLoadInSuccess({required this.orders});
}

class GetOrderLoadInFailure extends OrderState {
  String errorText;

  GetOrderLoadInFailure({required this.errorText});
}

/// CREATE ORDER
class CreateOrderLoadInProgress extends OrderState {}

class CreateOrderLoadInSuccess extends OrderState {}

class CreateOrderInFailure extends OrderState {
  final String errorText;

  CreateOrderInFailure({required this.errorText});
}

/// UPDATE PRODUCT FROM FIREBASE
class UpdateProductLoadInProgress extends OrderState {}

class UpdateProductLoadInSuccess extends OrderState {}

class UpdateProductInFailure extends OrderState {
  final String errorMessage;

  UpdateProductInFailure({required this.errorMessage});
}

/// Edit ORDER
class EditOrderLoadInProgress extends OrderState {}

class EditOrderLoadInSuccess extends OrderState {}

class EditOrderInFailure extends OrderState {
  EditOrderInFailure({required this.errorText});

  final String errorText;
}

/// Edit ORDER
class DeleteOrderLoadInProgress extends OrderState {}

class DeleteOrderLoadInSuccess extends OrderState {}

class DeleteOrderInFailure extends OrderState {
  DeleteOrderInFailure({required this.errorText});

  final String errorText;
}
