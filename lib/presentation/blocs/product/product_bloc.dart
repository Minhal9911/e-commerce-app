import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:e_commerce_app/core/enums/product_sort.dart';
import 'package:e_commerce_app/core/errors/error_mapper.dart';
import 'package:e_commerce_app/core/utils/bloc_transformers.dart';
import 'package:e_commerce_app/data/models/product_model_res.dart';
import 'package:e_commerce_app/data/repositories/product_repository.dart';
import 'package:e_commerce_app/presentation/blocs/product/product_event.dart';
import 'package:e_commerce_app/presentation/blocs/product/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repo;
  int _skip = 0;
  // static const int _pageSize=10;

  ProductBloc(this.repo) : super(ProductInitial()) {
    on<FetchProducts>(_fetch);
    on<LoadMoreProducts>(_loadMore,transformer: droppable());
    on<SearchProducts>(_searchProducts,transformer: debounce(const Duration(milliseconds: 600)));
    on<FilterByCategory>(_filterByCategory);
    on<SortProducts> (_sortProducts);
    on<ApplyProductFilter>(_applyProductFilter);
      // transformer prevents multiple simultaneous load more calls (by using bloc_concurrency's droppable transformer)
      // concurrent - process events concurrently
      // sequential - process events sequentially
      // droppable - ignore any events added while an event is processing
      // restartable - process only the latest event and cancel previous event handlers

  }

  Future<void> _fetch(FetchProducts event, Emitter<ProductState> emit)async{
    //Reset skip on fresh fetch
    _skip=0;
    emit(ProductLoading());
    try{
      final products=await repo.getProducts(_skip);
      emit(ProductLoaded(products: products, allProducts: products,selectedCategory: 'All',searchQuery: ''));
    }catch(e){
      emit(ProductError(ErrorMapper.map(e)));
    }
  }

  Future<void> _loadMore(LoadMoreProducts event, Emitter<ProductState> emit)async{
    // Only load more when products are already loaded
    if(state is! ProductLoaded) return;
    final current= state as ProductLoaded;
    // Stop if already fetching or no more products to load
    if(current.hasReachedMax || current.isLoadingMore) return;
    emit(current.copyWith(isLoadingMore: true));
    _skip+=10;
    try{
      final newProducts=await repo.getProducts(_skip);
      //Add new products to allProducts-----------------------------------------
      final updatedAllProduct=[...current.allProducts, ...newProducts];
      //Create updated state with new  allProducts------------------------------
      final updated=current.copyWith(allProducts: updatedAllProduct,hasReachedMax: newProducts.isEmpty,isLoadingMore: false);
      //Apply existing filters on updated allProducts---------------------------
      _applyFilters(emit, updated);
    }catch(e){
      //Rollback skip if load more fails
      _skip-=10;
      emit(current.copyWith(isLoadingMore: false));
      //If pagination fails, we don't want to show a full page error, just a snackbar or something. So we emit the error state but UI can choose to ignore it if it's a load more failure
      emit(ProductError(ErrorMapper.map(e)));
    }

  }

///Searching--------------------------------------------------------------------
 Future<void> _searchProducts(SearchProducts event, Emitter<ProductState> emit)async{
    debugPrint('search function started');
    try{
      if(state is! ProductLoaded)return;

      final current=state as ProductLoaded;

      //Update search query in state
      final updated=current.copyWith(searchQuery: event.query);

      _applyFilters(emit, updated);

    }catch(e){
      emit(ProductError(ErrorMapper.map(e)));
    }
 }

///Filtering--------------------------------------------------------------------
  Future<void> _filterByCategory(FilterByCategory event, Emitter<ProductState> emit)async{
    try{
      if(state is! ProductLoaded)return;

      final current= state as ProductLoaded;

      final updated=current.copyWith(selectedCategory: event.category);

      _applyFilters(emit,updated);

    }catch(e){
      emit(ProductError(ErrorMapper.map(e)));
    }
  }

///Common function for search and filter ---------------------------------------
  void _applyFilters(Emitter<ProductState> emit,ProductLoaded current) {

    List<ProductModel> filtered = List.from(current.allProducts);

    // CATEGORY FILTER----------------------------------------------------------
    if (current.selectedCategory != 'All') {
      filtered = filtered.where((p) {
        return p.category == current.selectedCategory;
      }).toList();
    }

    // SEARCH FILTER------------------------------------------------------------
    final query = current.searchQuery.trim().toLowerCase();
    if(query.isNotEmpty){
      filtered= filtered.where((p){
        return p.title.toLowerCase().contains(query);
      }).toList();
    }

    //PRICE---------------------------------------------------------------------
    final minPrice =current.filter.minPrice;
    final maxPrice = current.filter.maxPrice;
    if(minPrice !=null){
      filtered = filtered.where((p){
        return p.price >= minPrice;
      }).toList();
    }
    if(maxPrice !=null){
      filtered = filtered = filtered.where((p){
        return p.price <= maxPrice;
      }).toList();
    }

    //RATING--------------------------------------------------------------------
    final minRating = current.filter.minRating;
    if(minRating !=null){
      filtered = filtered.where((p){
        return (p.rating??0) >= minRating;
      }).toList();
    }

    //STOCK---------------------------------------------------------------------
    if(current.filter.onlyInStock){
      filtered =filtered.where((p){
        return (p.stock??0) > 0;
      }).toList();
    }

    // SORTING------------------------------------------------------------------
    switch(current.sort){
      case ProductSort.none:
        break;
      case ProductSort.priceLowToHigh:
        filtered.sort((a,b)=> a.price.compareTo(b.price));
        break;
      case ProductSort.priceHighToLow:
        filtered.sort((a,b)=> b.price.compareTo(a.price));
        break;
      case ProductSort.nameAToZ:
        filtered.sort((a,b)=> a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case ProductSort.nameZToA:
        filtered.sort((a,b)=> b.title.toLowerCase().compareTo(a.title.toLowerCase()));
        break;
    }

    emit(current.copyWith(products: filtered),
    );
  }

///Sorting----------------------------------------------------------------------
  Future<void> _sortProducts(SortProducts event, Emitter<ProductState> emit)async{
    try{
      if(state is! ProductLoaded)return;

      final current = state as ProductLoaded;

      final updated = current.copyWith(sort: event.sort);

      _applyFilters(emit, updated);

    }catch(e){
      emit(ProductError(ErrorMapper.map(e)));
    }
  }

///Product Filter --------------------------------------------------------------
Future<void> _applyProductFilter(ApplyProductFilter event, Emitter<ProductState> emit)async{
    try{
      if(state is! ProductLoaded) return;

      final current =state as ProductLoaded;
      final updated = current.copyWith(filter: event.filter);

      _applyFilters(emit, updated);

    }catch(e){
      emit(ProductError(ErrorMapper.map(e)));
    }
}
}



///Without use of bloc_concurrency, if user scrolls fast and triggers multiple LoadMoreProducts events before the first one finishes, it can lead to multiple simultaneous API calls
/*
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repo;
  int _skip = 0;

  ProductBloc(this.repo) : super(const ProductInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<ProductState> emit,
  ) async {
    _skip = 0;
    emit(const ProductLoading());

    try {
      final products = await repo.getProducts(_skip);
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(e.toString()));
    }
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is! ProductLoaded) return;

    final current = state as ProductLoaded;

    // Guard — stop if already loading or reached end
    if (current.isLoadingMore || current.hasReachedMax) return;

    // Tell UI that loading more is in progress
    emit(current.copyWith(isLoadingMore: true));

    _skip += 10;

    try {
      final newProducts = await repo.getProducts(_skip);

      emit(current.copyWith(
        products: [...current.products, ...newProducts],
        hasReachedMax: newProducts.isEmpty,
        isLoadingMore: false,
      ));
    } catch (e) {
      _skip -= 10;
      emit(current.copyWith(isLoadingMore: false));
      emit(ProductError(e.toString()));
    }
  }
}
*/