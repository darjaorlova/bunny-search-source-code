import 'package:bunny_search/generated/locale_keys.g.dart';
import 'package:bunny_search/home/widget/background_wave_clipper.dart';
import 'package:bunny_search/home/widget/search_bar.dart';
import 'package:bunny_search/home/widget/search_bunny_icon_clipper.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:bunny_search/theme/images_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SliverSearchAppBar extends SliverPersistentHeaderDelegate {
  final OnSearchTermChanged onSearchTermChanged;

  SliverSearchAppBar({required this.onSearchTermChanged});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final adjustedShrink = shrinkOffset * 2;
    final snap = adjustedShrink > 60;
    double searchExtraOffset = ((280 - adjustedShrink) * 0.36).abs().toDouble();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 280,
          child: ClipPath(
            clipper: BackgroundWaveClipper(),
            child: AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 200),
              width: MediaQuery.of(context).size.width,
              height: 280,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
                colors: [Color(0xFFC3EDFF), Color(0xFFEFEAFF)],
                stops: [0.0, 0.51],
                tileMode: TileMode.clamp,
              )),
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: snap ? 0 : 1,
          duration: Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          child: Container(
            margin: EdgeInsets.only(left: 16, top: 80),
            child: Text(
              LocaleKeys.home_search_prompt.tr(),
              style: AppTypography.header,
            ),
          ),
        ),
        Positioned(
            right: 48,
            child: AnimatedOpacity(
              opacity: snap ? 0 : 1,
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 200),
              child: ClipPath(
                clipper: SearchBunnyIconClipper(),
                child: Container(
                  margin: EdgeInsets.only(top: 48),
                  child: Image.asset(
                    ImagesProvider.SEARCH_BUNNY,
                    width: 102,
                  ),
                ),
              ),
            )),
        Positioned(
            top: 64 + searchExtraOffset,
            child: SearchBar(
              onSearchTermChanged: onSearchTermChanged,
            ))
      ],
    );
  }

  @override
  double get maxExtent => 280;

  @override
  double get minExtent => 140;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      oldDelegate != this;
}
