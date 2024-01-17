import 'package:bunny_search/organization/model/organization_details.dart';
import 'package:bunny_search/organization/widget/organization_brands_page.dart';
import 'package:bunny_search/theme/app_colors.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bunny_search/generated/locale_keys.g.dart';

class OrganizationListCard extends StatelessWidget {
  final OrganizationDetails details;

  const OrganizationListCard({Key? key, required this.details})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OrganizationBrandsPage.withBloc(details),
          ),
        );
      },
      child: Container(
        height: 176,
        width: 148,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              details.title,
              style: AppTypography.labelDark,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              LocaleKeys.organization_brands_count.tr(
                namedArgs: {'count': '${details.brandsCount}'},
              ),
              style: AppTypography.caption,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                details.logoSrc,
                width: 64,
                height: 48,
              ),
            )
          ],
        ),
      ),
    );
  }
}
