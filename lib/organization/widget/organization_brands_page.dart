import 'package:bunny_search/brand/widget/brand_details_page.dart';
import 'package:bunny_search/brand/widget/brand_list_item.dart';
import 'package:bunny_search/organization/bloc/organization_brands_bloc.dart';
import 'package:bunny_search/organization/model/organization_details.dart';
import 'package:bunny_search/organization/model/organizations_mapper.dart';
import 'package:bunny_search/theme/app_colors.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:bunny_search/theme/bunny_appbar_back_button.dart';
import 'package:bunny_search/theme/bunny_snack_bar.dart';
import 'package:domain/brands/model/brand.dart';
import 'package:domain/organizations/model/organization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bunny_search/generated/locale_keys.g.dart';

class OrganizationBrandsPage extends StatefulWidget {
  final OrganizationDetails organization;

  const OrganizationBrandsPage({Key? key, required this.organization})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _OrganizationBrandsPageState();

  static Widget withBloc(OrganizationDetails organization) => BlocProvider(
        create: (context) =>
            OrganizationBrandBloc(brandsRepository: context.read())
              ..add(LoadBrandsEvent(organizationType: organization.type)),
        child: OrganizationBrandsPage(
          organization: organization,
        ),
      );
}

class _OrganizationBrandsPageState extends State<OrganizationBrandsPage> {
  late OrganizationBrandBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrganizationBrandBloc, OrganizationBrandsState>(
        listener: (context, state) {
      final isError = state.brandsResult.isError == true;
      if (isError) {
        _handleError();
      }
    }, builder: (context, state) {
      final progress = state.brandsResult.isInProgress;
      final brands =
          state.brandsResult.isSuccessful ? state.brandsResult.value ?? [] : [];
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: BunnyAppBarBackButton(),
          title: Column(
            children: [
              Text(
                widget.organization.title,
                style: AppTypography.h4,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                LocaleKeys.organization_brands_count.tr(
                    namedArgs: {'count': '${widget.organization.brandsCount}'}),
                style: AppTypography.caption,
              )
            ],
          ),
        ),
        body: progress
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.rose,
                ),
              )
            : SafeArea(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 24),
                  itemBuilder: (context, pos) {
                    Brand brand = brands[pos];
                    return TextButton(
                      style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              AppColors.rose.withOpacity(0.05))),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                BrandDetailsPage(brand: brand)));
                      },
                      child: BrandListItem(
                          title: brand.title,
                          filters: _buildFiltersString(
                              brand.organizations.values.toList()),
                          logoUrl: brand.logoUrl ?? ''),
                    );
                  },
                  itemCount: brands.length,
                ),
              ),
      );
    });
  }

  String _buildFiltersString(List<Organization> organizations) {
    return '${organizations.map((o) => OrganizationsMapper.organizationTypeToString(o.type)).join(' • ')}';
  }

  void _handleError() {
    ScaffoldMessenger.of(context).showSnackBar(
      BunnyDefaultSnackBar(
          text: LocaleKeys.general_error.tr(),
          onRetry: () => _bloc.add(
              LoadBrandsEvent(organizationType: widget.organization.type))),
    );
  }
}
