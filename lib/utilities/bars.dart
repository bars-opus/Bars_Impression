import 'package:shared_preferences/shared_preferences.dart';

class Bars {
  static const String app_name = "Bars Impression";
  static const String app_color = "#ff1a1a1a";

  static bool isDebugMode = false;

  // * Preferences
  static SharedPreferences? prefs;
  static const String darkModePref = "darkModePref";
}
