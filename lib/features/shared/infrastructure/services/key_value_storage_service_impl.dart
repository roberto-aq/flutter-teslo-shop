import 'package:shared_preferences/shared_preferences.dart';
import 'package:teslo_shop_app/features/shared/infrastructure/services/key_value_storage_service.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  Future<SharedPreferences> getSharedPrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharedPrefs();

    switch (T) {
      case const (int):
        return prefs.getInt(key) as T?;

      case const (String):
        return prefs.getString(key) as T?;

      default:
        // Manejo de tipos no contemplados
        throw UnimplementedError('Tipo no soportado');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharedPrefs();

    return await prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharedPrefs();

    switch (T) {
      case const (int):
        prefs.setInt(key, value as int);
        break;

      case const (String):
        prefs.setString(key, value as String);
        break;

      default:
        // Manejo de tipos no contemplados
        throw UnsupportedError('Tipo no soportado');
    }
  }
}
