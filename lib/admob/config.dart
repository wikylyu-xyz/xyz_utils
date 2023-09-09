import 'package:xyz_utils/admob/admob_manager.dart';

String bannerAdID = "";
String openAdID = "";
List<String> adKeywords = [];

initAdmob(String bannerID, String openID, List<String> keywords) async {
  bannerAdID = bannerID;
  openAdID = openID;
  adKeywords = keywords;

  await AdmobManager.init();
}
