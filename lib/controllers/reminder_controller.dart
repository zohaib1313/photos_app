import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

import '../common/app_pop_ups.dart';
import '../common/extensions.dart';
import '../common/helpers.dart';
import '../common/user_defaults.dart';
import '../dio_networking/api_client.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';
import '../models/reminder_response_model.dart';
import '../models/user_model.dart';
import '../my_application.dart';

class ReminderController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<ReminderModel?> reminderList = <ReminderModel?>[].obs;
  RxList<ReminderModel?> filteredItemList = <ReminderModel?>[].obs;

  TextEditingController searchController = TextEditingController();
  TextEditingController reminderAddMessageTextController =
      TextEditingController();

//  var pickedDateTime = Rxn<DateTime>().obs;

  Rx<DateTime?> pickedDateTime = RxNullable<DateTime?>().setNull();

  int pageToLoad = 1;
  bool hasNewPage = false;

  ScrollController listViewController = ScrollController();

  @override
  void onInit() {
    listViewController.addListener(() {
      if (listViewController.position.extentBefore ==
          listViewController.position.maxScrollExtent) {
        print('end of the page');
        if (hasNewPage) {
          getReminders();
        }
      }
    });
    searchController.addListener(searchFromList);

    super.onInit();
  }

  void searchFromList() {
    printWrapped('searching');
    filteredItemList.clear();
    if (searchController.text.isEmpty) {
      filteredItemList.addAll(reminderList);
    } else {
      String query = searchController.text.toLowerCase();
      for (var element in reminderList) {
        if (((element?.description ?? "null").toLowerCase()).contains(query)) {
          filteredItemList.add(element);
        }
      }
    }
    printWrapped(filteredItemList.length.toString());
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (before == max) {
        printWrapped("end of the page");
        if (hasNewPage) {
          getReminders();
        } // load next page
        // code here will be called only if scrolled to the very bottom
      }
    }
    return false;
  }

  void getReminders({bool showAlert = false}) {
    UserModel? user = UserDefaults.getUserSession();

    Map<String, dynamic> body = {'page': pageToLoad.toString()};
    isLoading.value = true;
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.getReminders,
              body: body,
            ),
            create: () => APIResponse<RemindersResponseModel>(
                create: () => RemindersResponseModel()),
            apiFunction: getReminders)
        .then((response) {
      isLoading.value = false;
      RemindersResponseModel? model = response.response?.data;

      if ((model?.results?.length ?? 0) > 0) {
        if ((model?.next ?? '').isNotEmpty) {
          pageToLoad++;
          hasNewPage = true;
        } else {
          hasNewPage = false;
        }
        reminderList.addAll(model?.results ?? []);
        filteredItemList.addAll(reminderList);
      } else {
        if (showAlert) {
          AppPopUps.showDialogContent(
              title: 'Alert',
              description: 'No result found',
              dialogType: DialogType.INFO);
        }
      }
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }

  void addReminder() {
    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;

    ///to close bottomsheet
    Get.back();
    Map<String, dynamic> data = {
      "description": reminderAddMessageTextController.text.trim(),
      "reminder_time": pickedDateTime.value?.toIso8601String().toString(),
      "user_fk": UserDefaults.getCurrentUserId(),
    };
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            needToAuthenticate: true,
            route: APIRoute(
              APIType.createReminder,
              body: data,
            ),
            create: () =>
                APIResponse<ReminderModel>(create: () => ReminderModel()),
            apiFunction: addReminder)
        .then((response) async {
      isLoading.value = false;
      ReminderModel? model = response.response?.data;
      if (model != null) {
        reminderList.add(model);
        filteredItemList.add(model);
      } else {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: 'Failed to signup',
            dialogType: DialogType.ERROR);
      }
    }).catchError((error) {
      print(error);
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }
}
