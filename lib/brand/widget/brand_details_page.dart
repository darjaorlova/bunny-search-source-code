import 'package:bunny_search/theme/app_colors.dart';
import 'package:bunny_search/theme/app_typography.dart';
import 'package:bunny_search/theme/bunny_back_button.dart';
import 'package:bunny_search/theme/bunny_cached_logo_image.dart';
import 'package:bunny_search/theme/images_provider.dart';
import 'package:domain/brands/model/brand.dart';
import 'package:domain/organizations/model/organization.dart';
import 'package:domain/organizations/model/organization_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bunny_search/generated/locale_keys.g.dart';

class BrandDetailsPage extends StatefulWidget {
  final Brand brand;

  const BrandDetailsPage({Key? key, required this.brand}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BrandDetailsPageState();
}

class _BrandDetailsPageState extends State<BrandDetailsPage> {
  var _height = 0.0;

  void _onPanelSlide(double pos) {
    final fullHeight = MediaQuery.of(context).size.height;
    final maxHeight = fullHeight * 0.18;

    final fullDiff = fullHeight * 0.18 - fullHeight * 0.09;
    final height = maxHeight - (fullDiff * pos);

    setState(() {
      _height = height;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_height == 0) {
      _height = MediaQuery.of(context).size.height * 0.18;
    }
    return Scaffold(
      body: Stack(
        children: [
          SlidingUpPanel(
            maxHeight: MediaQuery.of(context).size.height * 0.9 -
                MediaQuery.of(context).padding.top,
            minHeight: MediaQuery.of(context).size.height * 0.75,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.0),
              )
            ],
            onPanelSlide: _onPanelSlide,
            parallaxEnabled: false,
            panelBuilder: (sc) => _BrandDetailsBody(sc, widget.brand),
            body: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.25 + 48,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFC3EDFF),
                        Color(0xFFEFEAFF),
                        Color(0xFFFEE8E6),
                      ],
                      stops: [0, 41.01, 89.67],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      left: 32,
                      right: 32,
                      bottom: 32,
                    ),
                    height: _height,
                    child: widget.brand.logoUrl == null ||
                            widget.brand.logoUrl!.isEmpty == true
                        ? Center(
                            child: Text(
                              widget.brand.title,
                              style: AppTypography.header
                                  .copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : widget.brand.logoUrl!.endsWith('svg')
                            ? SvgPicture.network(
                                widget.brand.logoUrl!,
                                width: _height,
                                height: _height,
                              )
                            : BunnyCachedLogoImage(
                                logoUrl: widget.brand.logoUrl!,
                                title: widget.brand.title,
                              ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 16,
                      top: MediaQuery.of(context).padding.top + 24,
                    ),
                    child: const BunnyBackButton(),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _BrandDetailsBody extends StatelessWidget {
  final ScrollController sc;
  final Brand brand;

  const _BrandDetailsBody(this.sc, this.brand);

  @override
  Widget build(BuildContext context) {
    final isPetaBlack = brand.organizations.values
        .any((o) => o.type == OrganizationType.petaBlack);
    final isPetaWhite = brand.organizations.values
        .any((o) => o.type == OrganizationType.petaWhite);
    final isBunnySearch = brand.organizations.values
        .any((o) => o.type == OrganizationType.bunnySearch);
    return SingleChildScrollView(
      controller: sc,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                brand.title,
                style: AppTypography.title,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      LocaleKeys.brand_details_cf_markers.tr(),
                      style: AppTypography.caption,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    if (isPetaWhite)
                      _BrandDetailsPositiveMarker(
                        LocaleKeys.brand_details_peta_dont_test_marker.tr(),
                        isPetaWhite,
                      ),
                    if (isBunnySearch)
                      _BrandDetailsPositiveMarker(
                        LocaleKeys.brand_details_bunny_search_marker.tr(),
                        isBunnySearch,
                      ),
                    if (isPetaBlack)
                      _BrandDetailsNegativeMarker(
                        LocaleKeys.brand_details_peta_do_test_marker.tr(),
                        isPetaBlack,
                      ),
                    if (brand.hasVeganProducts == true) ...[
                      const SizedBox(
                        height: 24,
                      ),
                      Text(
                        LocaleKeys.brand_details_other_markers.tr(),
                        style: AppTypography.caption,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      _BrandDetailsPositiveMarker(
                        LocaleKeys.brand_details_vegan_marker.tr(),
                        true,
                      ),
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                LocaleKeys.brand_details_based_on.tr(
                  namedArgs: {
                    'source':
                        _buildBasedOnString(brand.organizations.values.toList())
                  },
                ),
                style: AppTypography.caption,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            /*Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Alternatives",
                    style: AppTypography.headerMedium,
                  ),
                  Text(
                    "Show All",
                    style: AppTypography.label,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Container(
              height: 72,
              child: ListView.separated(
                  separatorBuilder: (context, pos) => SizedBox(
                        width: 16,
                      ),
                  padding: EdgeInsets.only(left: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => BrandDetailsPage()));
                      },
                      child: Container(
                        width: 72,
                        height: 72,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Image.asset(
                            ImagesProvider.LEAPING_BUNNY,
                            width: 48,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: 20),
            )*/
          ],
        ),
      ),
    );
  }

  String _buildBasedOnString(List<Organization> organizations) {
    return organizations.map((o) => o.website).join(', ');
  }
}

class _BrandDetailsPositiveMarker extends StatelessWidget {
  final String text;
  final bool enabled;

  const _BrandDetailsPositiveMarker(this.text, this.enabled);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            ImagesProvider.CHECK,
            color: enabled ? AppColors.positive : AppColors.inactive,
            width: 24,
            height: 24,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              text,
              style: enabled
                  ? AppTypography.labelDark.copyWith(height: 1.5)
                  : AppTypography.labelInactive.copyWith(height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}

class _BrandDetailsNegativeMarker extends StatelessWidget {
  final String text;
  final bool enabled;

  const _BrandDetailsNegativeMarker(this.text, this.enabled);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            ImagesProvider.STOP,
            color: enabled ? AppColors.negative : AppColors.inactive,
            width: 24,
            height: 24,
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              text,
              style: enabled
                  ? AppTypography.labelDark.copyWith(height: 1.5)
                  : AppTypography.labelInactive.copyWith(height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
