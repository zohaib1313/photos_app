import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photos_app/common/app_alert_bottom_sheet.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/common/app_utils.dart';
import 'package:photos_app/common/common_widgets.dart';
import 'package:photos_app/models/reminder_model.dart';
import 'package:photos_app/my_application.dart';

import '../../../../common/loading_widget.dart';
import '../../../common/helpers.dart';
import '../../../common/my_search_bar.dart';
import '../../../common/spaces_boxes.dart';
import '../../../common/styles.dart';
import '../../../controllers/reminder_controller.dart';

class ReminderPage extends GetView<ReminderController> {
  const ReminderPage({Key? key}) : super(key: key);
  static const id = '/ReminderPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showBottomSheet();
        },
      ),
      appBar: myAppBar(goBack: true, title: 'Reminders', actions: [
        MyAnimSearchBar(
          width: context.width,
          onSuffixTap: () {
            controller.searchController.clear();
          },
          closeSearchOnSuffixTap: true,
          textController: controller.searchController,
        ),
      ]),
      body: GetX<ReminderController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                ListView.builder(
                    itemCount: controller.reminderList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      ReminderModel reminderItem =
                          controller.reminderList.elementAt(index);
                      return getReminderCard(item: reminderItem);
                    }),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getReminderCard({required ReminderModel item}) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(4),
        title: Text(DateFormat('hh:mm-MM:yyyy').format(DateTime.now()),
            style: AppTextStyles.textStyleBoldBodyXSmall),
        subtitle: Text(item.message ?? '-',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.textStyleNormalBodySmall),
        trailing: InkWell(
          onTap: () {},
          child: const CircleAvatar(
            radius: 14,
            child: Icon(Icons.edit, color: AppColor.whiteColor, size: 14),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    controller.pickedDateTime.value = null;
    controller.pickedTime.value = null;
    controller.reminderAddMessageTextController.clear();
    AppBottomSheets.showAppAlertBottomSheet(
        isFull: true,
        isDismissable: false,
        title: 'Add new reminder',
        context: myContext!,
        child: Column(
          children: [
            vSpace,

            ///date
            Container(
              padding: const EdgeInsets.all(4),
              color: AppColor.alphaGrey,
              child: Row(
                children: [
                  Obx(() {
                    return Expanded(
                        child: Text(DateFormat('dd-MM-yyyy').format(
                            controller.pickedDateTime.value ??
                                DateTime.now())));
                  }),
                  hSpace,
                  TextButton(
                      onPressed: () {
                        DatePicker.showDatePicker(myContext!,
                            showTitleActions: true,
                            minTime: DateTime.now(),
                            maxTime: DateTime(2050, 6, 7),
                            onChanged: (date) {}, onConfirm: (DateTime? date) {
                          controller.pickedDateTime.value = date;
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: const Text(
                        'Pick',
                        style: TextStyle(color: Colors.blue),
                      )),
                ],
              ),
            ),
            vSpace,

            ///Time
            Container(
              padding: const EdgeInsets.all(4),
              color: AppColor.alphaGrey,
              child: Row(
                children: [
                  Obx(() {
                    return Expanded(
                        child: Text(DateFormat('hh:mm a').format(
                            controller.pickedTime.value ?? DateTime.now())));
                  }),
                  hSpace,
                  TextButton(
                      onPressed: () {
                        DatePicker.showTime12hPicker(myContext!,
                            showTitleActions: true,
                            onChanged: (date) {}, onConfirm: (DateTime? date) {
                          controller.pickedTime.value = date;
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      child: const Text(
                        'Pick',
                        style: TextStyle(color: Colors.blue),
                      )),
                ],
              ),
            ),

            vSpace,

            MyTextField(
              hintText: 'Add your message here...',
              minLines: 4,
              maxLines: 7,
              controller: controller.reminderAddMessageTextController,
            ),
            vSpace,
            Button(
              buttonText: 'Add',
              onTap: () {
                if (controller
                    .reminderAddMessageTextController.text.isNotEmpty) {
                  controller.reminderList.add(ReminderModel(
                      isActive: true,
                      id: '',
                      message: controller.reminderAddMessageTextController.text,
                      timeStamp: controller
                          .pickedDateTime.value?.microsecondsSinceEpoch
                          .toInt()));
                  Get.back();
                  AppPopUps.showSnackBar(
                      message: 'Reminder added', context: myContext!);
                }
              },
            )
          ],
        ));
  }
}
