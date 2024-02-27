import 'dart:async';
import 'dart:convert';

import 'package:bunny_search/analytics/bloc_error_delegate.dart';
import 'package:bunny_search/app.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data/brands/persisted_brands_repository.dart';
import 'package:data/organizations/repository/assets_organizations_repository.dart';
import 'package:data/storage/shared_preferences_key_value_storage.dart';
import 'package:domain/brands/repository/brands_repository.dart';
import 'package:domain/organizations/repository/organizations_repository.dart';
import 'package:domain/storage/key_value_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data/database/database.dart';
import 'package:bunny_search/generated/codegen_loader.g.dart';

const GEMINI_API_KEY = String.fromEnvironment(
  'GEMINI_API_KEY',
  defaultValue: '',
);

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    CachedNetworkImage.logLevel = CacheManagerLogLevel.warning;

    Bloc.observer = BlocErrorObserver();

    EquatableConfig.stringify = true;

    /** Used in real app **/
    //await Firebase.initializeApp();

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    /** Used in real app: FirebaseOrganizationsRepository **/
    final orgRepo = AssetsOrganizationsRepository(
        databaseJson: json.decode(await rootBundle
            .loadString('resources/database/bunny-search-database.json')));
    final sharedPrefs = await SharedPreferences.getInstance();

    final database = await initDatabase();

    await _initCrashlytics();

    _initFimber();

    final keyValueStorage = SharedPreferencesKeyValueStorage(sharedPrefs);

    runApp(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<OrganizationsRepository>(
            create: (context) => orgRepo,
          ),
          RepositoryProvider<KeyValueStorage>(
            create: (context) => keyValueStorage,
          ),
          RepositoryProvider<BrandsRepository>(
            create: (context) => PersistedBrandsRepository(
              organizationsRepository: orgRepo,
              storage: keyValueStorage,
              dao: database.brandsDao,
            ),
          )
        ],
        child: EasyLocalization(
          fallbackLocale: const Locale('ru'),
          useOnlyLangCode: true,
          path: 'resources/langs',
          supportedLocales: const [Locale('ru'), Locale('en')],
          assetLoader: const CodegenLoader(),
          child: const App(),
        ),
      ),
    );
  }, (error, stackTrace) {
    /** Used in real app **/
    //FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

Future<void> _initCrashlytics() async {
  /** Used in real app **/
/*  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(kReleaseMode);

  final Function? originalOnError = FlutterError.onError;
  FlutterError.onError = (FlutterErrorDetails errorDetails) async {
    await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    // Forward to original handler.
    if (originalOnError != null) {
      originalOnError(errorDetails);
    }
  };*/
}

void _initFimber() {
  if (kReleaseMode) {
    /** Used in real app **/
    //Fimber.plantTree(CrashlyticsFimberTree());
  } else {
    Fimber.plantTree(DebugTree());
  }
}

Future<BunnySearchDatabase> initDatabase() async {
  final database =
      await $FloorBunnySearchDatabase.databaseBuilder('database.db').build();
  return database;
}
