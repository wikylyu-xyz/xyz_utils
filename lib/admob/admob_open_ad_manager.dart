import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:xyz_utils/admob/admob_manager.dart';

class AdmobOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  bool isFirstAd = true;
  DateTime _lastShownTime = DateTime.now().add(
    Duration(
      minutes: 2 - AdmobManager.openInterval,
    ),
  );

  void loadAd() {
    if (!AdmobManager.isEnabled) {
      return;
    }

    AppOpenAd.load(
      adUnitId: AdmobManager.openID,
      orientation: AppOpenAd.orientationPortrait,
      request: AdRequest(
        keywords: AdmobManager.keywords,
      ),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AppOpenAd loaded');
          _appOpenAd = ad;
        },
        onAdFailedToLoad: (error) {
          debugPrint('AppOpenAd failed to load: $error');
        },
      ),
    );
  }

  /// Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() {
    if (!AdmobManager.isEnabled) {
      return;
    }

    if (!isAdAvailable) {
      debugPrint('Tried to show ad before available.');
      loadAd();
      return;
    }
    final diff = DateTime.now().difference(_lastShownTime);
    if (diff < Duration(minutes: AdmobManager.openInterval)) {
      debugPrint('Ad Frequency limit: ${diff.inSeconds}s');
      return;
    }
    if (_isShowingAd) {
      debugPrint('Tried to show ad while already showing an ad.');
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        _lastShownTime = DateTime.now();
        debugPrint('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      },
    );
    _appOpenAd!.show();
  }
}

class AdmobLifecycleReactor extends WidgetsBindingObserver {
  final AdmobOpenAdManager admobOpenAdManager;

  AdmobLifecycleReactor({required this.admobOpenAdManager});

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    // Try to show an app open ad if the app is being resumed and
    // we're not already showing an app open ad.
    if (state == AppLifecycleState.resumed) {
      admobOpenAdManager.showAdIfAvailable();
    }
  }
}
