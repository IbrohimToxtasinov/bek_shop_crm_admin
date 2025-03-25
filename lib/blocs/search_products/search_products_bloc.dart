import 'package:bek_shop/data/models/product/product_model.dart';
import 'package:bek_shop/data/repositories/product_repository.dart';
import 'package:bloc/bloc.dart';

part 'search_products_event.dart';

part 'search_products_state.dart';

class SearchProductsBloc extends Bloc<SearchProductsEvent, SearchProductsState> {
  final ProductRepository _productRepository;

  SearchProductsBloc(this._productRepository) : super(SearchProductsInitial()) {
    on<SearchProducts>(_searchBrandsProduct);
    on<GlobalSearchProducts>(_globalSearchBrandsProduct);
  }

  Future<void> _searchBrandsProduct(SearchProducts event, Emitter<SearchProductsState> emit) async {
    emit(SearchProductsLoading());
    try {
      await for (var products in _productRepository.searchProductsByCategoryIdAndName(
        categoryId: event.categoryId,
        query: event.productName,
      )) {
        emit(SearchProductsSuccess(products: products));
      }
    } catch (error) {
      emit(SearchProductsFailure(errorText: error.toString()));
    }
  }

  Future<void> _globalSearchBrandsProduct(
    GlobalSearchProducts event,
    Emitter<SearchProductsState> emit,
  ) async {
    emit(GlobalSearchProductsLoading());
    try {
      await for (var products in _productRepository.globalSearchProductsByCategoryIdAndName(
        query: event.productName,
      )) {
        emit(GlobalSearchProductsSuccess(products: products));
      }
    } catch (error) {
      emit(GlobalSearchProductsFailure(errorText: error.toString()));
    }
  }
}
