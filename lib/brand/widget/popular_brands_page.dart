import 'package:bunny_search/brand/bloc/popular_brands_bloc.dart';
import 'package:bunny_search/brand/widget/brand_details_page.dart';
import 'package:bunny_search/brand/widget/brand_list_item.dart';
import 'package:bunny_search/theme/app_colors.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:bunny_search/theme/bunny_appbar_back_button.dart';
import 'package:bunny_search/theme/bunny_snack_bar.dart';
import 'package:domain/brands/model/brand.dart';
import 'package:domain/organizations/model/organization.dart';
import 'package:domain/organizations/model/organization_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bunny_search/generated/locale_keys.g.dart';

class PopularBrandsPage extends StatefulWidget {
  const PopularBrandsPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PopularBrandsPageState();

  static Widget withBloc() => BlocProvider(
        create: (context) => PopularBrandBloc(brandsRepository: context.read())
          ..add(LoadBrandsEvent()),
        child: const PopularBrandsPage(),
      );
}

class _PopularBrandsPageState extends State<PopularBrandsPage> {
  late PopularBrandBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PopularBrandBloc, PopularBrandsState>(
      listener: (context, state) {
        final isError = state.brandsResult.isError == true;
        if (isError) {
          _handleError();
        }
      },
      builder: (context, state) {
        final progress = state.brandsResult.isInProgress;
        final brands = state.brandsResult.isSuccessful
            ? state.brandsResult.value ?? []
            : [];
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: const BunnyAppBarBackButton(),
            title: Column(
              children: [
                Text(
                  LocaleKeys.popular_brands_title.tr(),
                  style: AppTypography.h4,
                ),
              ],
            ),
          ),
          body: progress
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.rose,
                  ),
                )
              : SafeArea(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemBuilder: (context, pos) {
                      Brand brand = brands[pos];
                      return TextButton(
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                            AppColors.rose.withOpacity(0.05),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  BrandDetailsPage(brand: brand),
                            ),
                          );
                        },
                        child: BrandListItem(
                          title: brand.title,
                          filters: _buildFiltersString(
                            brand.organizations.values.toList(),
                          ),
                          logoUrl: brand.logoUrl ?? '',
                        ),
                      );
                    },
                    itemCount: brands.length,
                  ),
                ),
        );
      },
    );
  }

  String _buildFiltersString(List<Organization> organizations) {
    return organizations.map((o) => _organizationTypeToString(o.type)).join(' • ');
  }

  String _organizationTypeToString(OrganizationType type) {
    switch (type) {
      case OrganizationType.petaWhite:
        return LocaleKeys.organization_peta_dont_test.tr();
      case OrganizationType.petaBlack:
        return LocaleKeys.organization_peta_do_test.tr();
      case OrganizationType.bunnySearch:
        return LocaleKeys.organization_bunny_search.tr();
    }
  }

  void _handleError() {
    ScaffoldMessenger.of(context).showSnackBar(
      BunnyDefaultSnackBar(
        text: LocaleKeys.general_error.tr(),
        onRetry: () => _bloc.add(LoadBrandsEvent()),
      ),
    );
  }
}
