import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/network_repositories/notification_repo.dart';

import '../common/user_defaults.dart';
import '../models/notification_response_model.dart';

class NotificationsController extends GetxController {
  RxBool isLoading = false.obs;

  int pageToLoad = 1;

  bool hasNewPage = false;

  RxList<NotificationModel> filteredList = <NotificationModel>[].obs;
  ScrollController listViewController = ScrollController();

  RxInt notificationsCount = 0.obs;

  @override
  void onInit() {
    clearLists();
    loadNotifications();
    super.onInit();
  }

  void loadNotifications({bool showAlert = false}) async {
    isLoading.value = true;
    try {
      final apiResponse = await NotificationRepo.getNotificationList(data: {
        'page': pageToLoad,
        'receiver_id': UserDefaults.getCurrentUserId(),
      });
      isLoading.value = false;
      if (apiResponse?.data != null) {
        if (apiResponse?.data?.next != null) {
          pageToLoad++;
        }

        ///adding all groups .....
        apiResponse?.data?.notificationList?.forEach((element) {
          if (!(element.isRead ?? false)) {
            notificationsCount++;
          }
          filteredList.add(element);
        });
      } else {
        if (showAlert) {
          AppPopUps.showDialogContent(
              title: 'Alert',
              description: 'No record found',
              dialogType: DialogType.WARNING);
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (showAlert) {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: e.toString(),
            dialogType: DialogType.ERROR);
      }
    }
  }

  void clearLists() {
    filteredList.clear();
  }

  void deleteNotification({required NotificationModel notification}) async {
    try {
      final apiResponse = await NotificationRepo.deleteNotification(
          data: {'id': notification.id});
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
