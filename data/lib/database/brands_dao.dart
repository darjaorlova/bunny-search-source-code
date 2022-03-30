import 'package:data/database/model/brand_entity.dart';
import 'package:data/database/model/brand_with_organization_entity.dart';
import 'package:data/database/model/organization_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class BrandsDao {
  @Query('SELECT * FROM brands')
  Future<List<BrandEntity>> getAllBrands();

  @Query('SELECT * FROM brands WHERE popular = 1')
  Future<List<BrandEntity>> getAllPopularBrands();

  @Query('SELECT * FROM organizations')
  Future<List<OrganizationEntity>> getAllOrganizations();

  @Query(
      'SELECT * FROM brands WHERE title IN (SELECT brand_title FROM brands_with_organizations WHERE org_id = :orgId)')
  Future<List<BrandEntity>> getAllOrganizationBrands(String orgId);

  @Query('SELECT * FROM brands WHERE title LIKE :query')
  Future<List<BrandEntity>> findBrands(String query);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertBrands(List<BrandEntity> brands);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertBrandsWithOrganizations(
      List<BrandWithOrganizationEntity> brands);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertOrganizations(List<OrganizationEntity> organizations);

  @Query('DELETE FROM organizations')
  Future<void> deleteAllOrganizations();

  @Query('DELETE FROM brands')
  Future<void> deleteAllBrands();

  @Query('DELETE FROM brands_with_organizations')
  Future<void> deleteAllBrandsWithOrganizations();

  @transaction
  Future<void> updateBrands(
      List<BrandEntity> brands,
      List<BrandWithOrganizationEntity> brandsWithOrgz,
      List<OrganizationEntity> orgz) {
    deleteAllBrands();
    deleteAllOrganizations();
    deleteAllBrandsWithOrganizations();
    insertBrands(brands);
    insertOrganizations(orgz);
    insertBrandsWithOrganizations(brandsWithOrgz);
    return Future.value();
  }
}
