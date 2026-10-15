import 'package:e_commerce_app/core/constants/static_sizes.dart';
import 'package:e_commerce_app/presentation/blocs/product/product_bloc.dart';
import 'package:e_commerce_app/presentation/blocs/product/product_event.dart';
import 'package:e_commerce_app/presentation/blocs/product/product_state.dart';
import 'package:e_commerce_app/presentation/screens/home/widgets/product_filter_bottom_sheet.dart';
import 'package:e_commerce_app/presentation/screens/home/widgets/product_sort_bottom_sheet.dart';
import 'package:e_commerce_app/presentation/widgets/custom_bottom_sheet.dart';
import 'package:e_commerce_app/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;
  late final FocusNode _focusNode = FocusNode();
  final _showClear = ValueNotifier<bool>(false); //Lightweight notifier
  //Value Notifier is a box that holds a value and notifies listeners when it changes.

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    // context.read<ProductBloc>().add(FetchProducts());
    // We can also fetch products here, but we will do it in the parent widget (HomeScreen) to avoid fetching products again when we switch tabs.
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 100) {
      final state = context.read<ProductBloc>().state;
      if (state is ProductLoaded &&
          !state.isLoadingMore &&
          !state.hasReachedMax) {
        context.read<ProductBloc>().add(LoadMoreProducts());
      }
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    _focusNode.dispose();
    _showClear.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('HomeTab rebuild');
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (BuildContext context, state) {
        return switch (state) {
          ProductInitial() => const SizedBox(),
          ProductLoading() => const _ShimmerGrid(),
          ProductError() => _buildError(state),
          ProductLoaded() => _buildGrid(state),
        };
      },
    );
  }

  Widget _buildGrid(ProductLoaded state) {
    return Column(
      children: [
        ///SEARCH BAR-----------------------------------------------------------
        SearchBar(
          searchController: _searchController,
          focusNode: _focusNode,
          showClear: _showClear,
        ),

        ///CATEGORY FILTER----------------------------------------------------
        CategoryFilterBar(
          categories: ['All', 'beauty', 'fragrances', 'furniture', 'groceries'],
        ),

        ///SORTING DROPDOWN-----------------------------------------------------
        _ProductActionBar(state: state,),

        ///EMPTY SEARCH RESULT--------------------------------------------------
        if (state.products.isEmpty)
          Expanded(child: _EmptySearchView())
        else
          ///PRODUCT GRID---------------------------------------------------------
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.only(
                left: StaticSizes.size16,
                right: StaticSizes.size16,
                top: StaticSizes.size10,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: StaticSizes.size16,
                crossAxisSpacing: StaticSizes.size16,
                childAspectRatio: 0.7,
              ),
              // +1 for bottom loader item
              itemCount: state.products.length + 1,
              itemBuilder: (_, index) {
                // Last item — loader or end message
                if (index == state.products.length) {
                  return state.hasReachedMax
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(StaticSizes.size16),
                            child: Text("No more products"),
                          ),
                        )
                      : state.isLoadingMore
                      ? const _PaginationShimmerCard()
                      : const SizedBox.shrink();
                }

                return ProductCard(state.products[index]);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildError(ProductError state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(state.message),
          SizedBox(height: StaticSizes.size16),
          ElevatedButton(
            onPressed: () => context.read<ProductBloc>().add(FetchProducts()),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final FocusNode focusNode;
  final ValueNotifier<bool> showClear;

  const SearchBar({
    super.key,
    required this.searchController,
    required this.focusNode,
    required this.showClear,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        StaticSizes.size16,
        StaticSizes.size40,
        StaticSizes.size16,
        StaticSizes.size1,
      ),
      child: TextField(
        controller: searchController,
        focusNode: focusNode,
        onTapUpOutside: (_) => FocusManager.instance.primaryFocus!.unfocus(),
        onChanged: (value) {
          showClear.value = value.isNotEmpty;
          context.read<ProductBloc>().add(SearchProducts(value));
        },
        decoration: InputDecoration(
          hintText: 'Search products....',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.symmetric(vertical: StaticSizes.size14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(StaticSizes.borderRadius15),
            borderSide: BorderSide.none,
          ),
          suffixIcon: ValueListenableBuilder(
            valueListenable: showClear,
            builder: (context, showClearValue, _) {
              return showClearValue
                  ? IconButton(
                      onPressed: () {
                        searchController.clear();
                        showClear.value = false;
                        FocusScope.of(context).unfocus();
                        context.read<ProductBloc>().add(
                          const SearchProducts(''),
                        );
                      },
                      icon: const Icon(Icons.close, color: Colors.grey),
                    )
                  : const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class CategoryFilterBar extends StatelessWidget {
  final List<String> categories;

  const CategoryFilterBar({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is! ProductLoaded) {
          return const SizedBox();
        }

        return SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, index) {
              final category = categories[index];
              final isSelected = state.selectedCategory == category;
              return ChoiceChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (_) {
                  context.read<ProductBloc>().add(FilterByCategory(category));
                },
              );
            },
          ),
        );
      },
    );
  }
}

//Shimmer Effect for loading state - simple grey boxes with shimmer animation. You can customize it to match your product card design more closely.
class _ShimmerGrid extends StatelessWidget {
  const _ShimmerGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(
        left: StaticSizes.size16,
        right: StaticSizes.size16,
        top: StaticSizes.size32,
      ),
      itemCount: 6, // skeleton count
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: StaticSizes.size16,
        crossAxisSpacing: StaticSizes.size16,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (_, index) {
        return _ShimmerCard(index);
      },
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final int index;

  const _ShimmerCard(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(StaticSizes.borderRadius12),
            color: Colors.grey.shade300,
          ),
          child: Column(
            children: [
              // Image placeholder
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      StaticSizes.borderRadius12,
                    ),
                    color: Colors.grey.shade300,
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(StaticSizes.size8),
                child: Column(
                  children: [
                    Container(
                      height: 12,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: StaticSizes.size4),
                    Container(
                      height: 12,
                      width: 80,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        // 🔥 shimmer effect
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1200.ms, color: Colors.white.withValues(alpha: 0.6));
  }
}

//Pagination loader - a simple card with shimmer effect, shown at the bottom of the grid when loading more products.
class _PaginationShimmerCard extends StatelessWidget {
  const _PaginationShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(StaticSizes.borderRadius12),
            color: Colors.grey.shade300,
          ),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      StaticSizes.borderRadius12,
                    ),
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(StaticSizes.size8),
                child: Column(
                  children: [
                    Container(
                      height: 12,
                      width: double.infinity,
                      color: Colors.grey.shade300,
                    ),
                    SizedBox(height: StaticSizes.size4),
                    Container(
                      height: 12,
                      width: 80,
                      color: Colors.grey.shade300,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration: 1200.ms, color: Colors.white.withValues(alpha: 0.6));
  }
}

class _EmptySearchView extends StatelessWidget {
  const _EmptySearchView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Icon(Icons.search_off, size: 100, color: Colors.grey.shade400),

          SizedBox(height: StaticSizes.size16),

          Text(
            "No products found",

            style: TextStyle(
              fontSize: StaticSizes.fontSize18,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: StaticSizes.size8),

          Text(
            "Try searching something else",

            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}

class _ProductActionBar extends StatelessWidget {
  final ProductLoaded state;
  const _ProductActionBar({required this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: StaticSizes.size16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton.icon(
            onPressed: (){
          AppBottomSheet.show(context,
              child: BlocProvider.value(
                value: context.read<ProductBloc>(),
                child:const  ProductFilterBottomSheet(),));
        },
              label: Text(state.filter.hasActiveFilters
                  ?'Filter (${state.filter.activeCount})':'Filter'),
            icon:const  Icon(Icons.filter_list),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(StaticSizes.borderRadius12),
              ),
            ),),
          OutlinedButton.icon(
            onPressed: () {
              AppBottomSheet.show(
                context,
                child: BlocProvider.value(
                  value: context.read<ProductBloc>(),
                  child: const ProductSortBottomSheet(),
                ),
              );
            },
            icon: const Icon(Icons.sort),
            label: const Text('Sort'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(StaticSizes.borderRadius12),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
