import 'package:bek_shop/data/models/cart/cart_model.dart';
import 'package:bek_shop/screens/tab_box/cart/widgets/cart_item.dart';

import 'package:flutter/material.dart';

class CartProducts extends StatelessWidget {
  const CartProducts({super.key, required this.cartProducts});

  final List<CartModel> cartProducts;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartProducts.length,
      physics: const AlwaysScrollableScrollPhysics(parent: ClampingScrollPhysics()),
      itemBuilder: (context, index) {
        return CartItem(cartModel: cartProducts[index]);
      },
    );
  }
}
