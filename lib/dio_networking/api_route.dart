import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import '../common/user_defaults.dart';
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
          path: ApiConstants.users,
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
      case APIType.updateUserProfile:
        return RequestOptions(
          path: "${ApiConstants.users}/${UserDefaults.getCurrentUserId()}/",
          headers: headers,
          data: body,
          method: APIMethod.put,
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

      case APIType.deleteContent:
        return RequestOptions(
          path: "${ApiConstants.myData}/${body['id']}/",
          headers: headers,
          data: body,
          method: APIMethod.delete,
        );

      case APIType.getSharedReceivedData:
        return RequestOptions(
          path: ApiConstants.sharedData,
          headers: headers,
          queryParameters: body,
          method: APIMethod.get,
        );
      case APIType.postShareData:
        return RequestOptions(
          path: ApiConstants.sharedData,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );
      case APIType.getAllFriends:
        return RequestOptions(
          path: ApiConstants.friends,
          headers: headers,
          queryParameters: body,
          method: APIMethod.get,
        );
      case APIType.sendFriendRequest:
        return RequestOptions(
          path: ApiConstants.friends,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );
      case APIType.deleteFriendRequest:
        return RequestOptions(
          path: "${ApiConstants.friends}/${body['id']}/",
          headers: headers,
          data: body,
          method: APIMethod.delete,
        );

      case APIType.updateFriendRequestStatus:
        return RequestOptions(
          path: "${ApiConstants.friends}/${body['id']}/",
          headers: headers,
          data: body,
          method: APIMethod.put,
        );
      case APIType.searchUniqueUser:
        return RequestOptions(
          path: ApiConstants.uniqueUser,
          headers: headers,
          queryParameters: body,
          method: APIMethod.get,
        );

      ///groups
      case APIType.getAllGroups:
        return RequestOptions(
          path: ApiConstants.groupMember,
          headers: headers,
          queryParameters: body,
          method: APIMethod.get,
        );
      case APIType.addNewGroup:
        return RequestOptions(
          path: ApiConstants.groups,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );

      case APIType.updateGroup:
        return RequestOptions(
          path: "${ApiConstants.groups}/${body['id']}/",
          headers: headers,
          data: dio.FormData.fromMap(body),
          method: APIMethod.put,
        );
      case APIType.deleteGroup:
        return RequestOptions(
          path: "${ApiConstants.groups}/${body['id']}/",
          headers: headers,
          data: body,
          method: APIMethod.delete,
        );

      case APIType.shareDataInGroup:
        return RequestOptions(
          path: ApiConstants.groupContent,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );
      case APIType.addMemberInGroup:
        return RequestOptions(
          path: ApiConstants.groupMember,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );

      case APIType.removeMemberFromGroup:
        return RequestOptions(
          path: ApiConstants.groupMember,
          headers: headers,
          queryParameters: body,
          method: APIMethod.delete,
        );

      case APIType.searchUserForGroup:
        return RequestOptions(
          path: ApiConstants.checkMembers,
          headers: headers,
          queryParameters: body,
          method: APIMethod.get,
        );

      ///push notifications

      case APIType.saveDeviceToken:
        return RequestOptions(
          path: ApiConstants.devices,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );
      case APIType.sendNotification:
        return RequestOptions(
          path: ApiConstants.notifications,
          headers: headers,
          data: body,
          method: APIMethod.post,
        );
      case APIType.getDeviceToken:
        return RequestOptions(
          path: ApiConstants.devices,
          headers: headers,
          queryParameters: body,
          method: APIMethod.get,
        );
      case APIType.updateDeviceToken:
        return RequestOptions(
          path: "${ApiConstants.devices}/${body['id']}/",
          headers: headers,
          data: dio.FormData.fromMap(body),
          method: APIMethod.put,
        );
      case APIType.getNotifications:
        return RequestOptions(
          path: ApiConstants.notifications,
          headers: headers,
          queryParameters: body,
          method: APIMethod.get,
        );
      case APIType.deleteNotification:
        return RequestOptions(
          path: "${ApiConstants.notifications}/${body['id']}/",
          headers: headers,
          data: body,
          method: APIMethod.delete,
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
