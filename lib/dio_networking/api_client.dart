import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../common/helpers.dart';
import '../common/user_defaults.dart';
import 'app_apis.dart';
import 'api_response.dart';
import 'api_route.dart';
import 'decodable.dart';
import 'log_interceptor.dart';

abstract class BaseAPIClient {
  Future<ResponseWrapper<T>> request<T extends Decodeable>({
    @required APIRouteConfigurable? route,
    @required Create<T> create,
  });
}

class APIClient implements BaseAPIClient {
  Dio? instance;
  bool isCache;
  String baseUrl;
  String contentType;
  bool isDialoigOpen;

  APIClient(
      {this.isCache = false,
      this.baseUrl = ApiConstants.baseUrl,
      this.isDialoigOpen = true,
      this.contentType = 'application/json'}) {
    instance = Dio();

    if (instance != null) {
      instance!.interceptors.add(MyLogInterceptor());
      if (isCache) {
        List<String> allowedSHa = [];
        //   allowedSHa.add('KEZJOdneURbhMeANe+HVaw0mcmPp6zKFKr6jHc85o0E=');
        // instance!.interceptors.add(DioCacheInterceptor(
        //     options: CacheOption(CachePolicy.forceCache).options));
        //  instance!.interceptors.add(CertificatePinningInterceptor(allowedSHAFingerprints: allowedSHa));
      } else {
        // instance!.interceptors.add(DioCacheInterceptor(options: CacheOption(CachePolicy.noCache).options));
      }
    }
  }

  Map<String, dynamic> headers = {'Accept': '*/*'};

  @override
  Future<ResponseWrapper<T>> request<T extends Decodeable>({
    @required APIRouteConfigurable? route,
    @required Create<T>? create,
    Function? apiFunction,
    bool needToAuthenticate = true,
  }) async {
    final config = route!.getConfig();
    config.baseUrl = baseUrl;
    if (needToAuthenticate && (UserDefaults.getApiToken() != null)) {
      headers['Authorization'] = UserDefaults.getApiToken() ?? "";
    }
    config.headers = headers;
    config.sendTimeout = 60000;
    config.connectTimeout = 60000;
    config.receiveTimeout = 60000;
    config.followRedirects = false;
    config.validateStatus = (status) {
      return status! <= 500;
    };
    final response = await instance?.fetch(config).catchError((error) {
      printWrapped("error in response ${error.toString()}");

      if ((error as DioError).type == DioErrorType.connectTimeout) {
        throw 'No Internet Connection';
      } else {
        throw 'Something went wrong';
      }
    });

    final responseData = response?.data;

    int statusCode = response?.statusCode ?? -1;

    switch (statusCode) {
      case 422:
        throw ErrorResponse.fromJson(responseData);

      case 200:
        var finalResponse =
            ResponseWrapper.init(create: create, json: responseData);
        if (finalResponse.error != null) {
          throw finalResponse.error!;
        } else {
          return ResponseWrapper.init(create: create, json: responseData);
        }
      default:
        throw ErrorResponse(message: 'Something went wrong..');
//        throw ErrorResponse.fromJson(responseData);
    }
  }
}
