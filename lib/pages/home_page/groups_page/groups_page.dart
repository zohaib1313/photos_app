import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/app_alert_bottom_sheet.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/pages/home_page/groups_page/group_views_mixin.dart';

import '../../../../common/loading_widget.dart';
import '../../../common/app_utils.dart';
import '../../../common/common_widgets.dart';
import '../../../common/my_search_bar.dart';
import '../../../common/spaces_boxes.dart';
import '../../../controllers/groups_controller.dart';
import '../../../my_application.dart';

class GroupsPage extends GetView<GroupsController> with GroupViewsMinx {
  GroupsPage({Key? key}) : super(key: key);
  static const id = '/GroupsPage';
  bool? isForChoosingGroup = Get.arguments?[0] ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(goBack: true, title: 'Groups', actions: [
        MyAnimSearchBar(
          width: context.width,
          color: AppColor.primaryColor,
          onSuffixTap: () {
            controller.searchController.clear();
          },
          closeSearchOnSuffixTap: true,
          textController: controller.searchController,
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ///add new group bottom sheet
          showAddUpdateBottomSheet(controller: controller);
        },
        child: const Icon(Icons.add),
      ),
      body: GetX<GroupsController>(
        initState: (state) {
          controller.clearLists();
          controller.loadGroups();
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                ((controller.isLoading.value == false &&
                        controller.filteredList.isEmpty))
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("No Groups Found",
                              style: AppTextStyles.textStyleBoldBodyMedium),
                          InkWell(
                            onTap: () {
                              controller.clearLists();
                              controller.loadGroups(showAlert: true);
                            },
                            child: Text(
                              "Refresh",
                              style: AppTextStyles.textStyleBoldBodyMedium
                                  .copyWith(
                                      decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ))
                    : RefreshIndicator(
                        onRefresh: () {
                          controller.clearLists();
                          controller.loadGroups(showAlert: true);
                          return Future.delayed(const Duration(seconds: 2));
                        },
                        child: ListView.builder(
                          itemCount: controller.filteredList.length,
                          controller: controller.listViewController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return getGroupItem(
                                context: context,
                                index: index,
                                isForChoosingGroup: isForChoosingGroup ?? false,
                                controller: controller);
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
}
