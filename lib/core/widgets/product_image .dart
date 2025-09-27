import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;

  const ProductImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      // httpHeaders: {
      //   'Authorization': 'Bearer ${TokenManager.token}',
      //   'X-API-KEY':
      //       'ovuPaA2bJcgksW6yONrlDYtKweqihHfGnd9pI1FMVRmCTzE7UBx03SXZ8QL5j4',
      // },
      placeholder:
          (context, url) => const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(Icons.broken_image),
      fit: BoxFit.contain,
      width: double.infinity,
    );
  }
}
