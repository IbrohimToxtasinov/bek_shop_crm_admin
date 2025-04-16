part of 'products_pdf_bloc.dart';

abstract class ProductsPdfEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GenerateAndSharePdfEvent extends ProductsPdfEvent {
  final bool share;

  GenerateAndSharePdfEvent({required this.share});

  @override
  List<Object> get props => [share];
}

class GenerateAndSharePdfForCategoryEvent extends ProductsPdfEvent {
  final bool share;
  final String categoryName;
  final String categoryId;

  GenerateAndSharePdfForCategoryEvent({
    required this.categoryName,
    required this.categoryId,
    required this.share,
  });

  @override
  List<Object> get props => [share];
}
