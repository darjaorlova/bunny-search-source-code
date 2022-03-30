import 'package:domain/organizations/model/organization.dart';
import 'package:domain/organizations/model/organization_type.dart';
import 'package:equatable/equatable.dart';
import 'package:floor/floor.dart';

@Entity(tableName: 'organizations')
class OrganizationEntity extends Equatable {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String orgId;
  final String type;
  final int brandsCount;
  final String website;

  OrganizationEntity(
      {this.id,
      required this.orgId,
      required this.type,
      required this.brandsCount,
      required this.website});

  Organization toOrganization() {
    return Organization(
        id: orgId,
        type: _typeFromString(type),
        brandsCount: brandsCount,
        website: website);
  }

  @override
  List<Object?> get props => [id, orgId, type, brandsCount, website];
}

OrganizationType _typeFromString(String type) {
  switch (type) {
    case 'peta_white':
      return OrganizationType.PetaWhite;
    case 'peta_black':
      return OrganizationType.PetaBlack;
    case 'bunny_search':
      return OrganizationType.BunnySearch;
  }
  throw StateError('Unknown type: $type');
}
