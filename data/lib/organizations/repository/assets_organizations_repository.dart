import 'package:data/organizations/model/firebase_organization.dart';
import 'package:data/organizations/model/firebase_organization_brand.dart';
import 'package:domain/organizations/model/organization.dart';
import 'package:domain/organizations/model/organization_brand.dart';
import 'package:domain/organizations/model/organization_type.dart';
import 'package:domain/organizations/repository/organizations_repository.dart';

class AssetsOrganizationsRepository extends OrganizationsRepository {
  final dynamic databaseJson;

  AssetsOrganizationsRepository({required this.databaseJson});

  @override
  Future<List<Organization>> getAll() async {
    final organizations = databaseJson['organizations'] as Map<String, dynamic>;
    return organizations.values
        .map<Organization>((e) =>
            FirebaseOrganisation.fromJson(Map<String, dynamic>.from(e))
                .toOrganization())
        .toList();
  }

  @override
  Future<List<OrganizationBrand>> getBrandsById(String id) {
    // TODO: implement getBrandsById
    throw UnimplementedError();
  }

  @override
  Future<List<OrganizationBrand>> getBrandsByType(OrganizationType type) async {
    var mappedType = '';
    switch (type) {
      case OrganizationType.PetaWhite:
        mappedType = 'peta_white';
        break;
      case OrganizationType.PetaBlack:
        mappedType = 'peta_black';
        break;
      case OrganizationType.BunnySearch:
        mappedType = 'bunny_search';
        break;
    }
    final brands = databaseJson['brands'][mappedType] as Map<String, dynamic>;
    return brands.values
        .map<OrganizationBrand>((e) =>
            FirebaseOrganizationBrand.fromJson(Map<String, dynamic>.from(e))
                .toOrganizationBrand())
        .toList();
  }

  @override
  Future<Organization> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<Organization> getByType(OrganizationType type) {
    // TODO: implement getByType
    throw UnimplementedError();
  }

  @override
  Future<List<OrganizationBrand>> getPopular() async {
    final brands = databaseJson['brands']['popular'] as Map<String, dynamic>;
    return brands.values
        .map<OrganizationBrand>((e) =>
            FirebaseOrganizationBrand.fromJson(Map<String, dynamic>.from(e))
                .toOrganizationBrand())
        .toList();
  }
}
