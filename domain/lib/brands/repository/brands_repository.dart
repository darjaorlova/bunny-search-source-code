import 'package:domain/brands/model/brand.dart';
import 'package:domain/organizations/model/organization.dart';
import 'package:domain/organizations/model/organization_type.dart';

abstract class BrandsRepository {
  Future<void> loadAllBrands();
  Future<List<Brand>> search(String searchTerm);
  Future<List<Organization>> getAllOrganizations();
  Future<List<Brand>> getBrandsByOrganizationType(OrganizationType type);
  Future<List<Brand>> getAllPopularBrands();
}