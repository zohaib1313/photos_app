import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/app_alert_bottom_sheet.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/dio_networking/app_apis.dart';
import '../../../../common/loading_widget.dart';
import '../../../common/app_pop_ups.dart';
import '../../../common/app_utils.dart';
import '../../../common/common_widgets.dart';
import '../../../common/my_search_bar.dart';
import '../../../common/spaces_boxes.dart';
import '../../../controllers/groups_controller.dart';
import '../../../my_application.dart';

class GroupsPage extends GetView<GroupsController> {
  const GroupsPage({Key? key}) : super(key: key);
  static const id = '/GroupsPage';

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
          _showBottomSheet();
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
                          Text("No Friend Found",
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
                            return getGroupItem(index: index);
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

  void _showBottomSheet({int? index}) {
    if (index == null) {
      controller.groupTitleController.clear();
      controller.groupDescriptionController.clear();
      controller.profileImage.value = null;
    } else {
      /*controller.groupTitleController.text =
          controller.filteredItemList.elementAt(index)?.name ?? '';

      controller.groupDescriptionController.text =
          controller.filteredItemList.elementAt(index)?.content ?? '';
    */
    }
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    AppBottomSheets.showAppAlertBottomSheet(
        isFull: true,
        isDismissable: false,
        title: 'Create new group',
        context: myContext!,
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              vSpace,
              Obx(() {
                return Center(
                  child: GestureDetector(
                    onTap: () async {
                      AppUtils.showPicker(
                        context: myContext!,
                        onComplete: (File? file) {
                          if (file != null) {
                            controller.profileImage.value = file;
                          }
                        },
                      );
                    },
                    child: getImageWidget(controller.profileImage),
                  ),
                );
              }),
              vSpace,
              vSpace,
              vSpace,
              MyTextField(
                hintText: 'Group title...',
                leftPadding: 0,
                rightPadding: 0,
                validator: (v) {
                  if ((v ?? '').isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                controller: controller.groupTitleController,
              ),
              vSpace,
              MyTextField(
                hintText: 'Group Description...',
                leftPadding: 0,
                rightPadding: 0,
                validator: (v) {
                  if ((v ?? '').isEmpty) {
                    return 'Required';
                  }
                  return null;
                },
                minLines: 4,
                maxLines: 7,
                controller: controller.groupDescriptionController,
              ),
              vSpace,
              Button(
                buttonText: index != null ? 'Update Group' : 'Create Group',
                onTap: () {
                  if ((formKey.currentState?.validate() ?? false)) {
                    if (index != null) {
                      controller.updateGroup(index: index);
                    } else {
                      controller.addNewGroup();
                    }
                  }
                },
              ),
              const SizedBox(height: 300)
            ],
          ),
        ));
  }

  Widget getGroupItem({required int index}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Column(
        children: [
          NetworkPlainImage(
              url: controller.filteredList.elementAt(index).groupPhoto ?? '',
              height: 200.h),
          Text(controller.filteredList.elementAt(index).groupName ?? '-',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.textStyleBoldTitleLarge),
          Text(controller.filteredList.elementAt(index).description ?? '-',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.textStyleNormalBodySmall),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.person),
                    Text((controller.filteredList
                                .elementAt(index)
                                .membersCount ??
                            0)
                        .toString()),
                  ],
                )),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.attach_file_sharp),
                    Text((controller.filteredList
                                .elementAt(index)
                                .groupContent
                                ?.length ??
                            0)
                        .toString()),
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
