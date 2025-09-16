import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:xyz_utils/http/http.dart';
import 'package:xyz_utils/toast.dart';
import 'package:xyz_utils/widget/cache.dart';

downloadImage(String url) async {
  try {
    ToastService.instance.info("Downloading. Please wait");
    final appDocDir = await getTemporaryDirectory();
    final savePath = appDocDir.path + path.basename(url);
    await Dio().download(url, savePath);
    final result = await ImageGallerySaverPlus.saveFile(savePath,
        isReturnPathOfIOS: false);
    if (result != null) {
      ToastService.instance.info("Saved");
    }
  } catch (e, s) {
    ToastService.instance.warn("Failed");
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
          cacheManager: RedirectCacheManager(),
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
