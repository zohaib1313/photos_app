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
import 'package:flutter_slidable/flutter_slidable.dart';

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
                          Text("No Reminder Found",
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
                            return getReminderCard(index: index);
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

  Widget getReminderCard({required int index}) {
    DateTime dt = DateTime.parse(
        controller.filteredItemList.elementAt(index)!.reminderTime!);
    DateTime now = DateTime.now();

    bool isPast = DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute)
        .isBefore(DateTime(now.year, now.month, now.day, now.hour, now.minute));

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (x) {
              _showBottomSheet(index: index);
            },
            icon: Icons.update,
            label: 'Update',
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (x) {
              controller.deleteReminder(index: index);
            },
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.all(4),
        color: isPast ? AppColor.alphaGrey : AppColor.greenColor,
        child: ListTile(
          contentPadding: const EdgeInsets.all(4),
          title: Text(
              controller.filteredItemList.elementAt(index)?.description ?? '-',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.textStyleNormalBodySmall.copyWith(
                  color: !isPast ? AppColor.whiteColor : AppColor.blackColor)),
          subtitle: Text(
              formatDateTime(DateTime.tryParse(
                  controller.filteredItemList.elementAt(index)?.reminderTime ??
                      '')),
              style: AppTextStyles.textStyleNormalBodySmall.copyWith(
                  color: !isPast ? AppColor.whiteColor : AppColor.blackColor)),

          /*  leading: const Icon(
            Icons.arrow_back_ios,
            size: 14,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),*/
        ),
      ),
    );
  }

  void _showBottomSheet({int? index}) {
    if (index == null) {
      controller.pickedDateTime.value = DateTime.now();
      controller.reminderAddMessageTextController.clear();
    } else {
      controller.pickedDateTime.value = DateTime.tryParse(
          controller.filteredItemList.elementAt(index)?.reminderTime ?? '');
      controller.reminderAddMessageTextController.text =
          controller.filteredItemList.elementAt(index)?.description ?? '';
    }
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
              buttonText: index != null ? 'Update' : 'Add Reminder',
              onTap: () {
                if ((controller
                        .reminderAddMessageTextController.text.isNotEmpty) &&
                    (controller.pickedDateTime.value != null)) {
                  if (index != null) {
                    controller.updateReminder(index: index);
                  } else {
                    controller.addReminder();
                  }
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
