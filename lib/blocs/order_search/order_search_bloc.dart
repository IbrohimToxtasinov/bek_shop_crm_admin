import 'package:bek_shop/data/models/order/order_model.dart';
import 'package:bek_shop/data/repositories/order_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'order_search_event.dart';

part 'order_search_state.dart';

class OrderSearchBloc extends Bloc<OrderSearchEvent, OrderSearchState> {
  OrderSearchBloc(this._orderRepository) : super(SearchOrdersInitial()) {
    on<SearchOrders>(_searchOrders);
  }

  final OrderRepository _orderRepository;

  Future<void> _searchOrders(SearchOrders event, Emitter<OrderSearchState> emit) async {
    emit(SearchOrdersLoading());
    try {
      await for (var orders in _orderRepository.searchOrdersByClientName(query: event.clientName)) {
        emit(SearchOrdersSuccess(orders: orders));
      }
    } catch (error) {
      emit(SearchOrdersFailure(errorText: error.toString()));
    }
  }
}
