import 'package:bunny_search/theme/app_colors.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:bunny_search/theme/bunny_cached_logo_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BrandListItem extends StatelessWidget {
  final String title;
  final String filters;
  final String logoUrl;

  const BrandListItem({
    Key? key,
    required this.title,
    required this.filters,
    required this.logoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: logoUrl.isEmpty
                  ? Text(
                      title.substring(0, 1),
                      style: AppTypography.header
                          .copyWith(fontWeight: FontWeight.bold),
                    )
                  : logoUrl.endsWith('svg')
                      ? SvgPicture.network(
                          logoUrl,
                          placeholderBuilder: (context) => Text(
                            title.substring(0, 1),
                            style: AppTypography.header
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        )
                      : BunnyCachedLogoImage(
                          logoUrl: logoUrl,
                          title: title,
                        ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    title,
                    style: AppTypography.medium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  filters,
                  style: AppTypography.caption,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
