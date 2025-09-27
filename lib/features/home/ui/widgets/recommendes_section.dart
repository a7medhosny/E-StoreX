import 'package:ecommerce/core/helpers/spacing.dart';
import 'package:ecommerce/features/home/logic/cubit/home_cubit.dart';
import 'package:ecommerce/features/home/ui/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecommendedSection extends StatelessWidget {
  final String categoryName;
  final String ProductId;

  const RecommendedSection({
    super.key,
    required this.categoryName,
    required this.ProductId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen:
          (previous, current) =>
              current is RecommendedProductsLoading ||
              current is RecommendedProductsLoaded ||
              current is RecommendedProductsError,
      builder: (context, state) {
        if (state is RecommendedProductsLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is RecommendedProductsError) {
          return SizedBox(
            height: 200,
            child: Center(child: Text(state.message)),
          );
        } else if (state is RecommendedProductsLoaded) {
          final products = state.products;

          if (products.isEmpty) {
            return const SizedBox(
              height: 200,
              child: Center(child: Text("No recommendations")),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "You may also like",
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
              ),
              verticalSpace(12),
              SizedBox(
                height: 310.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  separatorBuilder: (_, __) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return product.id == ProductId
                        ? SizedBox()
                        : AnimatedOpacity(
                          opacity: 1,
                          duration: Duration(milliseconds: 300 + (index * 100)),
                          child: ProductItem(product: product),
                        );
                  },
                ),
              ),
              SizedBox(height: 16.h),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
