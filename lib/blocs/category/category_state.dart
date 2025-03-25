part of 'category_bloc.dart';

class CategoryState extends Equatable {
  final List<CategoryModel> categories;
  final FormStatus status;
  final String errorMessage;

  const CategoryState({required this.categories, required this.status, required this.errorMessage});

  CategoryState copyWith({
    List<CategoryModel>? categories,
    FormStatus? status,
    String? errorMessage,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [categories, status, errorMessage];
}
