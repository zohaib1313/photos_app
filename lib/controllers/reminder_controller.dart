import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/models/reminder_model.dart';

import '../common/constants.dart';
import '../common/extensions.dart';

class ReminderController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<ReminderModel> reminderList = <ReminderModel>[
    ReminderModel(
        id: '1',
        isDone: false,
        isSoundOn: false,
        message: 'Get a product from amazon',
        timeStamp: DateTime.now().millisecondsSinceEpoch),
    ReminderModel(
        id: '2',
        isDone: false,
        isSoundOn: false,
        message: 'dummy task',
        timeStamp: DateTime.now().millisecondsSinceEpoch),
    ReminderModel(
        id: '3',
        isDone: true,
        isSoundOn: false,
        message: AppConstants.loreumIpsum,
        timeStamp: DateTime.now().millisecondsSinceEpoch),
  ].obs;

  TextEditingController searchController = TextEditingController();
  TextEditingController reminderAddMessageTextController =
      TextEditingController();

//  var pickedDateTime = Rxn<DateTime>().obs;

  Rx<DateTime?> pickedDateTime = RxNullable<DateTime?>().setNull();
  Rx<DateTime?> pickedTime = RxNullable<DateTime?>().setNull();
}
