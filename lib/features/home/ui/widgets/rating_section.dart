import 'package:ecommerce/core/helpers/spacing.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/features/home/data/models/rating_response_model.dart';
import 'package:ecommerce/features/home/logic/cubit/home_cubit.dart';
import 'package:ecommerce/features/home/ui/widgets/rating_list.dart';
import 'package:ecommerce/features/home/ui/widgets/rating_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RatingSection extends StatefulWidget {
  const RatingSection({super.key, required this.productId});
  final String productId;
  @override
  State<RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends State<RatingSection> {
  final TextEditingController reviewController = TextEditingController();

  int _selectedRating = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TokenManager.token != null
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocConsumer<HomeCubit, HomeState>(
              listener: (context, state) {
                if (state is UserRatingError || state is DeleteRatingSuccess) {
                  _selectedRating = 0;
                  reviewController.clear();
                } else if (state is UserRatingLoaded) {
                  final userRating = state.rating;
                  setState(() {
                    _selectedRating = userRating.score;
                    reviewController.text = userRating.comment ?? '';
                  });
                }
              },
              buildWhen:
                  (previous, current) =>
                      current is UserRatingLoaded ||
                      current is UserRatingError ||
                      current is DeleteRatingSuccess,
              builder: (context, state) {
                if (state is UserRatingError || state is DeleteRatingSuccess) {
                  return _buildRatingContainer();
                } else if (state is UserRatingLoaded) {
                  final rating = state.rating;
                  return _buildUserReview(context, rating);
                }
                return const SizedBox.shrink();
              },
            ),
            verticalSpace(16),
            Text(
              "Ratings and reviews",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),
            verticalSpace(8),
            RatingSummary(),
            verticalSpace(8),
            SizedBox(
              height: 200.h, // ارتفاع ثابت عشان ميحصلش مشكلة Scroll داخل Scroll
              child: RatingsList(productId: widget.productId),
            ),
            verticalSpace(16),
          ],
        )
        : SizedBox.shrink();
  }

  _buildRatingContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Rate this product",
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
          ),
          verticalSpace(6),
          Text(
            "Tell others what you think",
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
          verticalSpace(12),

          /// ⭐⭐⭐⭐⭐
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _selectedRating ? Icons.star : Icons.star_border,
                  color: index < _selectedRating ? Colors.amber : Colors.grey,
                  size: 32.sp,
                ),
                onPressed: () {
                  setState(() => _selectedRating = index + 1);
                },
              );
            }),
          ),

          Divider(height: 24.h),

          Text(
            "Write a review:",
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
          verticalSpace(8),
          TextField(
            maxLines: 3,
            controller: reviewController,
            decoration: InputDecoration(
              hintText: "Share your experience...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              contentPadding: EdgeInsets.all(12.w),
            ),
          ),
          verticalSpace(12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed:
                  _selectedRating > 0
                      ? () {
                        String comment = reviewController.text.trim();
                        comment = comment.isEmpty ? '' : comment;
                        context.read<HomeCubit>().submitRating(
                          score: _selectedRating,
                          comment: comment,
                          productId: widget.productId,
                        );
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text("Submit Review", style: TextStyle(fontSize: 14.sp)),
            ),
          ),
          verticalSpace(16),
        ],
      ),
    );
  }

  Widget _buildUserReview(BuildContext context, RatingResponseModel rating) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpace(16),
        Text(
          "Your Review",
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
        ),
        verticalSpace(8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.purple,
              child: Icon(Icons.person, color: Colors.white),
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المستخدم + زرار الحذف
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        rating.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (ctx) => AlertDialog(
                                  title: const Text("Delete Review"),
                                  content: const Text(
                                    "Are you sure you want to delete this review?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(ctx, false),
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            context.read<HomeCubit>().deleteRatingById(
                              ratingId: rating.id,
                              productId: rating.productId,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  verticalSpace(4),
                  // ⭐⭐⭐⭐⭐ Rating Stars
                  RatingBarIndicator(
                    rating: rating.score.toDouble(),
                    itemBuilder:
                        (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                    itemCount: 5,
                    itemSize: 20,
                    direction: Axis.horizontal,
                  ),
                  verticalSpace(6),
                  if (rating.comment.isNotEmpty)
                    Text(rating.comment, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
