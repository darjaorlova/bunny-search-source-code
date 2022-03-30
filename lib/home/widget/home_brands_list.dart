import 'package:bunny_search/brand/widget/brand_details_page.dart';
import 'package:bunny_search/brand/widget/brand_list_item.dart';
import 'package:bunny_search/organization/model/organizations_mapper.dart';
import 'package:bunny_search/theme/app_colors.dart';
import 'package:domain/brands/model/brand.dart';
import 'package:flutter/material.dart';

class HomeBrandsList extends StatelessWidget {
  final List<Brand> brands;

  const HomeBrandsList({Key? key, required this.brands})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        final brand = brands[index];
        return TextButton(
          style: ButtonStyle(
              overlayColor:
                  MaterialStateProperty.all(AppColors.rose.withOpacity(0.05))),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => BrandDetailsPage(brand: brand)));
          },
          child: BrandListItem(
              title: brand.title,
              filters: OrganizationsMapper.organizationsToString(
                  brand.organizations.values.toList()),
              logoUrl: brand.logoUrl ?? ''),
        );
      },
      childCount: brands.length,
    ));
  }
}
