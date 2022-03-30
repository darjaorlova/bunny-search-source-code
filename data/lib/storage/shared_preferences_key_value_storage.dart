import 'package:shared_preferences/shared_preferences.dart';
import 'package:domain/storage/key_value_storage.dart';

class SharedPreferencesKeyValueStorage implements KeyValueStorage {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesKeyValueStorage(this._sharedPreferences);

  @override
  Future<Set<String>> getKeys() async {
    return _sharedPreferences.getKeys();
  }

  @override
  Future<String?> getString(String key) async {
    return _sharedPreferences.getString(key);
  }

  @override
  Future<void> remove(String key) async {
    await _sharedPreferences.remove(key);
  }

  @override
  Future<void> setString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    return _sharedPreferences.getBool(key);
  }

  @override
  Future<int?> getInt(String key) async {
    return _sharedPreferences.getInt(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _sharedPreferences.setBool(key, value);
  }

  @override
  Future<void> setInt(String key, int value) async {
    await _sharedPreferences.setInt(key, value);
  }
}
