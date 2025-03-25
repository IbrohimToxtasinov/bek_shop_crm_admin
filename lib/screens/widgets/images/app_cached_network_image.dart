import 'package:bek_shop/utils/app_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppCachedNetworkImage extends StatelessWidget {
  final String image;
  final double? height;
  final double iconSize;
  final double? width;
  final double radius;

  const AppCachedNetworkImage({
    super.key,
    required this.image,
    this.height,
    this.width,
    this.iconSize = 40,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.cover,
      imageBuilder: (context, imageProvider) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
          ),
        );
      },
      placeholder: (context, url) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            image: const DecorationImage(image: AssetImage(AppImages.loading), fit: BoxFit.cover),
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Icon(Icons.error, color: Colors.grey, size: 40),
        );
      },
    );
  }
}
