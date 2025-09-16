import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

/// 自定义 CacheManager，自动跟随 301/302/307/308 重定向
class RedirectCacheManager extends CacheManager {
  static const key = "redirectCache";

  RedirectCacheManager()
      : super(
          Config(
            key,
            fileService: RedirectFileService(),
          ),
        );
}

/// 自定义 FileService 处理 HTTP 重定向
class RedirectFileService extends FileService {
  /// 最大重定向次数，避免死循环
  final int maxRedirects;

  RedirectFileService({this.maxRedirects = 5});

  @override
  Future<FileServiceResponse> get(String url,
      {Map<String, String>? headers}) async {
    final client = http.Client();
    int redirectCount = 0;
    Uri uri = Uri.parse(url);
    http.Response response;

    while (true) {
      response = await client.get(uri, headers: headers);

      if (_isRedirect(response.statusCode)) {
        final location = response.headers['location'];
        if (location == null || redirectCount >= maxRedirects) {
          break; // 没有 Location 或超过最大重定向次数
        }

        uri = Uri.parse(location.startsWith("http")
            ? location
            : "${uri.scheme}://${uri.host}$location"); // 相对路径处理
        redirectCount++;
        continue;
      }

      break;
    }

    final streamedResponse = http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
      request: response.request,
      reasonPhrase: response.reasonPhrase,
    );
    return HttpGetResponse(streamedResponse);
  }

  bool _isRedirect(int statusCode) {
    return statusCode == 301 ||
        statusCode == 302 ||
        statusCode == 303 ||
        statusCode == 307 ||
        statusCode == 308;
  }
}
