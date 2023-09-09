import 'package:xyz_utils/admob/config.dart';
import 'package:xyz_utils/http/config.dart';
import 'package:xyz_utils/sharedpref.dart';

class AdmobConfig {
  final String bannerAdID;
  final String openAdID;
  final List<String> keywords;

  const AdmobConfig({
    required this.bannerAdID,
    required this.openAdID,
    required this.keywords,
  });
}

class HttpConfig {
  final String scheme;
  final int port;
  final String host;
  final String prefix;
  const HttpConfig({
    required this.scheme,
    required this.port,
    required this.host,
    required this.prefix,
  });
}

xyzInit(AdmobConfig adconfig, HttpConfig httpconfig) async {
  await SharedPreferencesService.init();
  initAdMob(adconfig.bannerAdID, adconfig.openAdID, adconfig.keywords);
  initHttp(
      httpconfig.scheme, httpconfig.port, httpconfig.host, httpconfig.prefix);
}
