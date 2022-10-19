import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/dio_networking/api_route.dart';
import 'package:photos_app/models/device_token_response_model.dart';

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

  static Future<APIResponse?> deleteNotification(
      {required Map<String, dynamic> data}) async {
    try {
      final result =
          await APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
              .request(
                  route: APIRoute(
                    APIType.deleteNotification,
                    body: data,
                  ),
                  create: () => APIResponse(),
                  apiFunction: deleteNotification);
      return result.response;
    } catch (e) {
      return null;
    }
  }

  static Future<APIResponse?> saveDeviceToken(
      {required Map<String, dynamic> data}) async {
    try {
      printWrapped('checking devices');
      APIResponse<DeviceTokensResponseModel>? respose = await getDevicesToken(
          data: {
            'device_id': data['device_id'],
            'receiver_id': data['receiver_id']
          });
      printWrapped('devices response=${respose.toString()}');
      if ((respose?.data?.results?.length ?? 0) > 0) {
        printWrapped('devices Found updating now');
        DeviceTokenModel? deviceTokenModel = respose?.data?.results![0];

        if (data['device_token'] != deviceTokenModel?.deviceToken) {
          data['id'] = deviceTokenModel?.id;
          APIResponse<DeviceTokenModel>? result =
              await updateDeviceToken(data: data);
          return result;
        } else {
          printWrapped("device tokens are same no need to update");
        }
      } else {
        ///adding device token
        printWrapped(
            'no previous token found against ${data['device_id']} user=${data['receiver_id']}');

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
      }
    } catch (e) {
      return null;
    }
  }

  static Future<APIResponse<DeviceTokensResponseModel>?> getDevicesToken(
      {required Map<String, dynamic> data}) async {
    try {
      final result =
          await APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
              .request(
                  route: APIRoute(
                    APIType.getDeviceToken,
                    body: data,
                  ),
                  create: () => APIResponse<DeviceTokensResponseModel>(
                      create: () => DeviceTokensResponseModel()),
                  apiFunction: getDevicesToken);
      return result.response;
    } catch (e) {
      return null;
    }
  }

  static Future<APIResponse<DeviceTokenModel>?> updateDeviceToken(
      {required Map<String, dynamic> data}) async {
    try {
      final result =
          await APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
              .request(
                  route: APIRoute(
                    APIType.updateDeviceToken,
                    body: data,
                  ),
                  create: () => APIResponse<DeviceTokenModel>(
                      create: () => DeviceTokenModel()),
                  apiFunction: updateDeviceToken);
      return result.response;
    } catch (e) {
      return null;
    }
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
