import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:xyz_utils/sharedpref.dart';

final InAppReview inAppReview = InAppReview.instance;

checkAndRequestReview() async {
  final count = SharedPreferencesService.prefs.getInt("open_count") ?? 0;
  final showed =
      SharedPreferencesService.prefs.getBool("show_reviewed") ?? false;
  if (count >= 8 && !showed) {
    try {
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      }
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
    } finally {
      SharedPreferencesService.prefs.setBool("show_reviewed", true);
    }
  }
  SharedPreferencesService.prefs.setInt("open_count", count + 1);
}
