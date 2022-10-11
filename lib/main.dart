import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photos_app/notifications/Push_notifications_manager.dart';
import 'package:photos_app/notifications/awsome_notification.dart';

import 'common/user_defaults.dart';
import 'my_application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserDefaults.getPref();
  await Firebase.initializeApp();
  // await HiveDb.clearDb();
//  debugRepaintRainbowEnabled = (true);
  await AwesomeNotification.initializeNotifications();
  await AwesomeNotification.startListing();
  await PushNotificationsManager().init();
  runApp(const MyApplication());
}
