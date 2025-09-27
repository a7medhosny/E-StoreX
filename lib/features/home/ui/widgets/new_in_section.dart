import 'package:ecommerce/core/routing/routes.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/logic/cubit/home_cubit.dart';
import 'package:ecommerce/features/home/ui/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewInSection extends StatefulWidget {
  const NewInSection({super.key, required this.products});
  final List<ProductModel> products;
  @override
  State<NewInSection> createState() => _NewInSectionState();
}

class _NewInSectionState extends State<NewInSection> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          SizedBox(height: 16.h),
          _buildProductList(),
          SizedBox(height: 16.h),
          _buildViewAllProductsButton(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Arrivals',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(
          'Latest products across electronics, home, fashion & more',
          style: TextStyle(fontSize: 16.sp, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildProductList() {
    return SizedBox(
      height: 310.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.products.length,
        itemBuilder:
            (context, index) => ProductItem(product: widget.products[index]),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(width: 12.w);
        },
      ),
    );
  }

  Widget _buildViewAllProductsButton() {
    return SizedBox(
      height: 50.h,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          // context.read<HomeCubit>().getFilteredProducts(
          //   filters: {"PageNumber": 1, "PageSize": 10},
          // );
          Navigator.pushNamed(
            context,
            Routes.viewAllProducts,
            arguments: widget.products,
          );
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          'View All Products',
          style: TextStyle(fontSize: 16.sp, color: Colors.black),
        ),
      ),
    );
  }
}
