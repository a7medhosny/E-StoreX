import 'package:ecommerce/core/helpers/image_url.dart';
import 'package:ecommerce/core/routing/routes.dart';
import 'package:ecommerce/features/shop/brands/logic/cubit/brand_cubit.dart';
import 'package:ecommerce/features/shop/categories/logic/cubit/category_cubit.dart';
import 'package:ecommerce/features/shop/categories/data/models/category_model.dart';
import 'package:ecommerce/features/home/ui/widgets/title_and_actions_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  @override
  State<BrandsScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<BrandsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BrandCubit>().getAllBrands();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Brands',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: BlocBuilder<BrandCubit, BrandState>(
          buildWhen:
              (previous, current) =>
                  current is BrandLoading ||
                  current is BrandLoaded ||
                  current is BrandError,
          builder: (context, state) {
            if (state is BrandLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BrandLoaded) {
              final brands = state.brands;
              if (brands.isEmpty) {
                return const Center(child: Text("No Brands available"));
              }
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.8,
                ),
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  final brand = brands[index];
                  final imageUrl =
                      brand.photos?.isNotEmpty == true
                          ? brand.photos!.first.imageName
                          : null;

                  return GestureDetector(
                    onTap: () {
                      context.read<BrandCubit>().getProductsByBrandName(
                        brandName: brand.name ?? 'No Name',
                        pageNumber: 1,
                        pageSize: 10,
                      );
                      Navigator.of(
                        context,
                      ).pushNamed(Routes.viewAllProductsByBrandNameScreen);
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(12.r),
                              ),
                              child:
                                  imageUrl != null
                                      ? Image.network(
                                        ImageUrl.getValidUrl(imageUrl),
                                        fit: BoxFit.contain,
                                        // width: double.infinity,
                                      )
                                      : Container(
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Text(
                              brand.name ?? "No Name",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is BrandError) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              print("No Brands loaded State $state");
              return const Center(child: Text("No Brands loaded"));
            }
          },
        ),
      ),
    );
  }
}
