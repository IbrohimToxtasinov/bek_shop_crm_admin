part of 'cart_bloc.dart';

abstract class CartEvent {}

class AddCart extends CartEvent {
  CartModel cartModel;

  AddCart({required this.cartModel});
}

class UpdateCart extends CartEvent {
  CartModel cartModel;

  UpdateCart({required this.cartModel});
}

class DeleteCartById extends CartEvent {
  int id;

  DeleteCartById({required this.id});
}

class DeleteCart extends CartEvent {}

class FetchCarts extends CartEvent {}
