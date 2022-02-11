import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Storage? _storage;

  final SharedPreferences _prefs;

  Storage._(this._prefs);

  static Future<Storage> get() async {
    if (_storage == null) {
      var prefs = await SharedPreferences.getInstance();
      _storage = Storage._(prefs);
    }
    return _storage!;
  }

  String? getString(String key, [String? defaultValue]) {
    return _prefs.getString("GLOBAL_STRING_$key") ?? defaultValue;
  }

  Future<bool> setString(String key, String value) {
    return _prefs.setString("GLOBAL_STRING_$key", value);
  }

  int getInt(String key) {
    return _prefs.getInt("GLOBAL_INT_$key")??0;
  }

  Future<bool> setInt(String key, int value) {
    return _prefs.setInt("GLOBAL_INT_$key", value);
  }

  double getDouble(String key) {
    return _prefs.getDouble("GLOBAL_DOUBLE_$key")??0;
  }

  Future<bool> setDouble(String key, double value) {
    return _prefs.setDouble("GLOBAL_DOUBLE_$key", value);
  }

  String? getUserString(String key) {
    String? id = getString("CURRENT_USER_ID");
    if (id == null) {
      throw ArgumentError("CURRENT USER ID IS NULL!");
    }
    return _prefs.getString("USER_${id}_$key");
  }

  Future<bool> setUserString(String key, String value) {
    String? id = getString("CURRENT_USER_ID");
    if (id == null) {
      throw ArgumentError("CURRENT USER ID IS NULL!");
    }
    return _prefs.setString("USER_${id}_$key", value);
  }

  double getUserDouble(String key) {
    String? id = getString("CURRENT_USER_ID");
    if (id == null) {
      throw ArgumentError("CURRENT USER ID IS NULL!");
    }
    return _prefs.getDouble("USER_${id}_$key")??0;
  }

  Future<bool> setUserDouble(String key, double value) {
    String? id = getString("CURRENT_USER_ID");
    if (id == null) {
      throw ArgumentError("CURRENT USER ID IS NULL!");
    }
    return _prefs.setDouble("USER_${id}_$key", value);
  }

  int getUserInt(String key) {
    String? id = getString("CURRENT_USER_ID");
    if (id == null) {
      throw ArgumentError("CURRENT USER ID IS NULL!");
    }
    return _prefs.getInt("USER_${id}_$key")??0;
  }

  Future<bool> setUserInt(String key, int value) {
    String? id = getString("CURRENT_USER_ID");
    if (id == null) {
      throw ArgumentError("CURRENT USER ID IS NULL!");
    }
    return _prefs.setInt("USER_${id}_$key", value);
  }

  Future<bool> saveUser(String id, String token) async {
    var result = await setString("CURRENT_USER_ID", id);
    result &= await setUserString("TOKEN", token);
    return result;
  }

  String? getUserToken() {
    return getUserString("TOKEN");
  }

  void clearUserData() {
    _prefs.getKeys().forEach((it) async {
      if (it.contains("USER_")) {
        await _prefs.remove(it);
      }
    });
  }
}