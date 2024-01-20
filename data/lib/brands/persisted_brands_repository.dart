import 'package:collection/collection.dart';
import 'package:data/brands/search_service.dart';
import 'package:data/database/brands_dao.dart';
import 'package:data/database/model/brand_entity.dart';
import 'package:data/database/model/brand_with_organization_entity.dart';
import 'package:data/database/model/organization_entity.dart';
import 'package:domain/brands/model/brand.dart';
import 'package:domain/brands/repository/brands_repository.dart';
import 'package:domain/organizations/model/organization.dart';
import 'package:domain/organizations/model/organization_brand.dart';
import 'package:domain/organizations/model/organization_type.dart';
import 'package:domain/organizations/repository/organizations_repository.dart';
import 'package:domain/storage/key_value_storage.dart';
import 'package:fimber/fimber.dart';

const _KEY_DB_VERSION = 'key_local_db_version';

class PersistedBrandsRepository extends BrandsRepository {
  final KeyValueStorage storage;
  final OrganizationsRepository organizationsRepository;
  final BrandsDao dao;
  final SearchService searchService;

  PersistedBrandsRepository({
    required this.organizationsRepository,
    required this.storage,
    required this.dao,
    required this.searchService,
  });

  @override
  Future<void> loadAllBrands() async {
    final localDbVersion = await storage.getInt(_KEY_DB_VERSION) ?? -1;
    final remoteDbVersion = 1;
    /** Used in real app **/
/*    final remoteDbVersion = await FirebaseDatabase.instance
        .reference()
        .child('db_version')
        .get()
        .then((value) => value.value as int)
        .onError((error, stackTrace) {
      return -1;
    });*/

    if (remoteDbVersion != -1 && localDbVersion < remoteDbVersion) {
      /*
      * 1. Load all organizations
      * 2. Load all brands
      * 3. Load all popular brands
      * */
      // try to load from internet
      try {
        // 0. Get all popular (currently only PETA white)
        final popularFuture = organizationsRepository.getPopular();

        // 1. Get all remote organizations
        final organizations = await organizationsRepository.getAll();

        // 2. Get all remote brands per organization
        final Map<Organization, List<OrganizationBrand>> orgBrands = {};
        for (var o in organizations) {
          orgBrands[o] = await organizationsRepository.getBrandsByType(o.type);
        }

        // 3. Put all brands into one list
        final List<OrganizationBrand> allBrands = [];
        orgBrands.values.forEach((brands) {
          allBrands.addAll(brands);
        });

        // 4. Group brands by their organization, e.g. if both Peta & LP will have
        // 'Dove', then there will only be one 'Dove' in the final list
        final groupedBrandsByOrganization =
            allBrands.groupListsBy((b) => b.title.trim().toLowerCase());

        final brandsWithOrgzEntities = <BrandWithOrganizationEntity>[];
        final brandEntities = <BrandEntity>[];
        final orgzEntities = <OrganizationEntity>[];

        for (var brand in groupedBrandsByOrganization.values) {
          final info = brand[0];
          final brandOrganizations = <Organization>[];
          for (var brandOrganization in brand) {
            final org = organizations.firstWhere(
                (o) => o.type == brandOrganization.organizationType);
            brandOrganizations.add(org);
          }
          final Map<String, Organization> mappedOrgz = {};

          for (var organization in brandOrganizations) {
            mappedOrgz[organization.id] = organization;
          }

          final popular = await popularFuture;
          OrganizationBrand? possiblePopular = popular.firstWhereOrNull(
            (b) =>
                b.title.trim().toLowerCase() == info.title.trim().toLowerCase(),
          );

          brandEntities.add(
            BrandEntity(
                title: info.title,
                description: '',
                popular: possiblePopular != null,
                organizationsIds: mappedOrgz.keys.toList(),
                hasVeganProducts: info.hasVeganProducts,
                logoUrl: possiblePopular?.logoUrl ?? info.logoUrl),
          );

          mappedOrgz.forEach((key, org) {
            brandsWithOrgzEntities.add(
              BrandWithOrganizationEntity(
                  brandTitle: info.title, orgId: org.id),
            );
            orgzEntities.add(
              OrganizationEntity(
                orgId: org.id,
                type: typeToString(org.type),
                brandsCount: org.brandsCount,
                website: org.website,
              ),
            );
          });
        }

        // 5. Put everything into database
        await dao.updateBrands(
            brandEntities.sortedBy((brand) => brand.title),
            brandsWithOrgzEntities.sortedBy((brand) => brand.brandTitle),
            orgzEntities);

        await storage.setInt(_KEY_DB_VERSION, remoteDbVersion);
      } on Exception catch (ex, st) {
        Fimber.e('Failed to load brands', ex: ex, stacktrace: st);
      }
    }
    return Future.value();
  }

  static String typeToString(OrganizationType type) {
    switch (type) {
      case OrganizationType.petaWhite:
        return 'peta_white';
      case OrganizationType.petaBlack:
        return 'peta_black';
      case OrganizationType.bunnySearch:
        return 'bunny_search';
    }
  }

  @override
  Future<List<Brand>> search(String searchTerm) async {
    final allOrgz = await dao.getAllOrganizations();
    final mappedOrgz =
        allOrgz.asMap().map((key, value) => MapEntry(value.orgId, value));
    final allBrandEntities = await dao.getAllBrands();
    final filtered = await searchService.search(
      allBrands: allBrandEntities,
      query: searchTerm,
    );
    return filtered
        .map(
          (b) => Brand(
            title: b.title,
            description: b.description,
            hasVeganProducts: b.hasVeganProducts,
            logoUrl: b.logoUrl,
            organizations: b.organizationsIds.asMap().map((key, o) {
              final org = mappedOrgz[o]!.toOrganization();
              return MapEntry(o, org);
            }),
          ),
        )
        .toList();
  }

  @override
  Future<List<Organization>> getAllOrganizations() async {
    final allOrgz = await dao.getAllOrganizations();
    final mappedOrgz =
        allOrgz.asMap().map((key, value) => MapEntry(value.orgId, value));
    return mappedOrgz.values
        .map(
          (o) => Organization(
            id: o.orgId,
            type: stringToType(o.type)!, // TODO
            brandsCount: o.brandsCount,
            website: o.website,
          ),
        )
        .toList();
  }

  @override
  Future<List<Brand>> getBrandsByOrganizationType(OrganizationType type) async {
    final allOrgz = await dao.getAllOrganizations();
    final mappedOrgz =
        allOrgz.asMap().map((key, value) => MapEntry(value.orgId, value));
    final stringType = typeToString(type);
    final id = allOrgz.firstWhere((o) => o.type == stringType).orgId;
    final allBrandEntities = await dao.getAllOrganizationBrands(id);
    return allBrandEntities
        .map(
          (b) => Brand(
            title: b.title,
            description: b.description,
            hasVeganProducts: b.hasVeganProducts,
            logoUrl: b.logoUrl,
            organizations: b.organizationsIds.asMap().map((key, o) {
              final org = mappedOrgz[o]!.toOrganization();
              return MapEntry(o, org);
            }),
          ),
        )
        .toList();
  }

  static OrganizationType? stringToType(String type) {
    switch (type) {
      case 'peta_white':
        return OrganizationType.petaWhite;
      case 'peta_black':
        return OrganizationType.petaBlack;
      case 'bunny_search':
        return OrganizationType.bunnySearch;
    }
    return null;
  }

  @override
  Future<List<Brand>> getAllPopularBrands() async {
    final allOrgz = await dao.getAllOrganizations();
    final mappedOrgz =
        allOrgz.asMap().map((key, value) => MapEntry(value.orgId, value));
    final allBrandEntities = await dao.getAllPopularBrands();
    return allBrandEntities
        .map(
          (b) => Brand(
            title: b.title,
            description: b.description,
            hasVeganProducts: b.hasVeganProducts,
            logoUrl: b.logoUrl,
            organizations: b.organizationsIds.asMap().map((key, o) {
              final org = mappedOrgz[o]!.toOrganization();
              return MapEntry(o, org);
            }),
          ),
        )
        .toList();
  }
}
