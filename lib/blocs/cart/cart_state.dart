part of 'cart_bloc.dart';

abstract class CartState {
  late List<CartModel> products = [];
}

/// Initial Cart
class InitialStateGet extends CartState {}

/// GET Cart
class CartLoadInProgressGet extends CartState {}

class CartLoadInSuccessGet implements CartState {
  @override
  List<CartModel> products;

  CartLoadInSuccessGet({required this.products});
}

class CartLoadInFailureGet extends CartState {
  String errorText;

  CartLoadInFailureGet({required this.errorText});
}

/// ADD Cart
class LoadInProgressAdd extends CartState {}

class LoadInSuccessAdd extends CartState {}

class LoadInFailureAdd extends CartState {
  final String errorMessage;

  LoadInFailureAdd({required this.errorMessage});
}

/// UPDATE Cart
class LoadInProgressUpdate extends CartState {}

class LoadInSuccessUpdate extends CartState {}

class LoadInFailureUpdate extends CartState {
  final String errorMessage;

  LoadInFailureUpdate({required this.errorMessage});
}

/// DELETE Cart By Id
class LoadInProgressDeleteById extends CartState {}

class LoadInSuccessDeleteById extends CartState {}

class LoadInFailureDeleteById extends CartState {
  final String errorMessage;

  LoadInFailureDeleteById({required this.errorMessage});
}

/// DELETE Cart
class LoadInProgressDelete extends CartState {}

class LoadInSuccessDelete extends CartState {}

class LoadInFailureDelete extends CartState {
  final String errorMessage;

  LoadInFailureDelete({required this.errorMessage});
}
