import 'package:xyz_utils/sharedpref.dart';

class AdmobManager {
  static bool enabled = true;

  static removeAds() async {
    enabled = false;
    await SharedPreferencesService.prefs.setBool("Remove Ads", true);
  }

  static init() async {
    enabled = !(SharedPreferencesService.prefs.getBool("Remove Ads") ?? false);
  }

  static bool isEnabled() {
    return enabled;
  }
}
