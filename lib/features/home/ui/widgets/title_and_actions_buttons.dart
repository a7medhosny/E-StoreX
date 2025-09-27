import 'package:ecommerce/core/routing/routes.dart';
import 'package:ecommerce/features/basket/logic/cubit/basket_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TitleAndActionsButtons extends StatelessWidget {
  const TitleAndActionsButtons({super.key});

  @override
  Widget build(BuildContext context) {
    print("basketItems${context.watch<BasketCubit>().basketItems.length}");
    return Row(
      children: [
        Text(
          'E-StoreX',
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.search, size: 28.r),
          onPressed: () {
            Navigator.pushNamed(context, Routes.search);
          },
        ),
        SizedBox(width: 16.w),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(Routes.basketScreen);
          },
          icon: Badge(
            isLabelVisible: context.watch<BasketCubit>().basketItems.isNotEmpty,
            label: Text(
              context.watch<BasketCubit>().basketItems.length.toString(),
              style: TextStyle(fontSize: 8.sp),
            ),
            child: Icon(Icons.shopping_bag_outlined, size: 28.r),
          ),
        ),
      ],
    );
  }
}
