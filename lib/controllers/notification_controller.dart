import 'dart:async';

import 'package:get/get.dart';
import 'package:photos_app/models/notification_model.dart';

class NotificationsController extends GetxController {
  var temp = 0.obs;

  @override
  void onInit() {
    notificationStream();
    super.onInit();
  }

  StreamController<List<NotificationModel>> notificationStreamController =
      StreamController();

  notificationStream() {
    Future.delayed(const Duration(seconds: 1), () {
      notificationStreamController.sink.add([
        NotificationModel(
            id: 'id',
            fromId: 'fromId',
            toId: 'toId',
            title: 'test',
            body: 'test body',
            time: DateTime.now().millisecondsSinceEpoch.toString(),
            isRead: false),
      ]);
    });
  }
}
