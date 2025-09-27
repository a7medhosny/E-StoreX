import 'package:ecommerce/core/helpers/image_url.dart';
import 'package:ecommerce/core/routing/routes.dart';
import 'package:ecommerce/core/widgets/product_image%20.dart';
import 'package:ecommerce/features/shop/categories/logic/cubit/category_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.r),
        child: BlocConsumer<CategoryCubit, CategoryState>(
          listenWhen:
              (previous, current) =>
                  current is CategoryProductLoaded ||
                  current is CategoryProductLoading ||
                  current is CategoryProductError,
          listener: (context, state) {
            if (state is CategoryProductError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          buildWhen:
              (previous, current) =>
                  current is HomeCategoriesLoading ||
                  current is HomeCategoriesLoaded ||
                  current is HomeCategoriesError,
          builder: (context, state) {
            if (state is HomeCategoriesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is HomeCategoriesLoaded) {
              final categories = state.categories;

              if (categories.isEmpty) {
                return const Center(child: Text("No categories available"));
              }

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // عمودين
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.8, // تحكم في شكل الكارد
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final imageUrl =
                      category.photos?.isNotEmpty == true
                          ? category.photos!.first.imageName
                          : null;

                  return GestureDetector(
                    onTap: () {
                      context.read<CategoryCubit>().getProductByCategoryId(
                        categoryName: category.name,
                        pageNumber: 1,
                        pageSize: 10,
                      );
                      Navigator.pushNamed(
                        context,
                        Routes.viewAllProductsByCategoryScreen,
                      );
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
                                        fit: BoxFit.cover,
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
                              category.name,
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
            } else if (state is HomeCategoriesError) {
              return Center(child: Text("Error: ${state.message}"));
            } else {
              return const Center(child: Text("No categories loaded"));
            }
          },
        ),
      ),
    );
  }
}
