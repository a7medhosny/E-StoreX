import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../logic/cubit/basket_cubit.dart';
import '../../data/models/basket_item_model.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widgets/product_image .dart';

class BasketItemCard extends StatelessWidget {
  final BasketItemModel basketItem;
  final String basketId;
  final void Function() onRemove;

  const BasketItemCard({
    super.key,
    required this.basketItem,
    required this.basketId,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    String initialQty = basketItem.qunatity.toString();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// صورة المنتج
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: SizedBox(
                width: 80.w, // صغرت العرض
                height: 80.w, // خليتها مربعة
                child: ProductImage(imageUrl: basketItem.image ?? ""),
              ),
            ),

            horizontalSpace(10.w),

            /// تفاصيل المنتج
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// اسم المنتج
                  Text(
                    basketItem.name ?? '',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  verticalSpace(6.h),

                  /// السعر
                  Text(
                    'Price: \$${basketItem.price!.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey[700]),
                  ),

                  verticalSpace(6.h),

                  /// الكمية
                  Row(
                    children: [
                      Text(
                        'Qty:',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      horizontalSpace(8.w),
                      Flexible(
                        child: Container(
                          height: 32.h,
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                visualDensity: VisualDensity.compact,
                                iconSize: 18.sp,
                                onPressed: () {
                                  context
                                      .read<BasketCubit>()
                                      .updateItemQuantity(
                                        basketId: basketId,
                                        productId: basketItem.id ?? '',
                                        increase: false,
                                      );
                                },
                                icon: Icon(Icons.remove, size: 18.sp),
                              ),
                              Text(
                                initialQty,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                visualDensity: VisualDensity.compact,
                                iconSize: 18.sp,
                                onPressed: () {
                                  context
                                      .read<BasketCubit>()
                                      .updateItemQuantity(
                                        basketId: basketId,
                                        productId: basketItem.id ?? '',
                                        increase: true,
                                      );
                                },
                                icon: Icon(Icons.add, size: 18.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            horizontalSpace(8.w),

            /// زرار الحذف
            IconButton(
              onPressed: onRemove,
              iconSize: 22.sp,
              constraints: const BoxConstraints(),
              icon: Icon(Icons.delete, color: Colors.red, size: 22.sp),
            ),
          ],
        ),
      ),
    );
  }
}
