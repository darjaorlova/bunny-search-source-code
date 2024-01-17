import 'package:domain/organizations/model/organization_type.dart';
import 'package:equatable/equatable.dart';

class OrganizationBrand extends Equatable {
  final String id;
  final String title;
  final OrganizationType organizationType;
  final String organizationWebsite;
  final bool? hasVeganProducts;
  final String? logoUrl;

  const OrganizationBrand({
    required this.id,
    required this.title,
    required this.organizationType,
    required this.organizationWebsite,
    required this.hasVeganProducts,
    required this.logoUrl,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'organizationType': _toOrganizationTypeString(organizationType),
        'organizationWebsite': organizationWebsite,
        'hasVeganProducts': hasVeganProducts,
        'logoUrl': logoUrl
      };

  @override
  List<Object?> get props => [
        id,
        title,
        organizationType,
        organizationWebsite,
        hasVeganProducts,
        logoUrl
      ];
}

String _toOrganizationTypeString(OrganizationType type) {
  switch (type) {
    case OrganizationType.petaWhite:
      return 'peta_white';
    case OrganizationType.petaBlack:
      return 'peta_black';
    case OrganizationType.bunnySearch:
      return 'bunny_search';
  }
}
