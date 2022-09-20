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
      case APIType.checkUniqueMail:
        return RequestOptions(
          path: ApiConstants.checkUniqueMail,
          headers: headers,
          queryParameters: body,
          method: APIMethod.get,
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
          path: "${ApiConstants.reminder}/${body['id']}/",
          headers: headers,
          data: body,
          method: APIMethod.put,
        );
      case APIType.deleteReminder:
        return RequestOptions(
          path: "${ApiConstants.reminder}/${body['id']}/",
          headers: headers,
          data: body,
          method: APIMethod.delete,
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
          path: "${ApiConstants.notes}/${body['id']}/",
          headers: headers,
          data: body,
          method: APIMethod.put,
        );
      case APIType.deleteNotes:
        return RequestOptions(
          path: "${ApiConstants.notes}/${body['id']}/",
          headers: headers,
          data: body,
          method: APIMethod.delete,
        );
      case APIType.getMyData:
        return RequestOptions(
          path: ApiConstants.myData,
          headers: headers,
          queryParameters: body,
          method: APIMethod.get,
        );

      case APIType.postMyData:
        return RequestOptions(
          path: ApiConstants.myData,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );

      case APIType.getSharedReceivedData:
        return RequestOptions(
          path: ApiConstants.sharedData,
          headers: headers,
          queryParameters: body,
          method: APIMethod.get,
        );
      case APIType.getAllFriends:
        return RequestOptions(
          path: ApiConstants.friends,
          headers: headers,
          queryParameters: body,
          method: APIMethod.get,
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
