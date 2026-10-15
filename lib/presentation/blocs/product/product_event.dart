import 'package:e_commerce_app/core/enums/product_sort.dart';
import 'package:e_commerce_app/data/models/product_filter_model.dart';
import 'package:equatable/equatable.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

final class FetchProducts extends ProductEvent {}

final class LoadMoreProducts extends ProductEvent{}

//Searching---------------------------------------------------------------------
final class SearchProducts extends ProductEvent{
  final String query;
  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

//Filtering---------------------------------------------------------------------
final class FilterByCategory extends ProductEvent{
  final String category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

//Sorting-----------------------------------------------------------------------
final class SortProducts extends ProductEvent{
  final ProductSort sort;

  const SortProducts(this.sort);

  @override
  List<Object?> get props => [sort];
}

//Product Filter ---------------------------------------------------------------
final class ApplyProductFilter extends ProductEvent{
  final ProductFilter filter;

  const ApplyProductFilter(this.filter);
  @override
  List<Object?> get props =>[filter];
}