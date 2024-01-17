import 'package:data/organizations/model/firebase_organization.dart';
import 'package:data/organizations/model/firebase_organization_brand.dart';
import 'package:domain/organizations/model/organization.dart';
import 'package:domain/organizations/model/organization_brand.dart';
import 'package:domain/organizations/model/organization_type.dart';
import 'package:domain/organizations/repository/organizations_repository.dart';
import 'package:fimber/fimber.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseOrganizationsRepository extends OrganizationsRepository {
  @override
  Future<List<Organization>> getAll() async {
    try {
      final organizations = await FirebaseDatabase.instance
          .reference()
          .child('organizations')
          .once()
          .then(
            (value) => List<dynamic>.from(
              Map<String, dynamic>.from(value.value).values,
            )
                .map(
                  (e) => FirebaseOrganisation.fromJson(
                    Map<String, dynamic>.from(e),
                  ).toOrganization(),
                )
                .toList(),
          );
      return organizations;
    } catch (ex, st) {
      Fimber.e('Failed to load organizations', ex: ex, stacktrace: st);
      rethrow;
    }
  }

  @override
  Future<Organization> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<Organization> getByType(OrganizationType type) async {
    final orgz = await getAll();
    return orgz.firstWhere((element) => element.type == type);
  }

  @override
  Future<List<OrganizationBrand>> getBrandsById(String id) async {
    try {
      final brands = await FirebaseDatabase.instance
          .reference()
          .child('brands')
          .child(id)
          .once()
          .then(
            (value) => List<dynamic>.from(
              Map<String, dynamic>.from(value.value).values,
            )
                .map(
                  (e) => FirebaseOrganizationBrand.fromJson(
                    Map<String, dynamic>.from(e),
                  ).toOrganizationBrand(),
                )
                .toList(),
          );
      return brands;
    } catch (ex, st) {
      Fimber.e('Failed to load brands', ex: ex, stacktrace: st);
      rethrow;
    }
  }

  @override
  Future<List<OrganizationBrand>> getBrandsByType(OrganizationType type) async {
    var mappedType = '';
    switch (type) {
      case OrganizationType.petaWhite:
        mappedType = 'peta_white';
        break;
      case OrganizationType.petaBlack:
        mappedType = 'peta_black';
        break;
      case OrganizationType.bunnySearch:
        mappedType = 'bunny_search';
        break;
    }
    try {
      final brands = await FirebaseDatabase.instance
          .reference()
          .child('brands')
          .child(mappedType)
          .once()
          .then(
            (value) => List<dynamic>.from(
              Map<String, dynamic>.from(value.value).values,
            )
                .map(
                  (e) => FirebaseOrganizationBrand.fromJson(
                    Map<String, dynamic>.from(e),
                  ).toOrganizationBrand(),
                )
                .toList(),
          );
      return brands;
    } catch (ex, st) {
      Fimber.e('Failed to load brands', ex: ex, stacktrace: st);
      rethrow;
    }
  }

  @override
  Future<List<OrganizationBrand>> getPopular() async {
    try {
      final brands = await FirebaseDatabase.instance
          .reference()
          .child('brands')
          .child('popular')
          .once()
          .then(
            (value) => List<dynamic>.from(
              Map<String, dynamic>.from(value.value).values,
            )
                .map(
                  (e) => FirebaseOrganizationBrand.fromJson(
                    Map<String, dynamic>.from(e),
                  ).toOrganizationBrand(),
                )
                .toList(),
          );
      return brands;
    } catch (ex, st) {
      Fimber.e('Failed to load brands', ex: ex, stacktrace: st);
      rethrow;
    }
  }
}
