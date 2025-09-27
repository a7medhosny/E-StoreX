import 'package:ecommerce/core/helpers/spacing.dart';
import 'package:flutter/material.dart';

class BasketAppBar extends StatelessWidget {
  const BasketAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      pinned: true,
      automaticallyImplyLeading: false,
      expandedHeight: 100,
      actions: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        horizontalSpace(12),
      ],
      flexibleSpace: const FlexibleSpaceBar(
        title: Text('Your Basket', style: TextStyle(color: Colors.black)),
        titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
