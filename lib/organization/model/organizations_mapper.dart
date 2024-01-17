import 'package:bunny_search/organization/model/organization_brand_details.dart';
import 'package:bunny_search/organization/model/organization_details.dart';
import 'package:bunny_search/theme/images_provider.dart';
import 'package:domain/organizations/model/organization.dart';
import 'package:domain/organizations/model/organization_brand.dart';
import 'package:domain/organizations/model/organization_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bunny_search/generated/locale_keys.g.dart';

class OrganizationsMapper {
  static OrganizationDetails toOrganizationDetails(Organization organization) {
    var logoSrc = '';
    var title = '';
    switch (organization.type) {
      case OrganizationType.petaWhite:
        logoSrc = ImagesProvider.ORG_PETA;
        title = LocaleKeys.organization_peta_dont_test.tr();
        break;
      case OrganizationType.petaBlack:
        logoSrc = ImagesProvider.ORG_PETA;
        title = LocaleKeys.organization_peta_do_test.tr();
        break;
      case OrganizationType.bunnySearch:
        logoSrc = ImagesProvider.ORG_BUNNY;
        title = LocaleKeys.organization_bunny_search.tr();
        break;
    }

    return OrganizationDetails(
      id: organization.id,
      title: title,
      logoSrc: logoSrc,
      brandsCount: organization.brandsCount,
      type: organization.type,
    );
  }

  static OrganizationBrandDetails toOrganizationBrandDetails(
    OrganizationBrand brand,
  ) {
    var logoSrc = '';
    switch (brand.organizationType) {
      case OrganizationType.petaWhite:
        logoSrc = ImagesProvider.ORG_PETA;
        break;
      case OrganizationType.petaBlack:
        logoSrc = ImagesProvider.ORG_PETA;
        break;
      case OrganizationType.bunnySearch:
        logoSrc = ImagesProvider.ORG_BUNNY;
        break;
    }

    return OrganizationBrandDetails(info: brand, logoSrc: logoSrc);
  }

  static String organizationsToString(List<Organization> organizations) {
    var result = organizationTypeToString(organizations[0].type);
    organizations.skip(1).forEach((e) {
      result += ' • ${organizationTypeToString(organizations[1].type)}';
    });
    return result;
  }

  static String organizationTypeToString(OrganizationType type) {
    switch (type) {
      case OrganizationType.petaWhite:
        return LocaleKeys.organization_peta_dont_test.tr();
      case OrganizationType.petaBlack:
        return LocaleKeys.organization_peta_do_test.tr();
      case OrganizationType.bunnySearch:
        return LocaleKeys.organization_bunny_search.tr();
    }
  }
}
