import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/app_utils.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/pages/home_page/checklist_page/checklist_page.dart';
import 'package:photos_app/pages/home_page/folder_view_page.dart';
import 'package:photos_app/pages/home_page/history_page/history_page.dart';
import 'package:photos_app/pages/home_page/reminders/reminders_page.dart';
import 'package:photos_app/pages/notifications/notifications_page.dart';
import '../../../../common/loading_widget.dart';
import '../../common/my_search_bar.dart';
import '../../common/spaces_boxes.dart';
import '../../models/my_menu_item_model.dart';
import 'home_page_views_mixin.dart';

class HomePage extends GetView<HomePageController> with HomePageViewsMixin {
  HomePage({Key? key}) : super(key: key);
  static const id = '/HomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Hello, John doe', actions: [
        MyAnimSearchBar(
          width: context.width * 0.8,
          onSuffixTap: () {
            controller.searchController.clear();
          },
          closeSearchOnSuffixTap: true,
          textController: controller.searchController,
        ),
        hSpace,
        InkWell(
            onTap: () {
              Get.toNamed(NotificationsPage.id);
            },
            child: const Icon(Icons.notification_important_outlined)),
        hSpace,
        hSpace,
      ]),
      body: GetX<HomePageController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
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
                      ),
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            SizedBox(
                              height: 400.h,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: getMainCards(
                                        onTap: () {
                                          controller.openFolder(
                                              item: controller
                                                  .privateMenuItem.value);
                                        },
                                        context: context,
                                        title: 'Private',
                                        color: AppColor.primaryColor,
                                        textColor: AppColor.whiteColor,
                                        icon: const Icon(
                                            Icons.private_connectivity,
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
                                                controller.openFolder(
                                                    item: controller
                                                        .sharedMenuItem.value);
                                              },
                                              context: context,
                                              title: 'Shared',
                                              color: AppColor.primaryColor,
                                              textColor: AppColor.whiteColor,
                                              icon: const Icon(
                                                  Icons.broadcast_on_personal,
                                                  size: 50,
                                                  color: AppColor.whiteColor)),
                                        ),
                                        vSpace,
                                        Expanded(
                                          child: getMainCards(
                                              onTap: () {
                                                controller.openFolder(
                                                    item: controller
                                                        .receivedMenuItem
                                                        .value);
                                              },
                                              context: context,
                                              title: 'Received',
                                              color: AppColor.primaryColor,
                                              textColor: AppColor.whiteColor,
                                              icon: const Icon(
                                                  Icons.move_to_inbox,
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
                                          Get.toNamed(HistoryPage.id);
                                        },
                                        context: context,
                                        title: 'History',
                                        textColor: AppColor.whiteColor,
                                        color: AppColor.primaryColor,
                                        icon: const Icon(Icons.history,
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
                                        icon: const Icon(Icons.remember_me,
                                            size: 40,
                                            color: AppColor.whiteColor)),
                                  ),
                                  hSpace,
                                  Expanded(
                                    child: getMainCards(
                                        onTap: () {
                                          Get.toNamed(CheckListPage.id);
                                        },
                                        context: context,
                                        title: 'Check list',
                                        textColor: AppColor.whiteColor,
                                        color: AppColor.primaryColor,
                                        icon: const Icon(Icons.check_box,
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
                                    AppUtils.showPicker(
                                        context: context,
                                        onComplete: (file) {});
                                  },
                                  context: context,
                                  title: 'Camera',
                                  textColor: AppColor.whiteColor,
                                  color: AppColor.green,
                                  icon: const Icon(Icons.camera_alt_rounded,
                                      size: 40, color: AppColor.whiteColor)),
                            ),
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
