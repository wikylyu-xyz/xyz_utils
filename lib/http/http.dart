import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:xyz_utils/toast.dart';

class ApiException implements Exception {
  final int status;
  final dynamic data;
  const ApiException({required this.status, this.data});
}

class UnauthorizedException implements Exception {
  const UnauthorizedException();
}

class ApiList<T> {
  final int page;
  final int pageSize;
  final int total;
  final List<T> list;

  ApiList({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.list,
  });

  factory ApiList.fromJson(
      Map<String, dynamic> data, T Function(Map<String, dynamic> data) f) {
    final List<T> l = [];
    for (Map<String, dynamic> d in data['list']) {
      l.add(f(d));
    }
    return ApiList(
      list: l,
      page: data['page'],
      pageSize: data['page_size'],
      total: data['total'],
    );
  }
}

class ApiStatus<T> {
  final int status;
  final T data;
  ApiStatus({
    required this.status,
    required this.data,
  });

  factory ApiStatus.fromJson(
      Map<String, dynamic> data, T Function(Map<String, dynamic> data) f) {
    return ApiStatus(
      status: data['status'],
      data: f(data['data']),
    );
  }
}

class HttpManager {
  static String _scheme = '';
  static int? _port = 80;
  static String _host = '';
  static String _prefix = '/api';
  static late PackageInfo _packageInfo;

  static PackageInfo get packageInfo => _packageInfo;

  static initialize(
      String scheme, int? port, String host, String prefix) async {
    _scheme = scheme;
    _port = port;
    _host = host;
    _prefix = prefix;

    _packageInfo = await PackageInfo.fromPlatform();
  }

  static Uri apiuri(String path, {Map<String, dynamic>? queryParams}) {
    return Uri(
      scheme: _scheme,
      port: _port,
      host: _host,
      path: _prefix + path,
      queryParameters: queryParams,
    );
  }

  static dynamic handleResponse(http.Response r) {
    if (r.statusCode >= 400 && r.statusCode < 500) {
      ToastService.instance.error('Client Error');
      throw HttpException('Network Error', uri: r.request?.url);
    } else if (r.statusCode != 200) {
      ToastService.instance.error('Server Error');
      throw HttpException('Network Error', uri: r.request?.url);
    }
    final json = jsonDecode(r.body);
    return json;
  }

  static final _client = http.Client();

  static String get userAgent =>
      '${Platform.operatingSystem}/${Platform.operatingSystemVersion} - ${_packageInfo.appName} ${_packageInfo.version}/${_packageInfo.buildNumber}';

  static Future<dynamic> apiget(String path,
      {Map<String, dynamic>? queryParams}) async {
    final uri = apiuri(path, queryParams: queryParams);
    http.Response r;
    try {
      r = await _client.get(uri, headers: {
        'User-Agent': userAgent,
      }).timeout(const Duration(minutes: 5));
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      ToastService.instance.error('Network Error');
      rethrow;
    }

    return handleResponse(r);
  }

  static Future<dynamic> apipost(String path,
      {Map<String, dynamic>? body}) async {
    final uri = apiuri(path);
    http.Response r;

    try {
      r = await _client
          .post(
            uri,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'User-Agent': userAgent,
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(minutes: 5));
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      ToastService.instance.error('Network Error');
      rethrow;
    }

    return handleResponse(r);
  }

  static Future<dynamic> apiput(String path,
      {Map<String, dynamic>? body}) async {
    final uri = apiuri(path);
    http.Response r;

    try {
      r = await _client
          .put(
            uri,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'User-Agent': userAgent,
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(minutes: 5));
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      ToastService.instance.error('Network Error');
      rethrow;
    }

    return handleResponse(r);
  }

  static Future<dynamic> apidelete(String path,
      {Map<String, dynamic>? queryParams}) async {
    final uri = apiuri(path, queryParams: queryParams);
    http.Response r;
    try {
      r = await _client.delete(uri, headers: {
        'User-Agent': userAgent,
      }).timeout(const Duration(minutes: 5));
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      ToastService.instance.error('Network Error');
      rethrow;
    }

    return handleResponse(r);
  }
}
