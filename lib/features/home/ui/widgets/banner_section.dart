import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/helpers/image_url.dart';
import 'package:ecommerce/core/widgets/product_image%20.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerSection extends StatelessWidget {
  BannerSection({super.key, required this.photos});

  final List<PhotoModel> photos;
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildImageSlider(),
          SizedBox(height: 16.h),
          _buildPageIndicator(),
          SizedBox(height: 16.h),
          _buildBannerText(),
          SizedBox(height: 16.h),
          _buildShopNowButton(),
        ],
      ),
    );
  }

  /// Image Slider for product photos
  Widget _buildImageSlider() {
    return SizedBox(
      height: 350.h,
      width: double.infinity,
      child: PageView.builder(
        controller: pageController,
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: CachedNetworkImage(
              imageUrl: ImageUrl.getValidUrl(photos[index].imageName),

              placeholder:
                  (context, url) =>
                      const Center(child: CircularProgressIndicator()),
              errorWidget:
                  (context, url, error) => const Icon(Icons.broken_image),
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  /// Smooth Page Indicator below the image slider
  Widget _buildPageIndicator() {
    return Center(
      child: SmoothPageIndicator(
        controller: pageController,
        count: photos.length,
        effect: WormEffect(
          dotWidth: 8.w,
          dotHeight: 8.h,
          activeDotColor: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildBannerText() {
    return Text(
      'Find Everything You Need in One Place',
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildShopNowButton() {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: OutlinedButton(
        onPressed: () {
          // TODO: Navigate to product listing
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.black),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Text(
          'Start Shopping',
          style: TextStyle(fontSize: 16.sp, color: Colors.black),
        ),
      ),
    );
  }
}
