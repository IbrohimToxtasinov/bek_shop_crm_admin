import 'package:bek_shop/data/models/order/order_product_model.dart';
import 'package:bek_shop/data/models/order_edit_cart/order_edit_cart_model.dart';
import 'package:bloc/bloc.dart';

part 'order_edit_cart_event.dart';

part 'order_edit_cart_state.dart';

class OrderEditCartBloc extends Bloc<OrderEditCartEvent, OrderEditCartState> {
  OrderEditCartBloc() : super(OrderEditCartInitial()) {
    on<AddProductOrderEditCartProducts>(_addProductOrderEditCartProducts);
    on<FetchOrderEditCartProducts>(_fetchOrderEditCartProducts);
    on<OrderEditCartProductsEqualsToCart>(_orderEditCartProductsEqualsToCart);
    on<DeleteOrderEditCartProductById>(_deleteOrderEditCartProductById);
    on<UpdateOrderEditCartProduct>(_updateOrderEditCartProduct);
  }

  /// Fetch Order Edit Cart Products
  _fetchOrderEditCartProducts(
    FetchOrderEditCartProducts event,
    Emitter<OrderEditCartState> emit,
  ) async {
    emit(OrderEditCartGetProgress());
    try {
      emit(
        OrderEditCartGetSuccess(
          oldProducts: oldOrderEditCartProducts,
          newProducts: newOrderEditCartProducts,
        ),
      );
    } catch (error) {
      emit(OrderEditCartGetFailure(errorText: error.toString()));
    }
  }

  /// Order Edit Cart Products Equals To Cart
  _orderEditCartProductsEqualsToCart(
    OrderEditCartProductsEqualsToCart event,
    Emitter<OrderEditCartState> emit,
  ) async {
    emit(OrderEditCartEqualProgress());
    try {
      newOrderEditCartProducts = [];
      oldOrderEditCartProducts = [...event.products];
      emit(OrderEditCartEqualSuccess());
      add(FetchOrderEditCartProducts());
    } catch (errorMessage) {
      emit(OrderEditCartEqualFailure(errorText: errorMessage.toString()));
    }
  }

  /// Add Product to Order Edit Cart Products
  _addProductOrderEditCartProducts(
    AddProductOrderEditCartProducts event,
    Emitter<OrderEditCartState> emit,
  ) async {
    emit(OrderEditCartAddProgress());
    try {
      newOrderEditCartProducts.add(event.product);
      emit(OrderEditCartAddSuccess());
      add(FetchOrderEditCartProducts());
    } catch (errorMessage) {
      emit(OrderEditCartAddFailure(errorText: errorMessage.toString()));
    }
  }

  /// Delete Order Edit Cart Products By ID
  Future<void> _deleteOrderEditCartProductById(
    DeleteOrderEditCartProductById event,
    Emitter<OrderEditCartState> emit,
  ) async {
    emit(OrderEditCartDeleteByIdProgress());
    try {
      if (oldOrderEditCartProducts.isNotEmpty) {
        oldOrderEditCartProducts.removeWhere((element) => element.productId == event.productId);
      }
      if (newOrderEditCartProducts.isNotEmpty) {
        newOrderEditCartProducts.removeWhere((element) => element.productId == event.productId);
      }
      emit(OrderEditCartDeleteByIdSuccess());
      add(FetchOrderEditCartProducts());
    } catch (error) {
      emit(OrderEditCartDeleteByIdFailure(errorText: error.toString()));
    }
  }

  /// Update Order Edit Cart Products By ID
  Future<void> _updateOrderEditCartProduct(
    UpdateOrderEditCartProduct event,
    Emitter<OrderEditCartState> emit,
  ) async {
    emit(OrderEditCartUpdateProgress());
    try {
      if (oldOrderEditCartProducts.isNotEmpty) {
        for (int i = 0; i < oldOrderEditCartProducts.length; i++) {
          if (oldOrderEditCartProducts[i].productId == event.product.productId) {
            oldOrderEditCartProducts[i] = event.product;
            break;
          }
        }
      }
      if (newOrderEditCartProducts.isNotEmpty) {
        for (int i = 0; i < newOrderEditCartProducts.length; i++) {
          if (newOrderEditCartProducts[i].productId == event.product.productId) {
            newOrderEditCartProducts[i] = event.product;
            break;
          }
        }
      }
      emit(OrderEditCartUpdateSuccess());
      add(FetchOrderEditCartProducts());
    } catch (error) {
      emit(OrderEditCartUpdateFailure(errorText: error.toString()));
    }
  }
}
