import 'package:ecommerce/features/home/logic/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingSummary extends StatelessWidget {
  const RatingSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) {
        return current is GetSummaryLoading ||
            current is GetSummaryLoaded ||
            current is GetSummaryError;
      },
      builder: (context, state) {
        if (state is GetSummaryLoaded) {
          final summary = state.summary;
          final total = summary.totalRatings == 0 ? 1 : summary.totalRatings;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: summary.averageScore,
                      itemBuilder:
                          (context, _) =>
                              const Icon(Icons.star, color: Colors.amber),
                      itemCount: 5,
                      itemSize: 24.0,
                      direction: Axis.horizontal,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      summary.averageScore.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(" (${summary.totalRatings})"),
                  ],
                ),

                const SizedBox(height: 16),

                if (summary.scoreDistribution.isNotEmpty)
                  Column(
                    children: List.generate(5, (index) {
                      final star = 5 - index;
                      final count = summary.scoreDistribution["$star"] ?? 0;
                      final percent = count / total;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Text("$star ⭐"),
                            const SizedBox(width: 8),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: percent,
                                backgroundColor: Colors.grey[300],
                                color: Colors.amber,
                                minHeight: 10,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(count.toString()),
                          ],
                        ),
                      );
                    }),
                  ),
              ],
            ),
          );
        }

        if (state is GetSummaryLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetSummaryError) {
          return Center(child: Text("Error: ${state.message}"));
        }

        return const SizedBox.shrink();
      },
    );
  }
}
