import 'package:bunny_search/generated/locale_keys.g.dart';
import 'package:bunny_search/home/widget/home_brands_list.dart';
import 'package:bunny_search/home/widget/home_organizations_section.dart';
import 'package:bunny_search/home/widget/home_popular_brands_section.dart';
import 'package:bunny_search/home/widget/no_overscroll_behaviour.dart';
import 'package:bunny_search/home/widget/search_bar.dart';
import 'package:bunny_search/home/widget/search_with_ai_button.dart';
import 'package:bunny_search/home/widget/sliver_search_app_bar.dart';
import 'package:bunny_search/organization/model/organization_details.dart';
import 'package:bunny_search/theme/app_colors.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:domain/brands/model/brand.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HomeContentScreen extends StatelessWidget {
  final bool showProgress;
  final bool showOrganizations;
  final bool showPopularBrands;
  final bool showSearchResults;
  final List<Brand> searchBrands;
  final List<Brand> popularBrands;
  final List<OrganizationDetails> organizations;
  final OnSearchTermChanged onSearchTermChanged;
  final String searchQuery;

  const HomeContentScreen({
    Key? key,
    required this.showProgress,
    required this.showOrganizations,
    required this.showPopularBrands,
    required this.showSearchResults,
    required this.searchBrands,
    required this.popularBrands,
    required this.organizations,
    required this.onSearchTermChanged,
    required this.searchQuery,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) {
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverPersistentHeader(
                delegate: SliverSearchAppBar(
                  onSearchTermChanged: onSearchTermChanged,
                ),
                pinned: true,
              ),
            ),
          ];
        },
        body: Builder(
          builder: (BuildContext context) => CustomScrollView(
            key: const ValueKey<String>('home_scroll_view'),
            scrollBehavior: NoOverscrollBehavior(),
            slivers: [
              SliverOverlapInjector(
                // This is the flip side of the SliverOverlapAbsorber
                // above.
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    if (showOrganizations)
                      HomeOrganizationsSection(
                        organizations: organizations,
                      ),
                    if (showPopularBrands) const HomePopularBrandsSection(),
                    if (showSearchResults || showProgress) ...[
                      SearchWithAIButton(searchQuery: searchQuery),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 12,
                        ),
                        child: Text(
                          LocaleKeys.home_results.tr(),
                          style: AppTypography.headerMedium,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                    if (showProgress)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.rose,
                        ),
                      )
                  ],
                ),
              ),
              if (!showProgress)
                HomeBrandsList(
                  brands: showSearchResults ? searchBrands : popularBrands,
                ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 32,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
