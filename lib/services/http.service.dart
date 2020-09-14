import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:foodie/constants/api.dart';
import 'package:foodie/data/database/app_database.dart';
import 'package:foodie/data/database/app_database_singleton.dart';

class HttpService {
  String host = Api.baseUrl;
  BaseOptions baseOptions;
  Dio dio;
  AppDatabase appDatabase;

  Future<Map<String, String>> getHeaders() async {
    return {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer ${await getAuthBearerToken()}",
    };
  }

  HttpService() {
    appDatabase = AppDatabaseSingleton.database;

    baseOptions = new BaseOptions(
      baseUrl: host,
      validateStatus: (status) {
        return status <= 500;
      },
      // connectTimeout: 300,
    );
    dio = new Dio(baseOptions);
    dio.interceptors.add(DioCacheManager(
      CacheConfig(
        baseUrl: host,
        defaultMaxAge: Duration(hours: 1),
      ),
    ).interceptor);
  }

  //Get the access token of the logged in user
  Future<String> getAuthBearerToken() async {
    final currentUser = await appDatabase.userDao.findCurrent();
    return currentUser != null ? currentUser.token : "";
  }

  //for get api calls
  Future<Response> get(
    String url, {
    Map<String, dynamic> queryParameters,
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    return dio.get(
      uri,
      options: mOptions,
      queryParameters: queryParameters,
    );
  }

  //for post api calls
  Future<Response> post(
    String url,
    body, {
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";

    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    return dio.post(
      uri,
      data: body,
      options: mOptions,
    );
  }

  //for patch api calls
  Future<Response> patch(String url, Map<String, String> body) async {
    String uri = "$host$url";
    return dio.patch(
      uri,
      data: body,
      options: Options(
        headers: await getHeaders(),
      ),
    );
  }

  //for delete api calls
  Future<Response> delete(
    String url,
  ) async {
    String uri = "$host$url";
    return dio.delete(
      uri,
      options: Options(
        headers: await getHeaders(),
      ),
    );
  }
}
