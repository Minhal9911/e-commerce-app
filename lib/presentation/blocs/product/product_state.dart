import 'package:e_commerce_app/core/enums/product_sort.dart';
import 'package:e_commerce_app/data/models/product_filter_model.dart';
import 'package:e_commerce_app/data/models/product_model_res.dart';
import 'package:equatable/equatable.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

final class ProductInitial extends ProductState {
  const ProductInitial();
}

final class ProductLoading extends ProductState {
  const ProductLoading();
}

final class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  //Original Products
  final List<ProductModel> allProducts;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String selectedCategory;
  final String searchQuery;
  final ProductSort sort;
  final ProductFilter filter;


  const ProductLoaded({
    required this.products,
    required this.allProducts,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.selectedCategory = 'All',
    this.searchQuery='',
    this.sort = ProductSort.none,
    this.filter = const ProductFilter.empty(),
  });

  // Used to update state without creating a new object from scratch
  ProductLoaded copyWith({
    List<ProductModel>? products,
    List<ProductModel>? allProducts,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? selectedCategory,
    String? searchQuery,
    ProductSort? sort,
    ProductFilter? filter,

  }) {
    return ProductLoaded(
      products: products ?? this.products,
      allProducts: allProducts ?? this.allProducts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      sort: sort ?? this.sort,
      filter: filter ?? this.filter,
    );
  }


  @override
  List<Object?> get props => [products,allProducts,isLoadingMore,hasReachedMax,selectedCategory,searchQuery,sort,filter];
}

final class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object?> get props => [message];
}

///Without use of bloc_concurrency, if user scrolls fast and triggers multiple LoadMoreProducts events before the first one finishes, it can lead to multiple simultaneous API calls
