import 'package:xyz_utils/admob/admob_manager.dart';
import 'package:xyz_utils/http/http.dart';
import 'package:xyz_utils/sharedpref.dart';

class AdmobConfig {
  final String bannerAdID;
  final String openAdID;
  final List<String> keywords;
  final int openInterval;
  final bool children;

  const AdmobConfig({
    required this.bannerAdID,
    required this.openAdID,
    required this.keywords,
    this.openInterval = 8,
    this.children = false,
  });
}

class HttpConfig {
  final String scheme;
  final int? port;
  final String host;
  final String prefix;
  final bool redirect;
  const HttpConfig({
    required this.scheme,
    required this.port,
    required this.host,
    required this.prefix,
    this.redirect = false,
  });
}

xyzInit(AdmobConfig adconfig, HttpConfig httpconfig) async {
  await SharedPreferencesService.initialize();
  await AdmobManager.initialize(
    adconfig.bannerAdID,
    adconfig.openAdID,
    adconfig.keywords,
    interval: adconfig.openInterval,
    children: adconfig.children,
  );
  await HttpManager.initialize(
    httpconfig.scheme,
    httpconfig.port,
    httpconfig.host,
    httpconfig.prefix,
  );
}
