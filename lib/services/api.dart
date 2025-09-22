import 'package:care/models/enums/storage_key.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum HttpMethod { get, post, put, patch, delete }

enum TokenType { none, access, temporary }

class API {
  static final API _instance = API._internal();
  factory API() => _instance;

  static String baseUrl = dotenv.env['BASE_URL']!;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final Dio dio = Dio();

  API._internal() {
    dio.options = BaseOptions(baseUrl: baseUrl);
    dio.interceptors.add(CustomInterceptor(storage, baseUrl, dio));
    dio.interceptors.add(LoggerInterceptor());
  }

  Future<Response> req(
    String path, {
    required HttpMethod method,
    Map<String, dynamic>? query,
    Object? body,
    int version = 1,
    TokenType tokenType = TokenType.access,
  }) {
    path = '/v$version$path';
    final options = Options(
      extra: {'tokenType': tokenType},
      validateStatus: (status) => true,
    );

    switch (method) {
      case HttpMethod.get:
        return dio.get(path, queryParameters: query, options: options);
      case HttpMethod.post:
        return dio.post(path,
            queryParameters: query, data: body, options: options);
      case HttpMethod.put:
        return dio.put(path,
            queryParameters: query, data: body, options: options);
      case HttpMethod.patch:
        return dio.patch(path,
            queryParameters: query, data: body, options: options);
      case HttpMethod.delete:
        return dio.delete(path,
            queryParameters: query, data: body, options: options);
    }
  }

  Future<bool> hasToken() async {
    final accessToken = await storage.read(key: StorageKey.accessToken.name);
    final refreshToken = await storage.read(key: StorageKey.refreshToken.name);
    return accessToken != null && refreshToken != null;
  }

  Future<void> setTempToken(String token) async {
    await storage.write(key: StorageKey.tempToken.name, value: token);
  }

  Future<void> setToken(String accessToken, String refreshToken) async {
    await Future.wait([
      storage.write(key: StorageKey.accessToken.name, value: accessToken),
      storage.write(key: StorageKey.refreshToken.name, value: refreshToken),
    ]);
  }

  Future<void> removeToken() async {
    await Future.wait([
      storage.delete(key: StorageKey.accessToken.name),
      storage.delete(key: StorageKey.refreshToken.name),
    ]);
  }
}

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final String baseUrl;
  final Dio dio;

  CustomInterceptor(this.storage, this.baseUrl, this.dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final tokenType = options.extra['tokenType'] as TokenType;
    String? token;

    switch (tokenType) {
      case TokenType.none:
        break;
      case TokenType.access:
        token = await storage.read(key: StorageKey.accessToken.name);
        break;
      case TokenType.temporary:
        token = await storage.read(key: StorageKey.tempToken.name);
        break;
    }

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final tokenType = err.requestOptions.extra['tokenType'] as TokenType;

      if (tokenType == TokenType.access) {
        try {
          final refreshToken =
              await storage.read(key: StorageKey.refreshToken.name);
          if (refreshToken != null) {
            final response = await dio.post(
              '$baseUrl/auth/reissue',
              data: {'refreshToken': refreshToken},
            );

            if (response.statusCode == 200) {
              final newAccessToken = response.data['data']['accessToken'];
              final newRefreshToken = response.data['data']['refreshToken'];

              await storage.write(
                  key: StorageKey.accessToken.name, value: newAccessToken);
              await storage.write(
                  key: StorageKey.refreshToken.name, value: newRefreshToken);

              err.requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';
              final retryResponse = await dio.fetch(err.requestOptions);
              handler.resolve(retryResponse);
              return;
            }
          }
        } catch (e) {
          await storage.deleteAll();
        }
      }
    }

    super.onError(err, handler);
  }
}

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print(
        'Request: ${options.method} ${options.path} / Headers: ${options.headers} / Query Parameters: ${options.queryParameters} / Body: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[PRINT] Response: ${response.statusCode} ${response.statusMessage} / Data: ${response.data}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('Error: ${err.message}');
    super.onError(err, handler);
  }
}
