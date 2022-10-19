import 'dart:convert';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:http/http.dart' as http;
import 'package:photos_app/common/user_defaults.dart';

import '../common/helpers.dart';
import '../dio_networking/app_apis.dart';
import '../models/notification_response_model.dart';
import '../network_repositories/notification_repo.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
      );

      _initialized = await flutterLocalNotificationsPlugin.initialize(
            initializationSettings,
            /*   onSelectNotification: (String? payload) async {
            if (payload != null) {}
          }*/
          ) ??
          false;
    }

    String userId = UserDefaults.getCurrentUserId() ?? '';
    String? token = await _firebaseMessaging.getToken();

    printWrapped("FCM TOKEN= ${token.toString()}");

    if (((userId).isNotEmpty) && (token ?? '').isNotEmpty) {
      final apiResponse = await NotificationRepo.saveDeviceToken(data: {
        "receiver_id": userId,
        "device_token": token,
        "device_id": await NotificationRepo.getUniqueDeviceId()
      });
      if (apiResponse?.success ?? false) {
        printWrapped("FCM TOKEN== ****token updated");
      }
    }

    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      printWrapped("FCM TOKEN refreshed == $newToken");
      if ((userId).isNotEmpty) {
        final apiResponse = await NotificationRepo.saveDeviceToken(data: {
          "receiver_id": userId,
          "device_token": newToken,
          "device_id": await NotificationRepo.getUniqueDeviceId()
        });
        if (apiResponse?.success ?? false) {
          printWrapped("FCM TOKEN== ****token updated");
        }
      }
    });

    _listenToNotifications();
  }

  void _listenToNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      printWrapped("Notification received \n${message.toMap().toString()}");
      _demoNotification(message);
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
/////////////////////////////////
sendPushNotification(
    {required String? toDeviceId,
    required NotificationModel notificationModel}) async {
  if (toDeviceId != null) {
    var headers = {
      'Authorization': 'key=${ApiConstants.pushServerKey}',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('https://fcm.googleapis.com/fcm/send'));
    request.body = json.encode({
      "to": toDeviceId,
      // "ceoTbCODQ96_r3XdkVKtCn:APA91bGp5kDevP1wkbX2TFF980soSFXLIvfxQVuaV7ZTje_vvQqsOh1vcx6RB0QccyHnJGSAduLnY8kYLWIchp71FswWgupThLtDtaETUq3iIJDFYcuhLx9VWj4RwIbMnXHdyq-sxzlt",
      "notification": notificationModel
          .toJson() /* {"title": "Portugal vs. Denmark", "body": "great match!"}*/
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    printWrapped("sending notification");
    printWrapped(response.toString());

    if (response.statusCode == 200) {
      printWrapped("notification sent success");
      // _saveNotificationToFirebase(model: notificationModel);
    } else {
      printWrapped("notification send failed");
      printWrapped(response.reasonPhrase.toString());
    }
  }
}

/*void _saveNotificationToFirebase({required NotificationModel model}) {
  FirebaseFirestore.instance
      .collection(FirebasePathNodes.notifications)
      .doc(model.toId)
      .set(model.toMap());
}*/

Future<void> _demoNotification(RemoteMessage message) async {
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      "channel_id", 'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      showWhen: true,
      icon: "@mipmap/ic_launcher");

  var iOSChannelSpecifics = const DarwinNotificationDetails(
    presentAlert: true,
    presentSound: true,
  );
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);

  String titleString = message.notification?.title ?? "";
  String messageString = message.notification?.body ?? '';

  await flutterLocalNotificationsPlugin.show(Random().nextInt(10), titleString,
      messageString, platformChannelSpecifics,
      payload: 'test');
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  printWrapped("Handling a background message: ${message.messageId}");
  await Firebase.initializeApp();
}
