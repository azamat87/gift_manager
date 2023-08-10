import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceData {

  static const _tokenKey = "token_key";

  static SharedPreferenceData? _instance;

  factory SharedPreferenceData.getInstance() => _instance ??= SharedPreferenceData._internal();

  SharedPreferenceData._internal();

  Future<bool> setToken(final String? token) => setItem(key: _tokenKey, item: token);

  Future<String?> getToken() => getItem(_tokenKey);

  Future<bool> setItem({required String key, required String item}) async {
    final sp = await SharedPreferences.getInstance();
    final result = sp.setString(key, item ?? "");
    return result;
  }

  Future<String?> getItem(
      final String key
      ) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

}