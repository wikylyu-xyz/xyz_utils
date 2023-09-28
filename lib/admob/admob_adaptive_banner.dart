import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:xyz_utils/admob/admob_manager.dart';

class AdmobAdaptiveBanner extends StatefulWidget {
  const AdmobAdaptiveBanner({Key? key}) : super(key: key);

  @override
  createState() => _AdmobAdaptiveBannerState();
}

class _AdmobAdaptiveBannerState extends State<AdmobAdaptiveBanner> {
  BannerAd? _anchoredAdaptiveAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (AdmobManager.isEnabled) {
      _loadAd();
    }
  }

  Future<void> _loadAd() async {
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate());

    if (size == null) {
      debugPrint('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: AdmobManager.bannerID,
      size: size,
      request: AdManagerAdRequest(
        keywords: AdmobManager.keywords,
      ),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('$ad loaded: ${ad.responseInfo}');
          setState(() {
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('Anchored adaptive banner failedToLoad: $error');
          ad.dispose();
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    if (_anchoredAdaptiveAd == null) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      alignment: Alignment.center,
      width: _anchoredAdaptiveAd!.size.width.toDouble(),
      height: _anchoredAdaptiveAd!.size.height.toDouble(),
      child: _isLoaded ? AdWidget(ad: _anchoredAdaptiveAd!) : null,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }
}
