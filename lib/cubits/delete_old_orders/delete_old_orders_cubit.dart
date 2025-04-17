import 'package:bek_shop/data/repositories/order_repository.dart';
import 'package:bloc/bloc.dart';

part 'delete_old_orders_state.dart';

class DeleteOldOrdersCubit extends Cubit<DeleteOldOrdersState> {
  DeleteOldOrdersCubit(this._orderRepository) : super(DeleteOldOrdersInitial());

  final OrderRepository _orderRepository;

  deleteOldOrders() async {
    emit(DeleteOldOrdersLoadInProgress());
    try {
      await _orderRepository.deleteOldOrders();
      emit(DeleteOldOrdersLoadInSuccess());
      await Future.delayed(Duration(seconds: 2));
      emit(DeleteOldOrdersInitial());
    } catch (error) {
      emit(DeleteOldOrdersLoadInFailure(errorText: error.toString()));
    }
  }
}
