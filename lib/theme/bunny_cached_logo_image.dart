import 'package:bunny_search/theme/app_typography.dart';
import 'package:bunny_search/utils/cache/image_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

class BunnyCachedLogoImage extends StatelessWidget {
  final String logoUrl;
  final String title;

  const BunnyCachedLogoImage({
    Key? key,
    required this.logoUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fadeOutDuration: const Duration(milliseconds: 250),
      imageUrl: logoUrl,
      placeholder: (context, url) => Text(
        title.substring(0, 1),
        style: AppTypography.header.copyWith(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      errorWidget: (context, error, stacktrace) {
        return Text(
          title.substring(0, 1),
          style: AppTypography.header.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        );
      },
      cacheManager: OneYearImageCacheManager.instance,
    );
  }
}
