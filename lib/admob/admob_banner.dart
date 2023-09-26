import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:xyz_utils/admob/admob_manager.dart';
import 'package:xyz_utils/admob/config.dart';

class AdmobBanner extends StatefulWidget {
  const AdmobBanner({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AdmobBannerState();
}

class _AdmobBannerState extends State<AdmobBanner> {
  AdManagerBannerAd? adBanner;
  bool loaded = false;

  @override
  void initState() {
    super.initState();

    if (AdmobManager.isEnabled()) {
      adBanner = AdManagerBannerAd(
        adUnitId: bannerAdID,
        sizes: [AdSize.fullBanner],
        request: AdManagerAdRequest(
          keywords: adKeywords,
        ),
        listener: AdManagerBannerAdListener(
          onAdLoaded: (ad) => setState(() {
            loaded = true;
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
  }

  @override
  Widget build(BuildContext context) {
    if (adBanner == null || !loaded) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      alignment: Alignment.center,
      width: AdSize.fullBanner.width.toDouble(),
      height: AdSize.fullBanner.height.toDouble(),
      child: AdWidget(ad: adBanner!),
    );
  }
}
