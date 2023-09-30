import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:xyz_utils/http/http.dart';
import 'package:xyz_utils/toast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
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
      ToastService.info("Saved");
    }
  } catch (e, s) {
    ToastService.warn("Failed");
    debugPrintStack(stackTrace: s);
  }
}

class XyzImage extends CachedNetworkImage {
  XyzImage({
    super.key,
    required super.imageUrl,
    super.imageBuilder,
    super.placeholder,
    super.progressIndicatorBuilder,
    super.errorWidget,
    super.fadeOutDuration = const Duration(milliseconds: 1000),
    super.fadeOutCurve = Curves.easeOut,
    super.fadeInDuration = const Duration(milliseconds: 500),
    super.fadeInCurve = Curves.easeIn,
    super.width,
    super.height,
    super.fit,
    super.alignment = Alignment.center,
    super.repeat = ImageRepeat.noRepeat,
    super.matchTextDirection = false,
    super.cacheManager,
    super.useOldImageOnUrlChange = false,
    super.color,
    super.filterQuality = FilterQuality.low,
    super.colorBlendMode,
    super.placeholderFadeInDuration,
    super.memCacheWidth,
    super.memCacheHeight,
    super.cacheKey,
    super.maxWidthDiskCache,
    super.maxHeightDiskCache,
  }) : super(
          httpHeaders: {
            'User-Agent': imageUrl.contains('wikylyu.xyz')
                ? HttpManager.userAgent
                : 'Mozilla/5.0 (Macintosh; Intel Mac OS X 14_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36',
          },
        );
}

class XyzImageProvider extends CachedNetworkImageProvider {
  XyzImageProvider(
    super.url, {
    super.maxHeight,
    super.maxWidth,
    super.scale = 1.0,
    super.errorListener,
    super.cacheManager,
    super.cacheKey,
  }) : super(
          headers: {
            'User-Agent': HttpManager.userAgent,
          },
        );
}
