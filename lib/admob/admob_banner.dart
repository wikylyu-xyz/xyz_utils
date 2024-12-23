import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:xyz_utils/admob/admob_manager.dart';

class AdmobBanner extends StatefulWidget {
  static bool isShowing = false;

  const AdmobBanner({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AdmobBannerState();
}

class _AdmobBannerState extends State<AdmobBanner> {
  AdManagerBannerAd? adBanner;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    AdmobBanner.isShowing = true;

    if (AdmobManager.isEnabled) {
      adBanner = AdManagerBannerAd(
        adUnitId: AdmobManager.bannerID,
        sizes: [AdSize.banner],
        request: AdManagerAdRequest(
          keywords: AdmobManager.keywords,
        ),
        listener: AdManagerBannerAdListener(
          onAdLoaded: (ad) => setState(() {
            isLoaded = true;
          }),
          onAdFailedToLoad: (ad, error) => ad.dispose(),
        ),
      )..load();
    }
  }

  @override
  void dispose() {
    adBanner?.dispose();
    super.dispose();
    AdmobBanner.isShowing = false;
  }

  @override
  Widget build(BuildContext context) {
    if (adBanner == null) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      alignment: Alignment.center,
      width: double.infinity,
      height: AdSize.banner.height.toDouble(),
      child: isLoaded ? AdWidget(ad: adBanner!) : null,
    );
  }
}
