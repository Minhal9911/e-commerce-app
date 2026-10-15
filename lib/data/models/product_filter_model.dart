
import 'package:equatable/equatable.dart';

class ProductFilter extends Equatable{
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool onlyInStock;

  const ProductFilter({
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.onlyInStock = false,
  });
  bool get hasActiveFilters => minPrice !=null || maxPrice !=null || minRating !=null || onlyInStock;

  int get activeCount{
    var count=0;
    if(minPrice !=null || maxPrice !=null){
      count++;
    }
    if(minRating != null ){
      count++;
    }
    if(onlyInStock){
      count++;
    }
    return count;
  }

  const ProductFilter.empty(): minPrice=null,maxPrice=null,minRating=null,onlyInStock=false;

  ProductFilter copyWith({
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? onlyInStock,
    bool clearPrice =false,
    bool clearRating = false,
  }){
    return ProductFilter(
      minPrice:clearPrice ? null: minPrice ?? this.minPrice,
      maxPrice:clearPrice?null: maxPrice ?? this.maxPrice,
      minRating: clearRating? null : minRating ?? this.minRating,
      onlyInStock: onlyInStock ?? this.onlyInStock,
    );
}

  @override
  List<Object?> get props => [minPrice, maxPrice, minRating, onlyInStock];
}