import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/app_alert_bottom_sheet.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/styles.dart';
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
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                /* ListView.builder(
                    itemCount: 10,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                              child: Icon(Icons.picture_as_pdf)),
                          title: Text('John doe shared a file with you',
                              style: AppTextStyles.textStyleBoldBodyXSmall),
                          subtitle: Text('file_09.pdf',
                              style: AppTextStyles.textStyleNormalBodyXSmall),
                          trailing: Text("10:11 am\n2022",
                              style: AppTextStyles.textStyleNormalBodyXSmall),
                        ),
                      );
                    }),*/

                Center(
                  child: Text('in Progress'),
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
}
