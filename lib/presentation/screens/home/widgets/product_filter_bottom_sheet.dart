import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/data/models/product_filter_model.dart';
import 'package:e_commerce_app/data/models/product_model_res.dart';
import 'package:e_commerce_app/presentation/blocs/product/product_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/product/product_event.dart';
import 'package:e_commerce_app/presentation/blocs/product/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductFilterBottomSheet extends StatefulWidget {
  const ProductFilterBottomSheet({super.key});

  @override
  State<ProductFilterBottomSheet> createState() =>
      _ProductFilterBottomSheetState();
}

class _ProductFilterBottomSheetState extends State<ProductFilterBottomSheet> {
  late double _availableMaxPrice;
  late final ValueNotifier<RangeValues> _priceRangeNotifier;
  late final ValueNotifier<double?> _minRatingNotifier;
  late final ValueNotifier<bool> _onlyInStockNotifier;


  @override
  void initState() {
    super.initState();
    final state = context.read<ProductBloc>().state;

    if (state is ProductLoaded) {
      _availableMaxPrice = _getMaxPrice(state.allProducts);
      final filter = state.filter;

      final minPrice = (filter.minPrice ?? 0).clamp(0, _availableMaxPrice);
      final maxPrice = (filter.maxPrice ?? _availableMaxPrice).clamp(minPrice,_availableMaxPrice);
      _priceRangeNotifier = ValueNotifier(RangeValues(minPrice.toDouble(), maxPrice.toDouble()));
      _minRatingNotifier = ValueNotifier(filter.minRating);
      _onlyInStockNotifier = ValueNotifier(filter.onlyInStock);
    } else {
      _availableMaxPrice = 1;
      _priceRangeNotifier = ValueNotifier(const RangeValues(0, 1));
      _minRatingNotifier = ValueNotifier(null);
      _onlyInStockNotifier = ValueNotifier(false);
    }
  }

  double _getMaxPrice(List<ProductModel> products) {
    if (products.isEmpty) return 1;
    var maxPrice = 0.0;
    for (final p in products) {
      if (p.price > maxPrice) maxPrice = p.price;
    }
    return maxPrice <= 0 ? 1 : maxPrice;
  }

  void _resetFilter() {
    setState(() {
      _priceRangeNotifier.value = RangeValues(0, _availableMaxPrice);
      _minRatingNotifier.value = null;
      _onlyInStockNotifier.value = false;
    });
  }

  void _applyFilters() {
    final priceRange = _priceRangeNotifier.value;
    final minPrice = priceRange.start == 0 ? null : priceRange.start;
    final maxPrice = (priceRange.end - _availableMaxPrice).abs() < 0.01
        ? null : priceRange.end;
    context.read<ProductBloc>().add(
      ApplyProductFilter(
        ProductFilter(
          minPrice: minPrice,
          maxPrice: maxPrice,
          minRating: _minRatingNotifier.value,
          onlyInStock: _onlyInStockNotifier.value,
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _priceRangeNotifier.dispose();
    _minRatingNotifier.dispose();
    _onlyInStockNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: StaticSizes.size16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: StaticSizes.size8),
            child: Text(
              'Filter Products',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            'Price Range',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: StaticSizes.size8),
          ValueListenableBuilder<RangeValues>(
              valueListenable: _priceRangeNotifier,
              builder: (context, priceRange, _){
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('₹${priceRange.start.toStringAsFixed(0)}'),
                    Text('₹${priceRange.end.toStringAsFixed(0)}'),
                  ],
                ),
                RangeSlider(
                  min: 0,
                  max: _availableMaxPrice,
                  divisions: _availableMaxPrice >=1 ? _availableMaxPrice.round():null,
                  values: priceRange,
                  onChanged: (value) => _priceRangeNotifier.value =value,
                ),
              ],
            );
          }),
          SizedBox(height: StaticSizes.size12),
          Text('Minimum Rating',style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ValueListenableBuilder<double?>(
            valueListenable: _minRatingNotifier,
            builder: (context, minRating, _) {
              return RadioGroup<double?>(
                groupValue: minRating,
                onChanged: (value)=> _minRatingNotifier.value = value,
                child: Column(
                  children: [
                    RadioListTile<double?>(contentPadding: EdgeInsets.zero, title: Text('Any Rating'), value: null),
                    RadioListTile<double?>(contentPadding: EdgeInsets.zero, title: Text('4★ & above'), value: 4.0),
                    RadioListTile<double?>(contentPadding: EdgeInsets.zero, title: Text('3★ & above'), value: 3.0),
                    RadioListTile<double?>(contentPadding: EdgeInsets.zero, title: Text('2★ & above'), value: 2.0),
                  ],
                ),
              );
            }
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _onlyInStockNotifier,
            builder: (context, onlyInStock, _) {
              return SwitchListTile(
                contentPadding: EdgeInsets.zero,
                  value: onlyInStock,
                  onChanged: (value)=> _onlyInStockNotifier.value=value , title: Text('In Stock Only'));
            }
          ),
          SizedBox(height: StaticSizes.size16),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: _resetFilter, child: Text('Reset'))),
              SizedBox(width: StaticSizes.size12),
              Expanded(child: ElevatedButton(onPressed: _applyFilters, child: Text('Apply')))
            ],
          ),
          SizedBox(height: StaticSizes.size16),
        ],
      ),
    );
  }
}
