import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// TODO refactor
// ignore: implementation_imports
import 'package:flutter_cache_manager/src/storage/file_system/file_system_io.dart';

class OneYearImageCacheManager {
  static const _key = 'bunny_image_cache_key';
  static CacheManager instance = CacheManager(
    Config(
      _key,
      stalePeriod: const Duration(days: 365),
      maxNrOfCacheObjects: 5000,
      repo: CacheObjectProvider(databaseName: _key),
      fileSystem: IOFileSystem(_key),
      fileService: HttpFileService(),
    ),
  );
}