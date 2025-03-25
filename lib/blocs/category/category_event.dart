part of 'category_bloc.dart';

abstract class CategoryEvent {}

class FetchCategory extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final String categoryName;
  final File imageFile;

  AddCategory({required this.categoryName, required this.imageFile});
}

class UpdateCategory extends CategoryEvent {
  final CategoryModel categoryModel;
  final File? imageFile;

  UpdateCategory({required this.categoryModel, this.imageFile});
}

class DeleteCategory extends CategoryEvent {
  final String categoryId;

  DeleteCategory({required this.categoryId});
}
