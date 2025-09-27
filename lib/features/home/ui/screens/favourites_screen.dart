import 'package:ecommerce/core/helpers/spacing.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/core/routing/routes.dart';
import 'package:ecommerce/features/home/logic/cubit/home_cubit.dart';
import 'package:ecommerce/features/home/ui/widgets/product_item.dart';
import 'package:ecommerce/features/home/ui/widgets/title_and_actions_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key, required this.scrollController});
  final ScrollController scrollController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Favourites',
      //     style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      //   elevation: 0,
      // ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            const TitleAndActionsButtons(),
            verticalSpace(16),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                final cubit = context.read<HomeCubit>();
                final favourites = cubit.favoriteProducts; // List<ProductModel>

                if (favourites.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 80.sp,
                          color: Colors.grey.shade400,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'No favourites yet!',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'Start adding products to your wishlist',
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        if (TokenManager.token == null ||
                            TokenManager.token!.isEmpty) ...[
                          SizedBox(height: 20.h),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                Routes.loginRegisterTabSwitcher,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 12.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              "Login to continue",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    itemCount: favourites.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 0.52, // نسبة الكارد
                    ),
                    itemBuilder: (context, index) {
                      final product = favourites[index];
                      return ProductItem(product: product);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
