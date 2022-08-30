import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class AwesomeNotification {
  static initializeNotifications() async {
    await AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: 'call_channel',
              /* same name */
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.white)
        ],
        // Channel groups are only visual and are not required
        channelGroups: [
          NotificationChannelGroup(
              channelGroupkey: 'basic_channel_group',
              channelGroupName: 'Basic group')
        ],
        debug: true);

    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static Future<void> startListing() async {
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      print('notificatoin received');

      /*Navigator.of(context).pushNamed(
              '/NotificationPage',
              arguments: {
                // your page params. I recommend you to pass the
                // entire *receivedNotification* object
                id: receivedNotification.id
              }
          );
*/
    });
  }

  static scheduleNotification(
      {required int id, required DateTime scheduleTime}) async {
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    String utcTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();

    var result = await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            wakeUpScreen: true,
            channelKey: 'call_channel',
            title: 'Notification at every single minute',
            body:
                'This notification was schedule to shows at ${scheduleTime.toLocal()}',
            notificationLayout: NotificationLayout.BigText),
/*      schedule: NotificationInterval(
          interval: 60, timeZone: localTimeZone, repeats: true),*/
        schedule: NotificationCalendar.fromDate(date: scheduleTime));

    print('result of notificaiton schedule =$result');
  }
}
