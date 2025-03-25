import 'dart:io';

import 'package:bek_shop/data/enums/form_status.dart';
import 'package:bek_shop/data/models/category/category_model.dart';
import 'package:bek_shop/data/models/responses/upload_image_response_model.dart';
import 'package:bek_shop/data/repositories/category_repository.dart';
import 'package:bek_shop/data/repositories/upload_image_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc(this._categoryRepository, this._uploadImageRepository)
    : super(CategoryState(categories: [], errorMessage: "", status: FormStatus.pure)) {
    on<AddCategory>(_addCategory);
    on<UpdateCategory>(_updateCategory);
    on<FetchCategory>(_fetchCategory);
    on<DeleteCategory>(_deleteCategory);
  }

  final CategoryRepository _categoryRepository;
  final UploadImageRepository _uploadImageRepository;

  _fetchCategory(FetchCategory event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(status: FormStatus.categoryLoading));
    try {
      await for (var categories in _categoryRepository.getAllCategories()) {
        emit(state.copyWith(status: FormStatus.categorySuccess, categories: categories));
      }
    } catch (error) {
      emit(state.copyWith(errorMessage: state.errorMessage, status: FormStatus.categoryFail));
    }
  }

  _addCategory(AddCategory event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(status: FormStatus.uploadImageCategoryLoading));
    UploadImageResponse uploadImageResponse = await _uploadImageRepository.uploadCategoryImage(
      imageFile: event.imageFile,
    );
    await Future.delayed(Duration(seconds: 2));
    if (uploadImageResponse.errorMessage.isEmpty) {
      emit(state.copyWith(status: FormStatus.uploadImageCategorySuccess));
      await Future.delayed(Duration(seconds: 1));
      emit(state.copyWith(status: FormStatus.addCategoryLoading));
      await Future.delayed(Duration(seconds: 2));
      try {
        await _categoryRepository.addCategory(
          categoryModel: CategoryModel(
            categoryId: "",
            categoryName: event.categoryName,
            categoryImage: uploadImageResponse.data,
            createdAt: DateTime.now().toString(),
          ),
        );
        emit(state.copyWith(status: FormStatus.addCategorySuccess));
      } catch (error) {
        emit(state.copyWith(errorMessage: state.errorMessage, status: FormStatus.addCategoryFail));
      }
    } else {
      emit(
        state.copyWith(
          status: FormStatus.uploadImageCategoryFail,
          errorMessage: uploadImageResponse.errorMessage,
        ),
      );
    }
  }

  _deleteCategory(DeleteCategory event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(status: FormStatus.deleteCategoryLoading));
    try {
      await _categoryRepository.deleteCategory(categoryId: event.categoryId);
      emit(state.copyWith(status: FormStatus.deleteCategorySuccess));
    } catch (error) {
      emit(state.copyWith(status: FormStatus.deleteCategoryFail, errorMessage: error.toString()));
    }
  }

  _updateCategory(UpdateCategory event, Emitter<CategoryState> emit) async {
    if (event.imageFile != null) {
      emit(state.copyWith(status: FormStatus.uploadImageCategoryLoading));
      UploadImageResponse uploadImageResponse = await _uploadImageRepository.uploadCategoryImage(
        imageFile: event.imageFile,
      );
      await Future.delayed(Duration(seconds: 2));
      if (uploadImageResponse.errorMessage.isEmpty) {
        emit(state.copyWith(status: FormStatus.uploadImageCategorySuccess));
        await Future.delayed(Duration(seconds: 1));
        emit(state.copyWith(status: FormStatus.updateCategoryLoading));
        await Future.delayed(Duration(seconds: 2));
        try {
          await _categoryRepository.updateCategory(categoryModel: event.categoryModel);
          emit(state.copyWith(status: FormStatus.updateCategorySuccess));
        } catch (error) {
          emit(
            state.copyWith(status: FormStatus.updateCategoryFail, errorMessage: error.toString()),
          );
        }
      } else {
        emit(
          state.copyWith(
            status: FormStatus.uploadImageCategoryFail,
            errorMessage: uploadImageResponse.errorMessage,
          ),
        );
      }
    } else {
      emit(state.copyWith(status: FormStatus.updateCategoryLoading));
      await Future.delayed(Duration(seconds: 2));
      try {
        await _categoryRepository.updateCategory(categoryModel: event.categoryModel);
        emit(state.copyWith(status: FormStatus.updateCategorySuccess));
      } catch (error) {
        emit(state.copyWith(status: FormStatus.updateCategoryFail, errorMessage: error.toString()));
      }
    }
  }
}
