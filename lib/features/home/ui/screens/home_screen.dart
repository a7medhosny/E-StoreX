import 'package:ecommerce/core/helpers/spacing.dart';
import 'package:ecommerce/features/home/ui/widgets/guest_banner.dart';
import 'package:ecommerce/features/home/ui/widgets/title_and_actions_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ecommerce/features/shop/categories/data/models/category_model.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/logic/cubit/home_cubit.dart';
import 'package:ecommerce/features/home/ui/widgets/banner_section.dart';
import 'package:ecommerce/features/home/ui/widgets/new_in_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.scrollController});
  final ScrollController scrollController;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch home data when the screen initializes
    // This is crucial to trigger the loading state and then data loaded state
    context.read<HomeCubit>()..getFavorites()..getAllHomeData();
    
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        buildWhen:
            (previous, current) =>((current != previous) &&(
                current is HomeLoading ||
                current is HomeDataLoaded ||
                current is ToggleFavouritesSuccess ||
                current is HomeError)),
        builder: (context, state) {
          print("HomeScreen: $state");
          if (state is HomeLoading ) {
            return _buildLoadingState(); // Custom loading UI
          } else if (state is HomeDataLoaded ||
              state is ToggleFavouritesSuccess) {
            return _buildHomeLoaded(cubit.localProducts, cubit.localCategories);
          } else if (state is HomeError) {
            return _buildErrorState(state.message); // Custom error UI
          } else {
            // Default state or initial state, could be a loading spinner or empty view
            return const Center(child: Text("Initializing..."));
          }
        },
      ),
    );
  }

  /// --- UI for Loading State ---
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 16.h),
          Text(
            "Loading your shopping experience...",
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  /// --- UI for Error State ---
  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 80.r),
            SizedBox(height: 24.h),
            Text(
              "Oops! Something went wrong.",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32.h),
            ElevatedButton.icon(
              onPressed: () {
                // Trigger the cubit to re-fetch data
                context.read<HomeCubit>().getAllHomeData();
              },
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// --- UI for Loaded State ---
  Widget _buildHomeLoaded(
    List<ProductModel> products,
    List<CategoryModel> categories,
  ) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Row
          const TitleAndActionsButtons(),
          SizedBox(height: 24.h),

          /// Content
          Expanded(
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                children: [
                  GuestBanner(),

                  /// Banner
                  // Check if products list is not empty before accessing first.photos
                  if (products.isNotEmpty &&
                      products.first.photos != null &&
                      products.first.photos!.isNotEmpty)
                    BannerSection(photos: products.first.photos!)
                  else
                    // Placeholder or empty state for banner if no product photos
                    Container(
                      height: 150.h,
                      color: Colors.grey[200],
                      child: Center(
                        child: Text(
                          "No banners available",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  verticalSpace(40),

                  /// New In Section
                  // Check if products list is not empty before passing it
                  if (products.isNotEmpty)
                    NewInSection(products: products)
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Center(
                        child: Text(
                          "No new products to display",
                          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                        ),
                      ),
                    ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
