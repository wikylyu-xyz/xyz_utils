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
  BannerAd? adBanner;

  @override
  void initState() {
    super.initState();

    if (AdmobManager.isEnabled()) {
      adBanner = BannerAd(
        adUnitId: bannerAdID,
        size: AdSize.fullBanner,
        request: AdRequest(
          keywords: adKeywords,
        ),
        listener: const BannerAdListener(),
      );

      adBanner?.load();
    }
  }

  @override
  void dispose() {
    adBanner?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (adBanner == null) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 10),
      alignment: Alignment.center,
      height: adBanner!.size.height.toDouble(),
      child: AdWidget(ad: adBanner!),
    );
  }
}
