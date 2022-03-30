import 'package:bunny_search/generated/locale_keys.g.dart';
import 'package:bunny_search/theme/app_colors.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:bunny_search/theme/images_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeSplashScreen extends StatelessWidget {
  const HomeSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD8CCFF), Color(0xFFA3E3FF)],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(
              ImagesProvider.SEARCH_BUNNY,
              width: MediaQuery.of(context).size.width / 3,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            LocaleKeys.splash_loading_brands.tr(),
            style: AppTypography.regular.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                fontSize: 18,
                decorationColor: AppColors.white.withOpacity(0.01)),
          )
        ],
      ),
    );
  }
}
