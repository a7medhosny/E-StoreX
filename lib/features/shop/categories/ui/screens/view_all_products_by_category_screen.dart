import 'package:ecommerce/core/helpers/spacing.dart';
import 'package:ecommerce/core/routing/routes.dart';
import 'package:ecommerce/features/shop/categories/logic/cubit/category_cubit.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/ui/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ViewAllProductsByCategoryScreen extends StatefulWidget {
  const ViewAllProductsByCategoryScreen({super.key});

  @override
  State<ViewAllProductsByCategoryScreen> createState() =>
      _ViewAllProductsScreenState();
}

class _ViewAllProductsScreenState
    extends State<ViewAllProductsByCategoryScreen> {
  List<ProductModel> _products = [];
  int _currentPage = 1;
  int _totalCount = 0;
  final int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    // context.read<CategoryCubit>().getProductByCategoryId(
    //       categoryId: widget.categoryId,
    //       pageNumber: _currentPage,
    //       pageSize: _pageSize,
    //     );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Products'), centerTitle: true),
      body: BlocConsumer<CategoryCubit, CategoryState>(
        listener: (context, state) {
          print("All Products State: $state");
          if (state is CategoryProductLoaded) {
            setState(() {
              _products = state.product.data;
              _totalCount = state.product.totalCount;
              _currentPage = state.product.pageNumber;
            });
          }
        },
        builder: (context, state) {
          if (state is CategoryProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }
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
                            '$_totalCount items',
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
                      /// زرار Back
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed:
                            _currentPage > 1
                                ? () {
                                  setState(() {
                                    _currentPage--;
                                  });
                                  context
                                      .read<CategoryCubit>()
                                      .getProductByCategoryId(
                                        categoryName:
                                            _products.first.categoryName ?? '',
                                        pageNumber: _currentPage,
                                        pageSize: _pageSize,
                                      );
                                }
                                : null,
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

                      /// زرار Next
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed:
                            (_currentPage * _pageSize) < _totalCount
                                ? () {
                                  setState(() {
                                    _currentPage++;
                                  });
                                  context
                                      .read<CategoryCubit>()
                                      .getProductByCategoryId(
                                        categoryName:
                                            _products.first.categoryName ?? '',
                                        pageNumber: _currentPage,
                                        pageSize: _pageSize,
                                      );
                                }
                                : null,
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
