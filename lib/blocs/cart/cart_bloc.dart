import 'package:bek_shop/data/models/cart/cart_model.dart';
import 'package:bek_shop/data/repositories/cart_repository.dart';
import 'package:bloc/bloc.dart';

part 'cart_event.dart';

part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc(this._cartRepository) : super(InitialStateGet()) {
    on<UpdateCart>(_updateCart);
    on<DeleteCartById>(_deleteCartById);
    on<DeleteCart>(_deleteCart);
    on<FetchCarts>(_fetchCarts);
    on<AddCart>(_addCart);
    add(FetchCarts());
  }

  final CartRepository _cartRepository;

  /// UPDATE CART
  _updateCart(UpdateCart event, Emitter<CartState> emit) async {
    emit(LoadInProgressUpdate());
    try {
      await _cartRepository.updateCartProductById(cartModel: event.cartModel);
      emit(LoadInSuccessUpdate());
    } catch (errorMessage) {
      emit(LoadInFailureUpdate(errorMessage: errorMessage.toString()));
    }
  }

  /// FETCH CART
  _fetchCarts(FetchCarts event, Emitter<CartState> emit) async {
    emit(CartLoadInProgressGet());
    try {
      await for (var products in _cartRepository.getAllCartProducts()) {
        emit(CartLoadInSuccessGet(products: products));
      }
    } catch (error) {
      emit(CartLoadInFailureGet(errorText: error.toString()));
    }
  }

  /// DELETE CART BY ID
  _deleteCartById(DeleteCartById event, Emitter<CartState> emit) async {
    emit(LoadInProgressDeleteById());
    try {
      await _cartRepository.deleteCartProductById(id: event.id);
      emit(LoadInSuccessDeleteById());
    } catch (errorMessage) {
      emit(LoadInFailureDeleteById(errorMessage: errorMessage.toString()));
    }
  }

  /// DELETE CART
  _deleteCart(DeleteCart event, Emitter<CartState> emit) async {
    emit(LoadInProgressDelete());
    try {
      await _cartRepository.deleteAllCartProducts();
      emit(LoadInSuccessDelete());
      add(FetchCarts());
    } catch (errorMessage) {
      emit(LoadInFailureDelete(errorMessage: errorMessage.toString()));
    }
  }

  /// ADD CART
  _addCart(AddCart event, Emitter<CartState> emit) async {
    emit(LoadInProgressAdd());
    try {
      await _cartRepository.insertToCartProduct(cartModel: event.cartModel);
      emit(LoadInSuccessAdd());
      add(FetchCarts());
    } catch (errorMessage) {
      emit(LoadInFailureAdd(errorMessage: errorMessage.toString()));
    }
  }
}
