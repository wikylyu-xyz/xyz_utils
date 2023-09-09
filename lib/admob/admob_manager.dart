import 'package:shared_preferences/shared_preferences.dart';

class AdmobManager {
  static bool enabled = true;

  static removeAds() async {
    enabled = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("Remove Ads", true);
  }

  static init() async {
    final prefs = await SharedPreferences.getInstance();
    enabled = !(prefs.getBool("Remove Ads") ?? false);
  }

  static bool isEnabled() {
    return enabled;
  }
}
