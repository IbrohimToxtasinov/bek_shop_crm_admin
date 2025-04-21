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
  OrderBloc(this._orderRepository, this._productRepository)
    : super(OrderInitial()) {
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
        num productPrice =
            event.products[i].isExpensive == 1
                ? event.products[i].productPrice +
                    event.products[i].expensivePrice
                : event.products[i].productPrice + event.products[i].cheapPrice;
        totalPrice = totalPrice + productPrice * event.products[i].count;
        OrderProductModel product = OrderProductModel(
          isExpensive: event.products[i].isExpensive == 1 ? true : false,
          cheapPrice: event.products[i].cheapPrice,
          expensivePrice: event.products[i].expensivePrice,
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
          updatedAt: event.products[i].updatedAt,
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
          ProductModel? product = await _productRepository
              .getProductByProductId(productId: event.products[i].productId);
          if (product != null) {
            await _productRepository.updateProduct(
              productModel: ProductModel(
                cheapPrice: product.cheapPrice,
                expensivePrice: product.expensivePrice,
                categoryId: product.categoryId,
                productId: product.productId,
                createdAt: product.createdAt,
                isCountable: product.isCountable,
                productDescription: product.productDescription,
                updatedAt: product.updatedAt,
                productImage: product.productImage,
                productName: product.productName,
                productPrice: product.productPrice,
                expDate: product.expDate,
                mfgDate: product.mfgDate,
                productQuantity:
                    product.productQuantity - event.products[i].count,
                productActive:
                    product.productQuantity - event.products[i].count > 0
                        ? true
                        : false,
              ),
            );
          }
        }
        await Future.delayed(Duration(seconds: 1));
        emit(UpdateProductLoadInSuccess());
      } catch (error) {
        print("error product: $error");
        emit(UpdateProductInFailure(errorMessage: error.toString()));
      }
    } catch (errorMessage) {
      print("error order: $errorMessage");
      emit(CreateOrderInFailure(errorText: errorMessage.toString()));
    }
  }

  _editOrder(EditOrder event, Emitter<OrderState> emit) async {
    emit(EditOrderLoadInProgress());
    try {
      num totalPrice = 0;
      for (int i = 0; i < event.orderModel.products.length; i++) {
        num productPrice =
              event.orderModel.products[i].isExpensive
                ? event.orderModel.products[i].productPrice +
                    event.orderModel.products[i].expensivePrice
                : event.orderModel.products[i].productPrice +
                    event.orderModel.products[i].cheapPrice;
        totalPrice =
            totalPrice + productPrice * event.orderModel.products[i].count;
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
          ProductModel? product = await _productRepository
              .getProductByProductId(
                productId: event.deleteProducts[i].productId,
              );
          if (product != null) {
            await _productRepository.updateProduct(
              productModel: ProductModel(
                cheapPrice: product.cheapPrice,
                expensivePrice: product.expensivePrice,
                isCountable: product.isCountable,
                categoryId: product.categoryId,
                productId: product.productId,
                productName: product.productName,
                productPrice: product.productPrice,
                productImage: product.productImage,
                productQuantity:
                    product.productQuantity + event.deleteProducts[i].count,
                productActive: product.productActive,
                productDescription: product.productDescription,
                mfgDate: product.mfgDate,
                expDate: product.expDate,
                createdAt: product.createdAt,
                updatedAt: product.updatedAt,
              ),
            );
          }
        }
        for (int i = 0; i < event.orderModel.products.length; i++) {
          ProductModel? product = await _productRepository
              .getProductByProductId(
                productId: event.orderModel.products[i].productId,
              );
          if (product != null) {
            await _productRepository.updateProduct(
              productModel: ProductModel(
                cheapPrice: product.cheapPrice,
                expensivePrice: product.expensivePrice,
                isCountable: product.isCountable,
                categoryId: product.categoryId,
                productId: product.productId,
                productName: product.productName,
                productDescription: product.productDescription,
                productPrice: product.productPrice,
                productActive:
                    product.productQuantity -
                                event.orderModel.products[i].count >
                            0
                        ? true
                        : false,
                productImage: product.productImage,
                productQuantity:
                    product.productQuantity -
                    event.orderModel.products[i].count,
                createdAt: product.createdAt,
                updatedAt: product.updatedAt,
                mfgDate: product.mfgDate,
                expDate: product.expDate,
              ),
            );
          }
        }
        await Future.delayed(Duration(seconds: 1));
        emit(UpdateProductLoadInSuccess());
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
          ProductModel? product = await _productRepository
              .getProductByProductId(
                productId: event.deleteProducts[i].productId,
              );
          if (product != null) {
            await _productRepository.updateProduct(
              productModel: ProductModel(
                cheapPrice: product.cheapPrice,
                expensivePrice: product.expensivePrice,
                isCountable: product.isCountable,
                categoryId: product.categoryId,
                productId: product.productId,
                productName: product.productName,
                productPrice: product.productPrice,
                productImage: product.productImage,
                productQuantity:
                    product.productQuantity + event.deleteProducts[i].count,
                productActive:
                    product.productQuantity + event.deleteProducts[i].count > 0
                        ? true
                        : false,
                productDescription: product.productDescription,
                mfgDate: product.mfgDate,
                expDate: product.expDate,
                createdAt: product.createdAt,
                updatedAt: product.updatedAt,
              ),
            );
          }
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
