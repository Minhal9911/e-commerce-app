import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/core/enums/product_sort.dart';
import 'package:e_commerce_app/presentation/blocs/product/product_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/product/product_event.dart';
import 'package:e_commerce_app/presentation/blocs/product/product_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductSortBottomSheet extends StatelessWidget {
  const ProductSortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProductBloc>().state;
    if (state is! ProductLoaded) {
      return const SizedBox.shrink();
    }
    final selectedSort = state.sort;

    return RadioGroup<ProductSort>(
      groupValue: selectedSort,
      onChanged: (value) {
        if (value == null) return;
        context.read<ProductBloc>().add(SortProducts(value));
        Navigator.pop(context);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: StaticSizes.size8),
            child: Text(
              'Sort Products',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: StaticSizes.fontSize18,
              ),
            ),
          ),
          _SortOption(title: 'Default',value: ProductSort.none,),
          _SortOption(title: 'Price: Low to High',value: ProductSort.priceLowToHigh),
          _SortOption(title: 'Price: High to Low',value: ProductSort.priceHighToLow),
          _SortOption(title: 'Name: A to Z',value: ProductSort.nameAToZ),
          _SortOption(title: 'Name: Z to A',value: ProductSort.nameZToA),
        ],
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  final String title;
  final ProductSort value;

  const _SortOption({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<ProductSort>(title: Text(title),value: value);
  }
}
