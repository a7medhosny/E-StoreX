import 'package:ecommerce/core/helpers/image_url.dart';
import 'package:ecommerce/core/widgets/product_image%20.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageScreen extends StatelessWidget {
  ImageScreen({super.key, required this.photos});
  final List<PhotoModel> photos;
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            children: [
              _buildImageSlider(),
              SizedBox(height: 16.h),
              _buildPageIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSlider() {
    return Expanded(
      child: PageView.builder(
        controller: pageController,
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            panEnabled: true, // السماح بتحريك الصورة
            scaleEnabled: true, // السماح بالتكبير والتصغير
            minScale: 1.0,
            maxScale: 4.0,
            child: ProductImage(imageUrl: ImageUrl.getValidUrl(photos[index].imageName))
          );
        },
      ),
    );
  }

  /// Smooth Page Indicator below the image slider
  Widget _buildPageIndicator() {
    return SmoothPageIndicator(
      controller: pageController,
      count: photos.length,
      effect: WormEffect(
        dotWidth: 8.w,
        dotHeight: 8.h,
        activeDotColor: Colors.blue,
      ),
    );
  }
}
