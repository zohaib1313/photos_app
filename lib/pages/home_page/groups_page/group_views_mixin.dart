import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/common/user_defaults.dart';
import 'package:photos_app/controllers/groups_controller.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/app_alert_bottom_sheet.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/models/group_member_response_model.dart';
import 'package:photos_app/models/groups_response_model.dart';
import 'package:photos_app/models/my_data_model.dart';
import 'package:photos_app/models/user_model.dart';
import 'package:photos_app/pages/home_page/groups_page/search_group_user_page.dart';

import '../../../../common/loading_widget.dart';
import '../../../common/app_utils.dart';
import '../../../common/common_widgets.dart';
import '../../../common/my_search_bar.dart';
import '../../../common/spaces_boxes.dart';
import '../../../controllers/groups_controller.dart';
import '../../../my_application.dart';

mixin GroupViewsMinx {
  Widget getGroupItem(
      {required int index,
      required GroupsController controller,
      required BuildContext context,
      required bool isForChoosingGroup}) {
    return isForChoosingGroup
        ? InkWell(
            onTap: () {
              Get.back(result: controller.filteredList.elementAt(index));
            },
            child: _itemView(
                index: index, context: context, controller: controller))
        : getFocusedMenu(
            index: index,
            context: context,
            controller: controller,
            child: _itemView(
                index: index, context: context, controller: controller));
  }

  void showAddUpdateBottomSheet(
      {int? index, required GroupsController controller}) {
    if (index == null) {
      controller.groupTitleController.clear();
      controller.groupDescriptionController.clear();
      controller.profileImage.value = null;
    } else {
      controller.groupTitleController.text =
          controller.filteredList.elementAt(index).groupName ?? '';

      controller.groupDescriptionController.text =
          controller.filteredList.elementAt(index).description ?? '';
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
                    child: getImageWidget(controller.profileImage,
                        networkImage: index != null
                            ? controller.filteredList
                                    .elementAt(index)
                                    .groupPhoto ??
                                ''
                            : ''),
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

  void openUsersBottomSheet(
      {required GroupsController controller, required GroupModel groupModel}) {
    AppBottomSheets.showAppAlertBottomSheet(
      isFull: true,
      isDismissable: true,
      title: 'Members',
      context: myContext!,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            ///add members in group....
            var groupMemberList = await Get.toNamed(SearchGroupUserPage.id,
                arguments: [groupModel.id]);
            if (groupMemberList != null) {
              ///to close bottom sheet.....
              Get.back();
              printWrapped(
                  "adding member in group ${groupMemberList.toString()}");
              controller.addMemberInGroup(
                  groupModel: groupModel,
                  groupMemberIdsList: groupMemberList,
                  onSuccess: () {});
            }
          },
        ),
        body: ListView.builder(
          itemCount: groupModel.members?.length ?? 0,
          itemBuilder: (context, index) {
            return getFriendItemCard(
                controller: controller,
                groupModel: groupModel,
                userModel: groupModel.members![index],
                ifIamAdmin: groupModel.members![index].id.toString() ==
                    UserDefaults.getCurrentUserId());
          },
        ),
      ),
    );
  }

  Widget getFriendItemCard(
      {required UserModel userModel,
      required bool ifIamAdmin,
      required GroupsController controller,
      required GroupModel groupModel}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Obx(() {
          return Stack(
            children: [
              ListTile(
                  contentPadding: const EdgeInsets.all(2),
                  leading: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: NetworkCircularImage(url: userModel.photo ?? ''),
                  ),
                  title: Text(
                    userModel.username ?? '-',
                    style: AppTextStyles.textStyleNormalBodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: ifIamAdmin
                      ? const IgnorePointer()
                      : TextButton(
                          onPressed: () {
                            controller.removeMemberFromGroup(
                                user: userModel,
                                groupId: groupModel.id!,
                                onSuccess: () {
                                  groupModel.members?.remove(userModel);
                                });
                          },
                          child: Text('Remove',
                              style: AppTextStyles.textStyleBoldBodyMedium))),
              if (controller.isLoading.isTrue) LoadingWidget()
            ],
          );
        }),
      ),
    );
  }

  Widget getFocusedMenu(
      {required int index,
      required BuildContext context,
      required GroupsController controller,
      required Widget child}) {
    return FocusedMenuHolder(
        menuWidth: MediaQuery.of(context).size.width * 0.50,
        blurSize: 5.0,
        menuItemExtent: 45,
        menuBoxDecoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        duration: const Duration(milliseconds: 100),
        animateMenuItems: true,
        blurBackgroundColor: Colors.black54,
        openWithTap: true,
        // Open Focused-Menu on Tap rather than Long Press
        menuOffset: 10.0,
        // Offset value to show menuItem from the selected item
        bottomOffsetHeight: 80.0,
        // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
        menuItems: <FocusedMenuItem>[
          // Add Each FocusedMenuItem  for Menu Options
          FocusedMenuItem(
              title: Text("Open", style: AppTextStyles.textStyleBoldBodySmall),
              trailingIcon: const Icon(Icons.open_in_new),
              onPressed: () {
                final list =
                    controller.filteredList.elementAt(index).groupContent ?? [];

                if (list.isEmpty) {
                  AppPopUps.showSnackBar(
                      message: 'No item is shared with this group',
                      context: context);
                } else {
                  ///open folder....
                  HomePageController homeController =
                      Get.find<HomePageController>();

                  List<MyDataModel> subList = [];
                  controller.filteredList
                      .elementAt(index)
                      .groupContent
                      ?.forEach((element) {
                    if (element.contentFk != null) {
                      subList.add(element.contentFk!);
                    }
                  });

                  ///opening folder......
                  homeController.privateFoldersStack.clear();
                  homeController.openFolder(
                      item: MyDataModel(
                          name: controller.filteredList
                              .elementAt(index)
                              .groupName,
                          subFolder: subList));
                }
              }),
          FocusedMenuItem(
              title:
                  Text("Members", style: AppTextStyles.textStyleBoldBodySmall),
              trailingIcon: const Icon(Icons.person),
              onPressed: () {
                openUsersBottomSheet(
                    controller: controller,
                    groupModel: controller.filteredList.elementAt(index));
              }),
          FocusedMenuItem(
              title:
                  Text("Update", style: AppTextStyles.textStyleBoldBodySmall),
              trailingIcon: const Icon(Icons.edit),
              onPressed: () {
                showAddUpdateBottomSheet(controller: controller, index: index);
              }),
          FocusedMenuItem(
              title:
                  Text("Delete", style: AppTextStyles.textStyleBoldBodySmall),
              trailingIcon: Icon(Icons.delete, color: AppColor.redColor),
              onPressed: () {
                controller.deleteGroup(
                    group: controller.filteredList.elementAt(index));
              }),
        ],
        onPressed: () {},
        child: child);
  }
}

_itemView(
    {required int index,
    required GroupsController controller,
    required BuildContext context}) {
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
                ),
              ),
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
