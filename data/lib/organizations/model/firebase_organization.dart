import 'package:domain/organizations/model/organization.dart';
import 'package:domain/organizations/model/organization_type.dart';
import 'package:equatable/equatable.dart';

class FirebaseOrganisation extends Equatable {
  final String id;
  final String type;
  final int brandsCount;
  final String website;

  const FirebaseOrganisation({
    required this.id,
    required this.type,
    required this.brandsCount,
    required this.website,
  });

  @override
  List<Object?> get props => [id, type, brandsCount];

  factory FirebaseOrganisation.fromJson(Map<String, dynamic> json) =>
      FirebaseOrganisation(
        id: json['id'] as String,
        type: json['type'] as String,
        brandsCount: json['brandsCount'] as int,
        website: json['website'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'type': type,
        'brandsCount': brandsCount,
        'website': website
      };

  Organization toOrganization() => Organization(
        id: id,
        type: _toOrganizationTypeFromString(type),
        brandsCount: brandsCount,
        website: website,
      );
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
