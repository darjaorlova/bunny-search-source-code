import 'package:domain/organizations/model/organization_brand.dart';
import 'package:domain/organizations/model/organization_type.dart';
import 'package:equatable/equatable.dart';

class FirebaseOrganizationBrand extends Equatable {
  final String id;
  final String title;
  final String organizationType;
  final String organizationWebsite;
  final bool? hasVeganProducts;
  final String? logoUrl;

  const FirebaseOrganizationBrand({
    required this.id,
    required this.title,
    required this.organizationType,
    required this.organizationWebsite,
    required this.hasVeganProducts,
    required this.logoUrl,
  });

  factory FirebaseOrganizationBrand.fromJson(Map<String, dynamic> json) =>
      FirebaseOrganizationBrand(
        id: json['id'] as String,
        title: json['title'] as String,
        organizationType: json['organizationType'] as String,
        organizationWebsite: json['organizationWebsite'] as String,
        hasVeganProducts: json['hasVeganProducts'] as bool?,
        logoUrl: json['logoUrl'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'organizationType': organizationType,
        'organizationWebsite': organizationWebsite,
        'hasVeganProducts': hasVeganProducts,
        'logoUrl': logoUrl
      };

  OrganizationBrand toOrganizationBrand() => OrganizationBrand(
        id: id,
        title: title,
        organizationType: _toOrganizationTypeFromString(organizationType),
        organizationWebsite: organizationWebsite,
        hasVeganProducts: hasVeganProducts,
        logoUrl: logoUrl,
      );

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

OrganizationType _toOrganizationTypeFromString(String type) {
  switch (type) {
    case 'peta_white':
      return OrganizationType.petaWhite;
    case 'peta_black':
      return OrganizationType.petaBlack;
    case 'bunny_search':
      return OrganizationType.bunnySearch;
  }
  throw StateError('Unknown type: $type');
}
