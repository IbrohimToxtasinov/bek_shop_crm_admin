import 'package:bek_shop/data/repositories/storage_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'change_products_cost_state.dart';

class ChangeProductsCostCubit extends Cubit<ChangeProductsCostState> {
  ChangeProductsCostCubit() : super(ChangeProductsCostInitial()) {
    getProductsCost();
  }

  changeProductsCost({required bool productsExpensive}) async {
    emit(ChangeProductsCostLoading());
    try {
      await StorageRepository.putBool("products_expensive", productsExpensive);
      emit(ChangeProductsCostSuccess());
      getProductsCost();
    } catch (error) {
      emit(ChangeProductsCostFailure(errorMessage: error.toString()));
    }
  }

  getProductsCost() async {
    emit(GetProductsCostLoading());
    try {
      bool isExpensive = StorageRepository.getBool(
        "products_expensive",
        defValue: false,
      );
      emit(GetProductsCostSuccess(isExpensive: isExpensive));
    } catch (error) {
      emit(GetProductsCostFailure(errorMessage: error.toString()));
    }
  }
}
