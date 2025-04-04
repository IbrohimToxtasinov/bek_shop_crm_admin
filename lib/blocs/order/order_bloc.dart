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
    on<EditOrder>(_editOrder);
    on<DeleteOrderById>(_deleteOrderById);
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
          productQuantity: event.products[i].productQuantity,
          productImage: event.products[i].productImage,
          productName: event.products[i].productName,
          productPrice: event.products[i].productPrice,
          productId: event.products[i].productId,
          categoryId: event.products[i].categoryId,
          count: event.products[i].count,
          isCountable: event.products[i].isCountable == 1 ? true : false,
          productActive: event.products[i].productActive == 1 ? true : false,
          createdAt: event.products[i].createdAt,
          productDescription: event.products[i].productDescription,
          mfgDate: event.products[i].mfgDate ?? "",
          expDate: event.products[i].expDate ?? "",
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

  _editOrder(EditOrder event, Emitter<OrderState> emit) async {
    emit(EditOrderLoadInProgress());
    try {
      num totalPrice = 0;
      for (int i = 0; i < event.orderModel.products.length; i++) {
        totalPrice =
            totalPrice +
            event.orderModel.products[i].productPrice * event.orderModel.products[i].count;
      }
      await _orderRepository.updateOrder(
        orderModel: OrderModel(
          orderId: event.orderModel.orderId,
          clientName: event.orderModel.clientName,
          clientPhoneNumber: event.orderModel.clientPhoneNumber,
          clientAddress: event.orderModel.clientAddress,
          createAt: DateTime.now().toString(),
          totalPrice: totalPrice,
          latLong: event.orderModel.latLong,
          products: event.orderModel.products,
        ),
      );
      await Future.delayed(Duration(seconds: 2));
      emit(EditOrderLoadInSuccess());
      await Future.delayed(Duration(seconds: 1));
      emit(UpdateProductLoadInProgress());
      try {
        for (int i = 0; i < event.deleteProducts.length; i++) {
          await _productRepository.updateProduct(
            productModel: ProductModel(
              isCountable: event.deleteProducts[i].isCountable,
              categoryId: event.deleteProducts[i].categoryId,
              productId: event.deleteProducts[i].productId,
              productName: event.deleteProducts[i].productName,
              productPrice: event.deleteProducts[i].productPrice,
              productImage: event.deleteProducts[i].productImage,
              productQuantity: event.deleteProducts[i].productQuantity,
              productActive: event.deleteProducts[i].productActive,
              productDescription: event.deleteProducts[i].productDescription,
              mfgDate: event.deleteProducts[i].mfgDate,
              expDate: event.deleteProducts[i].expDate,
              createdAt: event.deleteProducts[i].createdAt,
            ),
          );
        }
        for (int i = 0; i < event.orderModel.products.length; i++) {
          await _productRepository.updateProduct(
            productModel: ProductModel(
              isCountable: event.orderModel.products[i].isCountable,
              categoryId: event.orderModel.products[i].categoryId,
              productId: event.orderModel.products[i].productId,
              productName: event.orderModel.products[i].productName,
              productPrice: event.orderModel.products[i].productPrice,
              productActive:
                  event.orderModel.products[i].productQuantity -
                              event.orderModel.products[i].count ==
                          0
                      ? false
                      : true,
              productImage: event.orderModel.products[i].productImage,
              productQuantity:
                  event.orderModel.products[i].productQuantity - event.orderModel.products[i].count,
              createdAt: event.orderModel.products[i].createdAt,
              productDescription: event.orderModel.products[i].productDescription,
              mfgDate: event.orderModel.products[i].mfgDate,
              expDate: event.orderModel.products[i].expDate,
            ),
          );
          await Future.delayed(Duration(seconds: 1));
          emit(UpdateProductLoadInSuccess());
        }
      } catch (error) {
        emit(UpdateProductInFailure(errorMessage: error.toString()));
      }
    } catch (errorMessage) {
      emit(EditOrderInFailure(errorText: errorMessage.toString()));
    }
  }

  _deleteOrderById(DeleteOrderById event, Emitter<OrderState> emit) async {
    emit(DeleteOrderLoadInProgress());
    try {
      await _orderRepository.deleteOrderById(orderId: event.orderId);
      await Future.delayed(Duration(seconds: 2));
      emit(DeleteOrderLoadInSuccess());
      await Future.delayed(Duration(seconds: 1));
      emit(UpdateProductLoadInProgress());
      try {
        for (int i = 0; i < event.deleteProducts.length; i++) {
          await _productRepository.updateProduct(
            productModel: ProductModel(
              isCountable: event.deleteProducts[i].isCountable,
              categoryId: event.deleteProducts[i].categoryId,
              productId: event.deleteProducts[i].productId,
              productName: event.deleteProducts[i].productName,
              productPrice: event.deleteProducts[i].productPrice,
              productImage: event.deleteProducts[i].productImage,
              productQuantity: event.deleteProducts[i].productQuantity,
              productActive: event.deleteProducts[i].productActive,
              productDescription: event.deleteProducts[i].productDescription,
              mfgDate: event.deleteProducts[i].mfgDate,
              expDate: event.deleteProducts[i].expDate,
              createdAt: event.deleteProducts[i].createdAt,
            ),
          );
        }
        await Future.delayed(Duration(seconds: 1));
        emit(UpdateProductLoadInSuccess());
      } catch (error) {
        emit(UpdateProductInFailure(errorMessage: error.toString()));
      }
    } catch (error) {
      emit(DeleteOrderInFailure(errorText: error.toString()));
    }
  }
}
