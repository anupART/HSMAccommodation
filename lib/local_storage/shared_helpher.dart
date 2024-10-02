
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPref {
// prevent making instance
  MySharedPref._();

// get storage
  static SharedPreferences? _sharedPreferences;

// STORING KEYS

  static const String _login = 'login';


  /// init get storage services
  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static setStorage(SharedPreferences sharedPreferences) {
    _sharedPreferences = sharedPreferences;
  }

  /// set theme current type as light theme
  static Future<bool>? setLoginStatus(bool lightTheme) =>
      _sharedPreferences?.setBool(_login, lightTheme);

  static bool getLoginStatus() =>
      _sharedPreferences?.getBool(_login) ?? false;


  /// clear all data from shared pref
  static Future<void> clear() async => await _sharedPreferences!.clear();


}
