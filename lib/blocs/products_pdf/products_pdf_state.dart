part of 'products_pdf_bloc.dart';

abstract class ProductsPdfState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProductsPdfInitial extends ProductsPdfState {}

class ProductsPdfLoading extends ProductsPdfState {}

class ProductsPdfGenerated extends ProductsPdfState {
  final String filePath;

  ProductsPdfGenerated(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class ProductsPdfError extends ProductsPdfState {
  final String message;

  ProductsPdfError(this.message);

  @override
  List<Object> get props => [message];
}

class CategoryProductsPdfLoading extends ProductsPdfState {}

class CategoryProductsPdfGenerated extends ProductsPdfState {
  final String filePath;

  CategoryProductsPdfGenerated(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class CategoryProductsPdfError extends ProductsPdfState {
  final String message;

  CategoryProductsPdfError(this.message);

  @override
  List<Object> get props => [message];
}
