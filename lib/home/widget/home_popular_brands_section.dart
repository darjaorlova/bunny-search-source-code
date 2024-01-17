import 'package:bunny_search/brand/widget/popular_brands_page.dart';
import 'package:bunny_search/generated/locale_keys.g.dart';
import 'package:bunny_search/home/widget/show_all_button.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomePopularBrandsSection extends StatelessWidget {
  const HomePopularBrandsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            LocaleKeys.home_popular_brands.tr(),
            style: AppTypography.headerMedium,
          ),
          ShowAllButton(onShowAll: () => _showAllPopularBrands(context))
        ],
      ),
    );
  }

  void _showAllPopularBrands(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PopularBrandsPage.withBloc()),
    );
  }
}
