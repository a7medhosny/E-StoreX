import 'package:ecommerce/core/helpers/image_url.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/core/routing/routes.dart';
import 'package:ecommerce/core/widgets/product_image%20.dart';
import 'package:ecommerce/features/basket/data/models/basket_request_model.dart';
import 'package:ecommerce/features/basket/logic/cubit/basket_cubit.dart';
import 'package:ecommerce/features/basket/data/models/basket_item_model.dart';
import 'package:ecommerce/features/home/data/models/product_model.dart';
import 'package:ecommerce/features/home/logic/cubit/home_cubit.dart';
import 'package:ecommerce/features/home/ui/widgets/rating_list.dart';
import 'package:ecommerce/features/home/ui/widgets/rating_section.dart';
import 'package:ecommerce/features/home/ui/widgets/recommendes_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final PageController pageController = PageController();
  // حفظ الريتنج المختار
  @override
  void initState() {
    context.read<HomeCubit>()
      ..getRatingsByProductId(widget.product.id ?? '')
      ..getUserRating(widget.product.id ?? '')
      ..getRatingSummary(widget.product.id ?? '')
      ..getRecommendedProducts(categoryName: widget.product.categoryName ?? '');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  _buildSliverAppBar(context),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(),
                          SizedBox(height: 12.h),
                          _buildPrice(),
                          RatingSection(productId: widget.product.id ?? ''),
                          SizedBox(height: 24.h),
                          RecommendedSection(
                            categoryName: widget.product.categoryName ?? '',
                            ProductId: widget.product.id ?? '',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.w),
              child: _buildAddToCartButton(context),
            ),
          ],
        ),
      ),
    );
  }

  /// ---------- Components ----------

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hot Pick', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
        SizedBox(height: 8.h),
        Text(
          widget.product.name ?? '',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.h),
        Text(
          widget.product.description ?? '',
          style: TextStyle(fontSize: 13.sp, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildPrice() {
    return Row(
      children: [
        /// السعر الجديد
        Text(
          '\$${widget.product.newPrice}',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.green,
          ),
        ),
        SizedBox(width: 8.w),

        if (widget.product.oldPrice != null && widget.product.oldPrice != 0)
          Text(
            '\$${widget.product.oldPrice}',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    bool inStock = widget.product.quantityAvailable! > 0;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed:
                inStock
                    ? () {
                      context.read<BasketCubit>().addItemToBasket(
                        item: BasketRequestModel(
                          basketItem: BasketItemModel(
                            id: widget.product.id,
                            name: widget.product.name,
                            description: widget.product.categoryName,
                            qunatity: 1,
                            price: widget.product.newPrice,
                            category: widget.product.categoryName,
                            image: ImageUrl.getValidUrl(
                              widget.product.photos!.first.imageName,
                            ),
                          ),
                          basketId: TokenManager.userId ?? TokenManager.guestId,
                        ),
                      );
                    }
                    : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              inStock ? 'Add to Cart' : 'Out of Stock',
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ),
        BlocListener<BasketCubit, BasketState>(
          listener: (context, state) {
            if (state is BasketItemAddedSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is BasketItemAddedError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Container(),
        ),
      ],
    );
  }

  /// ---------- Existing Code (AppBar + Slider) ----------
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      leading: _buildBackButton(context),
      pinned: true,

      expandedHeight: 500.h,
      flexibleSpace: FlexibleSpaceBar(
        background: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.imageScreen,
              arguments: widget.product.photos,
            );
          },
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

  Widget _buildBackButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r)),
      child: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildImageSlider() {
    final photos = widget.product.photos;

    if (photos == null || photos.isEmpty) {
      return Expanded(
        child: Container(
          color: Colors.grey[200],
          child: Center(
            child: Icon(
              Icons.image_not_supported,
              size: 60.sp,
              color: Colors.grey,
            ),
          ),
        ),
      );
    }

    return Expanded(
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return ProductImage(
                imageUrl: ImageUrl.getValidUrl(photos[index].imageName),
              );
            },
          ),

          Positioned(
            top: 16,
            right: 16,
            child: IconButton(
              icon: Icon(
                context.watch<HomeCubit>().isFavorite(widget.product.id ?? '')
                    ? Icons.favorite
                    : Icons.favorite_border,
                color:
                    context.watch<HomeCubit>().isFavorite(
                          widget.product.id ?? '',
                        )
                        ? Colors.red
                        : Colors.grey,
              ),
              onPressed: () {
                if (TokenManager.token != null &&
                    TokenManager.token!.isNotEmpty) {
                  /// ✅ فيه توكين → نفذ التوجيل
                  context.read<HomeCubit>().toggleFavorite(widget.product);
                } else {
                  /// 🚫 مفيش توكين → روح على اللوجين
                  Navigator.pushNamed(context, Routes.loginRegisterTabSwitcher);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return SmoothPageIndicator(
      controller: pageController,
      count: widget.product.photos!.length,
      effect: WormEffect(
        dotWidth: 8.w,
        dotHeight: 8.h,
        activeDotColor: Colors.blue,
      ),
    );
  }
}
