import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:xyz_utils/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

downloadImage(String url) async {
  try {
    ToastService.info("Downloading. Please wait");
    final appDocDir = await getTemporaryDirectory();
    final savePath = appDocDir.path + path.basename(url);
    await Dio().download(url, savePath);
    final result =
        await ImageGallerySaver.saveFile(savePath, isReturnPathOfIOS: true);
    if (result != null) {
      ToastService.info("Downloaded");
    }
  } catch (e, s) {
    ToastService.warn("Failed");
    debugPrintStack(stackTrace: s);
  }
}
