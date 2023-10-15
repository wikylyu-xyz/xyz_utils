import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:xyz_utils/sharedpref.dart';

class AdmobManager {
  static bool _enabled = true;
  static String _bannerAdID = '';
  static String _openAdID = '';
  static List<String> _adKeywords = [];
  static int _openInterval = 8;

  static removeAds() async {
    _enabled = false;
    await SharedPreferencesService.prefs.setBool("Remove Ads", true);
  }

  disableAds() {
    // temporarily disable ads
    _enabled = false;
  }

  static initialize(String bannerID, String openID, List<String> keywords,
      {int interval = 8, bool children = false}) async {
    _bannerAdID = bannerID;
    _openAdID = openID;
    _adKeywords = keywords;
    _openInterval = interval;
    _enabled = !(SharedPreferencesService.prefs.getBool("Remove Ads") ?? false);

    if (children) {
      final RequestConfiguration requestConfiguration = RequestConfiguration(
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
        maxAdContentRating: MaxAdContentRating.g,
      );
      MobileAds.instance.updateRequestConfiguration(requestConfiguration);
    }
  }

  static bool get isEnabled => _enabled;
  static String get bannerID => _bannerAdID;
  static String get openID => _openAdID;
  static List<String> get keywords => _adKeywords;
  static int get openInterval => _openInterval;
}
