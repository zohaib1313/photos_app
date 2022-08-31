import 'package:dio/dio.dart';

import 'app_apis.dart';

class APIRoute implements APIRouteConfigurable {
  final APIType type;
  final String? routeParams;
  Map<String, dynamic>? headers;
  dynamic body;

  APIRoute(this.type, {this.routeParams, this.headers, this.body});

  /// Return config of api (method, url, header)
  @override
  RequestOptions getConfig() {
    // pass extra value to detect public or auth api

    switch (type) {
      case APIType.loginUser:
        return RequestOptions(
          path: ApiConstants.loginUser,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );
      case APIType.registerUser:
        return RequestOptions(
          path: ApiConstants.registerUser,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );
      case APIType.getReminders:
        return RequestOptions(
          path: ApiConstants.reminder,
          headers: headers,
          queryParameters: body,
          method: APIMethod.get,
        );
      case APIType.createReminder:
        return RequestOptions(
          path: ApiConstants.reminder,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );
      case APIType.updateReminder:
        return RequestOptions(
          path: "${ApiConstants.registerUser}/${body['id']}",
          headers: headers,
          data: body,
          method: APIMethod.put,
        );

      case APIType.getNotes:
        return RequestOptions(
          path: ApiConstants.notes,
          headers: headers,
          queryParameters: body,
          method: APIMethod.get,
        );
      case APIType.createNotes:
        return RequestOptions(
          path: ApiConstants.notes,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );
      case APIType.updateNotes:
        return RequestOptions(
          path: "${ApiConstants.notes}/${body['id']}",
          headers: headers,
          data: body,
          method: APIMethod.put,
        );

      default:
        return RequestOptions(
          path: ApiConstants.loginUser,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );
    }
  }
}

abstract class APIRouteConfigurable {
  RequestOptions getConfig();
}

class APIMethod {
  static const get = 'GET';
  static const post = 'POST';
  static const put = 'PUT';
  static const patch = 'PATCH';
  static const delete = 'DELETE'; //delete
}
