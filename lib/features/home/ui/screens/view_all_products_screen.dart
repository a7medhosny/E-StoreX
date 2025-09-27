import 'package:ecommerce/core/helpers/spacing.dart';
import 'package:ecommerce/core/routing/routes.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/logic/cubit/home_cubit.dart';
import 'package:ecommerce/features/home/ui/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAllProductsScreen extends StatefulWidget {
  const ViewAllProductsScreen({super.key});

  @override
  State<ViewAllProductsScreen> createState() => _ViewAllProductsScreenState();
}

class _ViewAllProductsScreenState extends State<ViewAllProductsScreen> {
  List<ProductModel> _products = [];
  int _currentPage = 1;
  int _totalCount = 0;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    // _products = widget.products;
    context.read<HomeCubit>().getFilteredProducts(
      filters: {"PageNumber": 1, "PageSize": 10},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Products'), centerTitle: true),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          print("All Products State: $state");
          print(
            "(_currentPage * _pageSize) < _totalCount : ${(_currentPage * _pageSize) < _totalCount}",
          );
          if (state is HomeProductsLoaded) {
            setState(() {
              _products = state.productsResponse.data;
              _totalCount = state.productsResponse.totalCount;
              _currentPage = state.productsResponse.pageNumber;
            });
          }
        },
        builder: (context, state) {
          if (state is HomeProductsLoading)
            return const Center(child: CircularProgressIndicator());
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.all(16.w),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '${_totalCount} items',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.pushNamed(context, Routes.filterScreen);
                          //   },
                          //   child: Container(
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(8),
                          //       border: Border.all(color: Colors.black),
                          //     ),
                          //     padding: const EdgeInsets.symmetric(
                          //       horizontal: 12,
                          //       vertical: 8,
                          //     ),
                          //     child: const Row(
                          //       children: [
                          //         Icon(Icons.sort, size: 20),
                          //         SizedBox(width: 8),
                          //         Text("Refine"),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      verticalSpace(16.h),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.52,
                  ),
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    final product = _products[index];
                    return ProductItem(product: product);
                  }, childCount: _products.length),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed:
                            _currentPage > 1
                                ? () {
                                  setState(() {
                                    _currentPage--;
                                  });
                                  context.read<HomeCubit>().getFilteredProducts(
                                    filters: {
                                      "PageNumber": _currentPage,
                                      "PageSize": _pageSize,
                                    },
                                  );
                                }
                                : null, // disabled لو أول صفحة
                      ),
                      SizedBox(width: 16.w),
                      Text(
                        "Page $_currentPage",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      // زرار Next
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed:
                            (_currentPage * _pageSize) < _totalCount
                                ? () {
                                  setState(() {
                                    _currentPage++;
                                  });
                                  context.read<HomeCubit>().getFilteredProducts(
                                    filters: {
                                      "PageNumber": _currentPage,
                                      "PageSize": _pageSize,
                                    },
                                  );
                                }
                                : null, // disabled لو وصلنا آخر صفحة
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
