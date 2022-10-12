import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:photos_app/dio_networking/api_route.dart';

import '../dio_networking/api_client.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/app_apis.dart';
import '../models/notification_response_model.dart';

class NotificationRepo {
/*  static final NotificationRepo _singleton = NotificationRepo._internal();

  factory NotificationRepo() {
    return _singleton;
  }*/

  static Future<APIResponse<NotificationsResponseModel>?> getNotificationList(
      {required Map<String, dynamic> data}) async {
    try {
      final result =
          await APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
              .request(
                  route: APIRoute(
                    APIType.getNotifications,
                    body: data,
                  ),
                  create: () => APIResponse<NotificationsResponseModel>(
                      create: () => NotificationsResponseModel()),
                  apiFunction: getNotificationList);
      return result.response;
    } catch (e) {
      return null;
    }
  }

  static Future<APIResponse?> saveDeviceToken(
      {required Map<String, dynamic> data}) async {
    /*  try {
      final result =
          await APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
              .request(
                  route: APIRoute(
                    APIType.saveDeviceToken,
                    body: data,
                  ),
                  create: () => APIResponse(decoding: false),
                  apiFunction: saveDeviceToken);
      return result.response;
    } catch (e) {
      return null;
    }*/
  }

  static Future<String> getUniqueDeviceId() async {
    String uniqueDeviceId = '';

    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      // import 'dart:io'
      final iosDeviceInfo = await deviceInfo.iosInfo;
      uniqueDeviceId =
          '${iosDeviceInfo.name}:${iosDeviceInfo.identifierForVendor}'; // unique ID on iOS
    } else if (Platform.isAndroid) {
      final androidDeviceInfo = await deviceInfo.androidInfo;
      uniqueDeviceId =
          '${androidDeviceInfo.device}:${androidDeviceInfo.id}'; // unique ID on Android
    }

    return uniqueDeviceId;
  }
}
