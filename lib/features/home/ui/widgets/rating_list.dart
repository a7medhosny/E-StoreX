import 'package:ecommerce/features/home/logic/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingsList extends StatelessWidget {
  final String productId;

  const RatingsList({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is SubmitRatingError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      buildWhen:
          (previous, current) =>
              current is RatingsLoaded ||
              current is RatingsError ||
              current is RatingsLoading,
      builder: (context, state) {
        print("Rating State: $state");
        if (state is RatingsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is RatingsError) {
          print("${state.message}");
          return Center(child: Text(state.message));
        } else if (state is RatingsLoaded) {
          final ratings = state.ratings;
          print("Ratings Count: ${ratings.length}");
          if (ratings.isEmpty) {
            return const Center(child: Text("No reviews yet"));
          }
          return ListView.separated(
            itemCount: ratings.length,
            itemBuilder: (context, index) {
              final rating = ratings[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.purple,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rating.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
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
                      const SizedBox(height: 6),
                      if (rating.comment.isNotEmpty)
                        Text(
                          rating.comment,
                          style: const TextStyle(fontSize: 14),
                        ),
                    ],
                  ),
                ],
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 12);
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
