import 'package:domain/organizations/model/organization.dart';
import 'package:domain/organizations/model/organization_brand.dart';
import 'package:domain/organizations/model/organization_type.dart';

abstract class OrganizationsRepository {
  Future<List<Organization>> getAll();

  Future<Organization> getById(String id);

  Future<Organization> getByType(OrganizationType type);

  Future<List<OrganizationBrand>> getBrandsById(String id);

  Future<List<OrganizationBrand>> getBrandsByType(OrganizationType type);

  Future<List<OrganizationBrand>> getPopular();
}
