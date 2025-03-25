import 'dart:io';
import 'package:bek_shop/data/enums/form_status.dart';
import 'package:bek_shop/data/models/product/product_model.dart';
import 'package:bek_shop/data/models/responses/upload_image_response_model.dart';
import 'package:bek_shop/data/repositories/product_repository.dart';
import 'package:bek_shop/data/repositories/upload_image_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(this._productRepository, this._uploadImageRepository)
    : super(ProductState(products: [], status: FormStatus.pure, errorMessage: "")) {
    on<FetchProductByCategoryId>(_fetchProductByCategoryId);
    on<AddProduct>(_addProduct);
    on<UpdateProduct>(_updateProduct);
    on<DeleteProduct>(_deleteProduct);
  }

  final ProductRepository _productRepository;
  final UploadImageRepository _uploadImageRepository;

  _fetchProductByCategoryId(FetchProductByCategoryId event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: FormStatus.productLoading));
    try {
      await for (var products in _productRepository.getProductsByCategoryId(
        categoryId: event.categoryId,
      )) {
        emit(state.copyWith(status: FormStatus.productSuccess, products: products));
      }
    } catch (error) {
      emit(state.copyWith(errorMessage: state.errorMessage, status: FormStatus.productFail));
    }
  }

  _addProduct(AddProduct event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: FormStatus.uploadImageProductLoading));
    UploadImageResponse uploadImageResponse = await _uploadImageRepository.uploadProductImage(
      imageFile: event.imageFile,
    );
    await Future.delayed(Duration(seconds: 2));
    if (uploadImageResponse.errorMessage.isEmpty) {
      emit(state.copyWith(status: FormStatus.uploadImageProductSuccess));
      await Future.delayed(Duration(seconds: 1));
      emit(state.copyWith(status: FormStatus.addProductLoading));
      await Future.delayed(Duration(seconds: 2));
      try {
        await _productRepository.addProduct(
          productModel: ProductModel(
            productId: "",
            categoryId: event.categoryId,
            productName: event.productName,
            createdAt: DateTime.now().toString(),
            productImage: uploadImageResponse.data,
            productActive: event.productActive,
            productDescription: event.productDescription,
            productPrice: event.productPrice,
            productQuantity: event.productQuantity,
            isCountable: event.isCountable,
            mfgDate: event.mfgDate,
            expDate: event.expDate,
          ),
        );
        emit(state.copyWith(status: FormStatus.addProductSuccess));
      } catch (error) {
        emit(state.copyWith(errorMessage: state.errorMessage, status: FormStatus.addProductFail));
      }
    } else {
      emit(
        state.copyWith(
          status: FormStatus.uploadImageProductFail,
          errorMessage: uploadImageResponse.errorMessage,
        ),
      );
    }
  }

  _deleteProduct(DeleteProduct event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: FormStatus.deleteProductLoading));
    try {
      await _productRepository.deleteProduct(productId: event.productId);
      emit(state.copyWith(status: FormStatus.deleteProductSuccess));
    } catch (error) {
      emit(state.copyWith(status: FormStatus.deleteProductFail, errorMessage: error.toString()));
    }
  }

  _updateProduct(UpdateProduct event, Emitter<ProductState> emit) async {
    if (event.imageFile != null) {
      emit(state.copyWith(status: FormStatus.uploadImageProductLoading));
      UploadImageResponse uploadImageResponse = await _uploadImageRepository.uploadProductImage(
        imageFile: event.imageFile,
      );
      await Future.delayed(Duration(seconds: 2));
      if (uploadImageResponse.errorMessage.isEmpty) {
        emit(state.copyWith(status: FormStatus.uploadImageProductSuccess));
        await Future.delayed(Duration(seconds: 1));
        emit(state.copyWith(status: FormStatus.updateProductLoading));
        await Future.delayed(Duration(seconds: 2));
        try {
          await _productRepository.updateProduct(productModel: event.productModel);
          emit(state.copyWith(status: FormStatus.updateProductSuccess));
        } catch (error) {
          emit(
            state.copyWith(status: FormStatus.updateProductFail, errorMessage: error.toString()),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: FormStatus.uploadImageProductFail,
            errorMessage: uploadImageResponse.errorMessage,
          ),
        );
      }
    } else {
      emit(state.copyWith(status: FormStatus.updateProductLoading));
      await Future.delayed(Duration(seconds: 2));
      try {
        await _productRepository.updateProduct(productModel: event.productModel);
        emit(state.copyWith(status: FormStatus.updateProductSuccess));
      } catch (error) {
        emit(state.copyWith(status: FormStatus.updateProductFail, errorMessage: error.toString()));
      }
    }
  }
}
