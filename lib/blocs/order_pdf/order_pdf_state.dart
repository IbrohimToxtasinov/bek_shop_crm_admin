part of 'order_pdf_bloc.dart';

abstract class OrderPdfState extends Equatable {
  @override
  List<Object> get props => [];
}

class OrderPdfInitial extends OrderPdfState {}

class OrderPdfLoading extends OrderPdfState {}

class OrderPdfGenerated extends OrderPdfState {
  final String filePath;

  OrderPdfGenerated(this.filePath);

  @override
  List<Object> get props => [filePath];
}

class OrderPdfError extends OrderPdfState {
  final String message;

  OrderPdfError(this.message);

  @override
  List<Object> get props => [message];
}
