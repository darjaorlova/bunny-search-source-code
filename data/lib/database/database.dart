import 'package:data/database/brands_dao.dart';
import 'package:data/database/model/brand_entity.dart';
import 'package:data/database/model/brand_with_organization_entity.dart';
import 'package:data/database/model/organization_entity.dart';
import 'package:floor/floor.dart';
import 'list_type_converter.dart';

import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

part 'database.g.dart';

@TypeConverters([ListTypeConverter])
@Database(version: 1, entities: [BrandEntity, BrandWithOrganizationEntity, OrganizationEntity])
abstract class BunnySearchDatabase extends FloorDatabase {
  BrandsDao get brandsDao;
}