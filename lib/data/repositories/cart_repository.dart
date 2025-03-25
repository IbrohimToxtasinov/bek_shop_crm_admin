import 'package:bek_shop/data/db/local_database.dart';
import 'package:bek_shop/data/models/cart/cart_model.dart';

class CartRepository {
  /// DELETE ALL CART-PRODUCTS
  Future<int> deleteAllCartProducts() => LocalDatabase.deleteAllCartProducts();

  /// DELETE CART-PRODUCT BY ID
  Future<int> deleteCartProductById({required int id}) =>
      LocalDatabase.deleteCartProductById(id: id);

  /// INSERT TO CART-PRODUCT
  Future<CartModel> insertToCartProduct({required CartModel cartModel}) =>
      LocalDatabase.insertToCartProduct(cartModel: cartModel);

  /// GET ALL CART-PRODUCTS
  Stream<List<CartModel>> getAllCartProducts() => LocalDatabase.getAllCartProductsStream();

  /// UPDATE CART-PRODUCT BY ID
  Future<CartModel> updateCartProductById({required CartModel cartModel}) =>
      LocalDatabase.updateCartProductById(cartModel: cartModel);
}
