// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorBunnySearchDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$BunnySearchDatabaseBuilder databaseBuilder(String name) =>
      _$BunnySearchDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$BunnySearchDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$BunnySearchDatabaseBuilder(null);
}

class _$BunnySearchDatabaseBuilder {
  _$BunnySearchDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$BunnySearchDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$BunnySearchDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<BunnySearchDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$BunnySearchDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$BunnySearchDatabase extends BunnySearchDatabase {
  _$BunnySearchDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  BrandsDao? _brandsDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `brands` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `description` TEXT NOT NULL, `organizationsIds` TEXT NOT NULL, `hasVeganProducts` INTEGER, `logoUrl` TEXT, `popular` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `brands_with_organizations` (`brand_title` TEXT NOT NULL, `org_id` TEXT NOT NULL, PRIMARY KEY (`brand_title`, `org_id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `organizations` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `orgId` TEXT NOT NULL, `type` TEXT NOT NULL, `brandsCount` INTEGER NOT NULL, `website` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BrandsDao get brandsDao {
    return _brandsDaoInstance ??= _$BrandsDao(database, changeListener);
  }
}

class _$BrandsDao extends BrandsDao {
  _$BrandsDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _brandEntityInsertionAdapter = InsertionAdapter(
            database,
            'brands',
            (BrandEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'description': item.description,
                  'organizationsIds':
                      _listTypeConverter.encode(item.organizationsIds),
                  'hasVeganProducts': item.hasVeganProducts == null
                      ? null
                      : (item.hasVeganProducts! ? 1 : 0),
                  'logoUrl': item.logoUrl,
                  'popular': item.popular ? 1 : 0
                }),
        _brandWithOrganizationEntityInsertionAdapter = InsertionAdapter(
            database,
            'brands_with_organizations',
            (BrandWithOrganizationEntity item) => <String, Object?>{
                  'brand_title': item.brandTitle,
                  'org_id': item.orgId
                }),
        _organizationEntityInsertionAdapter = InsertionAdapter(
            database,
            'organizations',
            (OrganizationEntity item) => <String, Object?>{
                  'id': item.id,
                  'orgId': item.orgId,
                  'type': item.type,
                  'brandsCount': item.brandsCount,
                  'website': item.website
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BrandEntity> _brandEntityInsertionAdapter;

  final InsertionAdapter<BrandWithOrganizationEntity>
      _brandWithOrganizationEntityInsertionAdapter;

  final InsertionAdapter<OrganizationEntity>
      _organizationEntityInsertionAdapter;

  @override
  Future<List<BrandEntity>> getAllBrands() async {
    return _queryAdapter.queryList('SELECT * FROM brands',
        mapper: (Map<String, Object?> row) => BrandEntity(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            organizationsIds:
                _listTypeConverter.decode(row['organizationsIds'] as String),
            hasVeganProducts: row['hasVeganProducts'] == null
                ? null
                : (row['hasVeganProducts'] as int) != 0,
            logoUrl: row['logoUrl'] as String?,
            popular: (row['popular'] as int) != 0));
  }

  @override
  Future<List<BrandEntity>> getAllPopularBrands() async {
    return _queryAdapter.queryList('SELECT * FROM brands WHERE popular = 1',
        mapper: (Map<String, Object?> row) => BrandEntity(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            organizationsIds:
                _listTypeConverter.decode(row['organizationsIds'] as String),
            hasVeganProducts: row['hasVeganProducts'] == null
                ? null
                : (row['hasVeganProducts'] as int) != 0,
            logoUrl: row['logoUrl'] as String?,
            popular: (row['popular'] as int) != 0));
  }

  @override
  Future<List<OrganizationEntity>> getAllOrganizations() async {
    return _queryAdapter.queryList('SELECT * FROM organizations',
        mapper: (Map<String, Object?> row) => OrganizationEntity(
            id: row['id'] as int?,
            orgId: row['orgId'] as String,
            type: row['type'] as String,
            brandsCount: row['brandsCount'] as int,
            website: row['website'] as String));
  }

  @override
  Future<List<BrandEntity>> getAllOrganizationBrands(String orgId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM brands WHERE title IN (SELECT brand_title FROM brands_with_organizations WHERE org_id = ?1)',
        mapper: (Map<String, Object?> row) => BrandEntity(id: row['id'] as int?, title: row['title'] as String, description: row['description'] as String, organizationsIds: _listTypeConverter.decode(row['organizationsIds'] as String), hasVeganProducts: row['hasVeganProducts'] == null ? null : (row['hasVeganProducts'] as int) != 0, logoUrl: row['logoUrl'] as String?, popular: (row['popular'] as int) != 0),
        arguments: [orgId]);
  }

  @override
  Future<List<BrandEntity>> findBrands(String query) async {
    return _queryAdapter.queryList('SELECT * FROM brands WHERE title LIKE ?1',
        mapper: (Map<String, Object?> row) => BrandEntity(
            id: row['id'] as int?,
            title: row['title'] as String,
            description: row['description'] as String,
            organizationsIds:
                _listTypeConverter.decode(row['organizationsIds'] as String),
            hasVeganProducts: row['hasVeganProducts'] == null
                ? null
                : (row['hasVeganProducts'] as int) != 0,
            logoUrl: row['logoUrl'] as String?,
            popular: (row['popular'] as int) != 0),
        arguments: [query]);
  }

  @override
  Future<void> deleteAllOrganizations() async {
    await _queryAdapter.queryNoReturn('DELETE FROM organizations');
  }

  @override
  Future<void> deleteAllBrands() async {
    await _queryAdapter.queryNoReturn('DELETE FROM brands');
  }

  @override
  Future<void> deleteAllBrandsWithOrganizations() async {
    await _queryAdapter.queryNoReturn('DELETE FROM brands_with_organizations');
  }

  @override
  Future<void> insertBrands(List<BrandEntity> brands) async {
    await _brandEntityInsertionAdapter.insertList(
        brands, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertBrandsWithOrganizations(
      List<BrandWithOrganizationEntity> brands) async {
    await _brandWithOrganizationEntityInsertionAdapter.insertList(
        brands, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertOrganizations(
      List<OrganizationEntity> organizations) async {
    await _organizationEntityInsertionAdapter.insertList(
        organizations, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateBrands(
      List<BrandEntity> brands,
      List<BrandWithOrganizationEntity> brandsWithOrgz,
      List<OrganizationEntity> orgz) async {
    if (database is sqflite.Transaction) {
      await super.updateBrands(brands, brandsWithOrgz, orgz);
    } else {
      await (database as sqflite.Database)
          .transaction<void>((transaction) async {
        final transactionDatabase = _$BunnySearchDatabase(changeListener)
          ..database = transaction;
        await transactionDatabase.brandsDao
            .updateBrands(brands, brandsWithOrgz, orgz);
      });
    }
  }
}

// ignore_for_file: unused_element
final _listTypeConverter = ListTypeConverter();
