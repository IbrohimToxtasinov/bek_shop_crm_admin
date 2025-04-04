part of 'order_edit_cart_bloc.dart';

abstract class OrderEditCartEvent {}

class OrderEditCartProductsEqualsToCart extends OrderEditCartEvent {
  List<OrderProductModel> products;

  OrderEditCartProductsEqualsToCart({required this.products});
}

class AddProductOrderEditCartProducts extends OrderEditCartEvent {
  OrderProductModel product;

  AddProductOrderEditCartProducts({required this.product});
}

class UpdateOrderEditCartProduct extends OrderEditCartEvent {
  OrderProductModel product;

  UpdateOrderEditCartProduct({required this.product});
}

class DeleteOrderEditCartProductById extends OrderEditCartEvent {
  String productId;

  DeleteOrderEditCartProductById({required this.productId});
}

class FetchOrderEditCartProducts extends OrderEditCartEvent {}
