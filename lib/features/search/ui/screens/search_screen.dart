import 'dart:async';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/logic/cubit/home_cubit.dart';
import 'package:ecommerce/features/home/ui/widgets/product_item.dart';
import 'package:ecommerce/features/home/ui/widgets/search_field.dart';
import 'package:ecommerce/features/search/logic/cubit/search_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Timer? _debounce;

  @override
  void initState() {
    context.read<SearchCubit>().getInitialState();
    super.initState();
  }

  void _onSearchChanged(String query) {
    print("Search query: $query");

    if (query.isEmpty) {
      print("Search query is empty, resetting state");
      context.read<SearchCubit>().getInitialState();
      return;
    }
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      context.read<SearchCubit>().searchProducts(query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.0.r),
          child: Column(
            children: [
              SearchField(onChanged: _onSearchChanged),
              SizedBox(height: 16.h),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state is HomeSearchResultsLoaded) {
                      return _buildSearchResults(state.products);
                    } else if (state is HomeSearchLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is HomeSearchError) {
                      return SizedBox.shrink();
                    }
                    return const SizedBox(); // أو Loader/Empty view
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<ProductModel> products) {
    if (products.isEmpty) {
      return const Center(child: Text('No products found.'));
    }

    return GridView.builder(
      itemCount: products.length,
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 0.52,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductItem(product: product);
      },
    );
  }
}
