import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:xyz_utils/sharedpref.dart';

final InAppReview inAppReview = InAppReview.instance;

class ReviewService {
  ReviewService._internal();
  static final ReviewService instance = ReviewService._internal();

  checkAndRequestReview({int openCount = 8}) async {
    final count = SharedPreferencesService.prefs.getInt("open_count") ?? 0;
    final showed =
        SharedPreferencesService.prefs.getBool("show_reviewed") ?? false;
    if (count >= openCount && !showed) {
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

  openStoreListing() async {
    inAppReview.openStoreListing();
  }
}
