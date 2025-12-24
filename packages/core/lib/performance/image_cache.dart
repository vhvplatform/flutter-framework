/// Image caching and optimization utilities
library image_cache;

import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Optimized image widget with caching
class OptimizedImage extends StatelessWidget {
  /// Creates an optimized image widget
  const OptimizedImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.cacheKey,
    super.key,
  });

  /// Image URL
  final String imageUrl;
  
  /// Image width
  final double? width;
  
  /// Image height
  final double? height;
  
  /// How to fit the image
  final BoxFit fit;
  
  /// Placeholder widget while loading
  final Widget? placeholder;
  
  /// Error widget if loading fails
  final Widget? errorWidget;
  
  /// Custom cache key
  final String? cacheKey;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      cacheKey: cacheKey,
      placeholder: (context, url) => 
          placeholder ?? const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          errorWidget ?? const Icon(Icons.error),
      memCacheWidth: width != null ? (width! * 2).toInt() : null,
      memCacheHeight: height != null ? (height! * 2).toInt() : null,
      maxWidthDiskCache: 1000,
      maxHeightDiskCache: 1000,
    );
  }
}

/// Image cache manager utilities
class ImageCacheManager {
  ImageCacheManager._();

  /// Clear image cache
  static Future<void> clearCache() async {
    await CachedNetworkImage.evictFromCache('');
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  /// Set image cache size
  static void setCacheSize({
    int maxCacheSize = 100,
    int maxCacheCount = 1000,
  }) {
    PaintingBinding.instance.imageCache.maximumSizeBytes = 
        maxCacheSize * 1024 * 1024; // Convert MB to bytes
    PaintingBinding.instance.imageCache.maximumSize = maxCacheCount;
  }

  /// Precache images
  static Future<void> precacheImages(
    BuildContext context,
    List<String> imageUrls,
  ) async {
    for (final url in imageUrls) {
      await precacheImage(
        CachedNetworkImageProvider(url),
        context,
      );
    }
  }
}
