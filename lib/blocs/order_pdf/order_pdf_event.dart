part of 'order_pdf_bloc.dart';

abstract class OrderPdfEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GenerateAndSharePdfEvent extends OrderPdfEvent {
  final OrderModel order;
  final bool share;

  GenerateAndSharePdfEvent({required this.order, required this.share});

  @override
  List<Object> get props => [order, share];
}
