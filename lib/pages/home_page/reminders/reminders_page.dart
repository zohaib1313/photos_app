import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photos_app/common/app_alert_bottom_sheet.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/common/app_utils.dart';
import 'package:photos_app/common/common_widgets.dart';
import 'package:photos_app/my_application.dart';

import '../../../../common/loading_widget.dart';
import '../../../common/helpers.dart';
import '../../../common/my_search_bar.dart';
import '../../../common/spaces_boxes.dart';
import '../../../common/styles.dart';
import '../../../controllers/reminder_controller.dart';
import '../../../models/reminder_response_model.dart';

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
        initState: (state) {
          controller.getReminders();
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                ((controller.isLoading.value == false &&
                        controller.reminderList.isEmpty))
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("No Notes Found",
                              style: AppTextStyles.textStyleBoldBodyMedium),
                          InkWell(
                            onTap: () {
                              controller.reminderList.clear();
                              controller.filteredItemList.clear();
                              controller.getReminders(showAlert: true);
                            },
                            child: Text(
                              "Refresh",
                              style: AppTextStyles.textStyleBoldBodyMedium
                                  .copyWith(
                                      decoration: TextDecoration.underline,
                                      color: AppColor.primaryColor),
                            ),
                          ),
                        ],
                      ))
                    : RefreshIndicator(
                        onRefresh: () {
                          controller.reminderList.clear();
                          controller.filteredItemList.clear();
                          controller.getReminders(showAlert: true);
                          return Future.delayed(const Duration(seconds: 2));
                        },
                        child: ListView.builder(
                          itemCount: controller.filteredItemList.length,
                          controller: controller.listViewController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            ReminderModel? reminderItem =
                                controller.filteredItemList.elementAt(index);
                            return getReminderCard(item: reminderItem!);
                          },
                        ),
                      ),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getReminderCard({required ReminderModel item}) {
    DateTime dt = DateTime.parse(item.reminderTime!);
    DateTime now = DateTime.now();

    bool isPast = DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute)
        .isBefore(DateTime(now.year, now.month, now.day, now.hour, now.minute));

    return Card(
      margin: const EdgeInsets.all(4),
      color: isPast ? AppColor.alphaGrey : AppColor.yellowColor,
      child: ListTile(
        contentPadding: const EdgeInsets.all(4),
        title: Text(formatDateTime(DateTime.tryParse(item.reminderTime!)),
            style: AppTextStyles.textStyleBoldBodyXSmall),
        leading: InkWell(
            onTap: () {
              ///edit reminder....
            },
            child: const Icon(Icons.edit)),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.description ?? '-',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.textStyleNormalBodySmall),
          ],
        ),
        /*  trailing: InkWell(
          onTap: () {},
          child: const CircleAvatar(
            radius: 14,
            child: Icon(Icons.edit, color: AppColor.whiteColor, size: 14),
          ),
        ),*/
      ),
    );
  }

  void _showBottomSheet() {
    controller.pickedDateTime.value = null;

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
                        child: Text(DateFormat('dd-MM-yyyy hh:mm a').format(
                            controller.pickedDateTime.value ??
                                DateTime.now())));
                  }),
                  hSpace,
                  TextButton(
                      onPressed: () {
                        AppUtils.showDatePicker(
                            onComplete: (DateTime dateTime) {
                          AppUtils.showTimePicker(
                              onCompletePickTime: (DateTime time) {
                            controller.pickedDateTime.value = combineDateTime(
                                dateTime, time.hour, time.minute, time.second);
                          });
                        });
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
              leftPadding: 0,
              rightPadding: 0,
              minLines: 4,
              maxLines: 7,
              controller: controller.reminderAddMessageTextController,
            ),
            vSpace,
            Button(
              buttonText: 'Add Reminder',
              onTap: () {
                if ((controller
                        .reminderAddMessageTextController.text.isNotEmpty) &&
                    (controller.pickedDateTime.value != null)) {
                  controller.addReminder();
                } else {
                  AppPopUps.showDialogContent(
                      title: 'Alert', description: 'Enter all fields');
                }
              },
            )
          ],
        ));
  }
}
