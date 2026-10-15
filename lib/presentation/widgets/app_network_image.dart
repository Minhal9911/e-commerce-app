import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(12);

    if (imageUrl.isEmpty) {
      return ClipRRect(borderRadius: radius, child: _buildErrorWidget());
    }

    return ClipRRect(
      borderRadius: radius,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        progressIndicatorBuilder: (context, url, progress) => SizedBox(
          width: width,
          height: height,
          child: Center(
            child:
                placeholder ??
                CircularProgressIndicator(
                  strokeWidth: 2,
                  value: progress.progress,
                ),
          ),
        ),
        errorWidget: (context, url, error) => _buildErrorWidget(),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return SizedBox(
      width: width,
      height: height,
      child: errorWidget ?? Container(
            color: Colors.grey.shade200,
            alignment: Alignment.center,
            child: const Icon(
              Icons.broken_image_outlined,
              color: Colors.grey,
              size: 40,
            ),
          ),
    );
  }
}
