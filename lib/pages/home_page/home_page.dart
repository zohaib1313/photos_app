import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/common_widgets.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/common/user_defaults.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/controllers/notification_controller.dart';
import 'package:photos_app/models/my_data_model.dart';
import 'package:photos_app/pages/home_page/notes/notes_page.dart';
import 'package:photos_app/pages/home_page/reminders/reminders_page.dart';
import 'package:photos_app/pages/home_page/shared_folder/shared_folder_view_page.dart';

import '../../../../common/loading_widget.dart';
import '../../common/spaces_boxes.dart';
import '../../models/shared_data_response_model.dart';
import '../notifications/notifications_page.dart';
import 'groups_page/groups_page.dart';
import 'home_page_views_mixin.dart';

class HomePage extends GetView<HomePageController> with HomePageViewsMixin {
  HomePage({Key? key}) : super(key: key);
  static const id = '/HomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
        title: 'Hello, ${UserDefaults.getUserSession()?.username ?? ''}',
        actions: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Obx(() {
              return NamedIcon(
                text: '',
                iconData: Icons.notifications,
                notificationCount: Get.find<NotificationsController>()
                    .notificationsCount
                    .value,
                onTap: () {
                  Get.to(const NotificationsPage());
                  /*       AwesomeNotification.scheduleNotification(
                        id: 13,
                        scheduleTime: DateTime.now().add(Duration(seconds: 10)));*/
                },
              );
            }),
          ),
        ],
      ),
      body: GetX<HomePageController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      /*   SliverAppBar(
                        pinned: false,
                        floating: true,
                        backgroundColor: Colors.transparent,
                        collapsedHeight: 210.h,
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          title: getFolderCard(
                              myFolderModel: controller.pinnedMenuFolder.value,
                              controller: controller,
                              context: context),
                        ),
                      ),*/
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            SizedBox(
                              height: 400.h,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ///private
                                  Expanded(
                                    child: getMainCards(
                                        onTap: () {
                                          controller.loadPrivateFolder(
                                              model: MyDataModel(
                                                userFk: int.tryParse(
                                                  UserDefaults
                                                          .getCurrentUserId() ??
                                                      '',
                                                ),
                                              ),
                                              subListItem: (List<MyDataModel>?
                                                  dataModel) {
                                                if (dataModel != null) {
                                                  ///clearing folder stack
                                                  controller.privateFoldersStack
                                                      .clear();
                                                  controller.openFolder(
                                                      item: dataModel.first);
                                                }
                                              });
                                        },
                                        context: context,
                                        title: 'Private',
                                        color: AppColor.primaryColor,
                                        textColor: AppColor.whiteColor,
                                        icon: Icon(Icons.private_connectivity,
                                            size: 50,
                                            color: AppColor.whiteColor)),
                                  ),
                                  hSpace,
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: getMainCards(
                                              onTap: () {
                                                controller
                                                    .loadSharedReceivedData(
                                                        isForShareFolder: true,
                                                        model: MyDataModel(
                                                            userFk: int.tryParse(
                                                                UserDefaults
                                                                        .getCurrentUserId() ??
                                                                    '')),
                                                        subListItem: (List<
                                                                SharedReceivedDataModel>
                                                            subListItem) {
                                                          printWrapped(
                                                              'response');
                                                          printWrapped(
                                                              subListItem
                                                                  .toString());
                                                          controller
                                                              .sharedReceivedFolderStack
                                                              .value = subListItem;
                                                          Get.to(
                                                              const SharedReceivedFolderViewPage());
                                                        });
                                              },
                                              context: context,
                                              title: 'Shared',
                                              color: AppColor.primaryColor,
                                              textColor: AppColor.whiteColor,
                                              icon: Icon(
                                                  Icons.broadcast_on_personal,
                                                  size: 50,
                                                  color: AppColor.whiteColor)),
                                        ),
                                        vSpace,
                                        Expanded(
                                          child: getMainCards(
                                              onTap: () {
                                                controller
                                                    .loadSharedReceivedData(
                                                        isForShareFolder: false,
                                                        model: MyDataModel(
                                                            userFk: int.tryParse(
                                                                UserDefaults
                                                                        .getCurrentUserId() ??
                                                                    '')),
                                                        subListItem: (List<
                                                                SharedReceivedDataModel>
                                                            subListItem) {
                                                          printWrapped(
                                                              'response');
                                                          printWrapped(
                                                              subListItem
                                                                  .toString());
                                                          controller
                                                              .sharedReceivedFolderStack
                                                              .value = subListItem;
                                                          Get.to(
                                                              const SharedReceivedFolderViewPage());
                                                        });
                                              },
                                              context: context,
                                              title: 'Received',
                                              color: AppColor.primaryColor,
                                              textColor: AppColor.whiteColor,
                                              icon: Icon(Icons.move_to_inbox,
                                                  size: 50,
                                                  color: AppColor.whiteColor)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            vSpace,
                            SizedBox(
                              height: 100,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: getMainCards(
                                        onTap: () {
                                          Get.toNamed(GroupsPage.id);
                                        },
                                        context: context,
                                        title: 'Groups',
                                        textColor: AppColor.whiteColor,
                                        color: AppColor.primaryColor,
                                        icon: Icon(Icons.groups,
                                            size: 40,
                                            color: AppColor.whiteColor)),
                                  ),
                                  hSpace,
                                  Expanded(
                                    child: getMainCards(
                                        onTap: () {
                                          Get.toNamed(ReminderPage.id);
                                        },
                                        context: context,
                                        title: 'Reminders',
                                        textColor: AppColor.whiteColor,
                                        color: AppColor.primaryColor,
                                        icon: Icon(Icons.remember_me,
                                            size: 40,
                                            color: AppColor.whiteColor)),
                                  ),
                                ],
                              ),
                            ),
                            vSpace,
                            SizedBox(
                              height: 100,
                              child: getMainCards(
                                  onTap: () {
                                    Get.toNamed(NotesPage.id);
                                  },
                                  context: context,
                                  title: 'Notes',
                                  textColor: AppColor.whiteColor,
                                  color: AppColor.primaryColor,
                                  icon: Icon(Icons.note_alt,
                                      size: 40, color: AppColor.whiteColor)),
                            ),
                            vSpace,
                            /*  SizedBox(
                              height: 100,
                              child: getMainCards(
                                  onTap: () {
                                    AppUtils.showPicker(
                                        context: context,
                                        onComplete: (file) {});
                                  },
                                  context: context,
                                  title: 'Camera',
                                  textColor: AppColor.whiteColor,
                                  color: AppColor.greenColor,
                                  icon: Icon(Icons.camera_alt_rounded,
                                      size: 40, color: AppColor.whiteColor)),
                            ),*/
                            vSpace,
                            vSpace,
                            vSpace,
                            vSpace,
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (controller.isLoading.isTrue) LoadingWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
