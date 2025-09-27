import 'package:ecommerce/core/helpers/image_url.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/core/routing/routes.dart';
import 'package:ecommerce/core/widgets/product_image%20.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/logic/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, Routes.productDetails, arguments: product);
      },
      child: Container(
        width: 160.w,
        margin: EdgeInsets.only(right: 12.w, bottom: 10.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,

          children: [
            /// ---------- Image + Fav Button ----------
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    topRight: Radius.circular(12.r),
                  ),
                  child: SizedBox(
                    height: 160.h,
                    width: double.infinity,
                    child:
                        (product.photos != null && product.photos!.isNotEmpty)
                            ? ProductImage(
                              imageUrl: ImageUrl.getValidUrl(
                                product.photos!.first.imageName,
                              ),
                            )
                            : Icon(
                              Icons.broken_image_rounded,
                              size: 60.sp,
                              color: Colors.grey,
                            ),
                  ),
                ),

                /// Favourite Button
                Positioned(
                  right: 6.w,
                  top: 6.h,
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundColor: Colors.white.withOpacity(0.8),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        context.watch<HomeCubit>().isFavorite(product.id ?? '')
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 18.sp,
                        color:
                            context.watch<HomeCubit>().isFavorite(
                                  product.id ?? '',
                                )
                                ? Colors.red
                                : Colors.grey,
                      ),
                      onPressed: () {
                        if (TokenManager.token != null &&
                            TokenManager.token!.isNotEmpty) {
                          /// في حالة فيه توكين
                          context.read<HomeCubit>().toggleFavorite(product);
                        } else {
                          /// مفيش توكين → يروح على شاشة تسجيل الدخول
                          Navigator.pushNamed(
                            context,
                            Routes.loginRegisterTabSwitcher,
                          );
                        }
                      },
                    ),
                  ),
                ),

                // /// Hot Pick Tag
                // Positioned(
                //   left: 8.w,
                //   top: 8.h,
                //   child: Container(
                //     padding: EdgeInsets.symmetric(
                //       horizontal: 8.w,
                //       vertical: 2.h,
                //     ),
                //     decoration: BoxDecoration(
                //       color: Colors.deepPurple,
                //       borderRadius: BorderRadius.circular(20.r),
                //     ),
                //     child: Text(
                //       "Hot Pick",
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 10.sp,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),

            /// ---------- Info ----------
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    product.description ?? '',
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),

                  /// Price Section
                  Row(
                    children: [
                      Text(
                        "\$${product.newPrice}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple,
                        ),
                      ),
                      if (product.oldPrice != null &&
                          product.oldPrice != product.newPrice) ...[
                        SizedBox(width: 6.w),
                        Text(
                          "\$${product.oldPrice}",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
