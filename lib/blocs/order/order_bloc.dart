import 'package:bek_shop/data/models/cart/cart_model.dart';
import 'package:bek_shop/data/models/lat_long/lat_long_model.dart';
import 'package:bek_shop/data/models/order/order_model.dart';
import 'package:bek_shop/data/models/order/order_product_model.dart';
import 'package:bek_shop/data/models/product/product_model.dart';
import 'package:bek_shop/data/repositories/order_repository.dart';
import 'package:bek_shop/data/repositories/product_repository.dart';
import 'package:bloc/bloc.dart';

part 'order_event.dart';

part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc(this._orderRepository, this._productRepository) : super(OrderInitial()) {
    on<FetchOrders>(_fetchOrders);
    on<CreateOrder>(_createOrder);
  }

  final OrderRepository _orderRepository;
  final ProductRepository _productRepository;

  _fetchOrders(FetchOrders event, Emitter<OrderState> emit) async {
    emit(GetOrderLoadInProgress());
    try {
      await for (var orders in _orderRepository.getAllOrders()) {
        emit(GetOrderLoadInSuccess(orders: orders));
      }
    } catch (error) {
      emit(GetOrderLoadInFailure(errorText: error.toString()));
    }
  }

  _createOrder(CreateOrder event, Emitter<OrderState> emit) async {
    emit(CreateOrderLoadInProgress());
    try {
      List<OrderProductModel> products = [];
      num totalPrice = 0;
      for (int i = 0; i < event.products.length; i++) {
        totalPrice = totalPrice + event.products[i].productPrice * event.products[i].count;
        OrderProductModel product = OrderProductModel(
          productImage: event.products[i].productImage,
          productName: event.products[i].productName,
          productPrice: event.products[i].productPrice,
          productId: event.products[i].productId,
          categoryId: event.products[i].categoryId,
          count: event.products[i].count,
          isCountable: event.products[i].isCountable == 1 ? true : false,
        );
        products.add(product);
      }
      await _orderRepository.createOrder(
        orderModel: OrderModel(
          orderId: "",
          totalPrice: totalPrice,
          clientName: event.clientName,
          clientPhoneNumber: event.clientPhoneNumber,
          clientAddress: event.clientAddress,
          createAt: DateTime.now().toString(),
          products: products,
          latLong: event.latLong,
        ),
      );
      await Future.delayed(Duration(seconds: 2));
      emit(CreateOrderLoadInSuccess());
      await Future.delayed(Duration(seconds: 1));
      emit(UpdateProductLoadInProgress());
      try {
        for (int i = 0; i < event.products.length; i++) {
          await _productRepository.updateProduct(
            productModel: ProductModel(
              isCountable: event.products[i].isCountable == 1 ? true : false,
              categoryId: event.products[i].categoryId,
              productId: event.products[i].productId,
              productName: event.products[i].productName,
              productPrice: event.products[i].productPrice,
              productActive:
                  event.products[i].productQuantity - event.products[i].count == 0 ? false : true,
              productImage: event.products[i].productImage,
              productQuantity: event.products[i].productQuantity - event.products[i].count,
              createdAt: event.products[i].createdAt,
              productDescription: event.products[i].productDescription,
              mfgDate: event.products[i].mfgDate,
              expDate: event.products[i].expDate,
            ),
          );
          await Future.delayed(Duration(seconds: 1));
          emit(UpdateProductLoadInSuccess());
        }
      } catch (error) {
        emit(UpdateProductInFailure(errorMessage: error.toString()));
      }
    } catch (errorMessage) {
      emit(CreateOrderInFailure(errorText: errorMessage.toString()));
    }
  }
}
