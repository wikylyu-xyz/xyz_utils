import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:xyz_utils/http/config.dart';
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

Uri apiuri(String path, {Map<String, dynamic>? queryParams}) {
  return Uri(
    scheme: httpScheme,
    port: httpPort,
    host: httpHost,
    path: apiPrefix + path,
    queryParameters: queryParams,
  );
}

dynamic handleResponse(http.Response r) {
  if (r.statusCode >= 400 && r.statusCode < 500) {
    ToastService.error('Client Error');
    throw HttpException('Network Error', uri: r.request?.url);
  } else if (r.statusCode != 200) {
    ToastService.error('Server Error');
    throw HttpException('Network Error', uri: r.request?.url);
  }
  final json = jsonDecode(r.body);
  return json;
}

final _client = http.Client();

Future<dynamic> apiget(String path, {Map<String, dynamic>? queryParams}) async {
  final uri = apiuri(path, queryParams: queryParams);
  http.Response r;
  try {
    r = await _client.get(uri, headers: {}).timeout(const Duration(minutes: 5));
  } catch (e) {
    ToastService.error('Network Error');
    rethrow;
  }

  return handleResponse(r);
}

Future<dynamic> apipost(String path, {Map<String, dynamic>? body}) async {
  final uri = apiuri(path);
  http.Response r;

  try {
    r = await _client
        .post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(minutes: 5));
  } catch (_) {
    ToastService.error('Network Error');
    rethrow;
  }

  return handleResponse(r);
}

Future<dynamic> apiput(String path, {Map<String, dynamic>? body}) async {
  final uri = apiuri(path);
  http.Response r;

  try {
    r = await _client
        .put(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(minutes: 5));
  } catch (e) {
    ToastService.error('Network Error');
    rethrow;
  }

  return handleResponse(r);
}

Future<dynamic> apidelete(String path,
    {Map<String, dynamic>? queryParams}) async {
  final uri = apiuri(path, queryParams: queryParams);
  http.Response r;
  try {
    r = await _client
        .delete(
          uri,
        )
        .timeout(const Duration(minutes: 5));
  } catch (e) {
    ToastService.error('Network Error');
    rethrow;
  }

  return handleResponse(r);
}
