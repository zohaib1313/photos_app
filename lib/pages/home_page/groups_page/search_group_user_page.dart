import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/common/app_utils.dart';
import 'package:photos_app/common/common_widgets.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/my_search_bar.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/controllers/search_group_user_controller.dart';

import '../../../../../common/loading_widget.dart';

class SearchGroupUserPage extends GetView<SearchGroupUserController> {
  SearchGroupUserPage({Key? key}) : super(key: key);
  static const id = '/SearchGroupUserPage';
  final int? groupId = Get.arguments?[0];

  @override
  Widget build(BuildContext context) {
    return GetX<SearchGroupUserController>(
      initState: (state) {
        controller.searchController.addListener(() async {
          String query = controller.searchController.text;
          if (query.isNotEmpty) {
            if (controller.lastQueryUserName != query &&
                controller.isLoading.isFalse) {
              controller.lastQueryUserName = query;
              controller.filteredItemList.clear();
              if (groupId != null) {
                controller.searchForMemberFromApi(
                    groupId: groupId!, userName: query);
              } else {
                AppPopUps.showSnackBar(
                    message: 'Add group id', context: context);
              }
            }
          }
        });
      },
      builder: (_) {
        return SafeArea(
          child: Scaffold(
            floatingActionButton: controller.selectedMemberSet.isNotEmpty
                ? FloatingActionButton(
                    child: const Icon(Icons.done),
                    onPressed: () {
                      Get.back(result: controller.selectedMemberSet.toList());
                    })
                : const IgnorePointer(),
            appBar: myAppBar(
                backGroundColor: AppColor.primaryColor,
                goBack: true,
                title: 'Users',
                actions: [
                  MyAnimSearchBar(
                    width: context.width,
                    color: AppColor.primaryColor,
                    iconColor: AppColor.whiteColor,
                    onSuffixTap: () {
                      AppUtils.unFocusKeyboard();
                      controller.searchController.clear();
                      controller.lastQueryUserName = '';
                    },
                    closeSearchOnSuffixTap: true,
                    textController: controller.searchController,
                  ),
                ]),
            body: Stack(
              children: [
                controller.filteredItemList.isEmpty
                    ? Center(
                        child: Text('No User found',
                            style: AppTextStyles.textStyleBoldBodyMedium),
                      )
                    : ListView.builder(
                        itemCount: controller.filteredItemList.length,
                        controller: controller.listViewController,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          return getUserItemCard(index: index);
                        },
                      ),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getUserItemCard({required int index}) {
    return Card(
      child: controller.filteredItemList.elementAt(index)?.status == false
          ? Obx(() {
              return CheckboxListTile(
                contentPadding: const EdgeInsets.all(2),
                secondary: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: NetworkCircularImage(
                      url: controller.filteredItemList
                              .elementAt(index)
                              ?.member
                              ?.photo ??
                          ''),
                ),
                title: Text(
                  controller.filteredItemList
                          .elementAt(index)
                          ?.member
                          ?.username ??
                      '-',
                  style: AppTextStyles.textStyleNormalBodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onChanged: (bool? value) {
                  if (value ?? false) {
                    controller.selectedMemberSet.add((controller
                        .filteredItemList
                        .elementAt(index)!
                        .member!
                        .id!));
                  } else {
                    controller.selectedMemberSet.removeWhere((element) =>
                        element ==
                        controller.filteredItemList
                            .elementAt(index)!
                            .member!
                            .id!);
                  }
                },
                value: controller.selectedMemberSet.contains(
                    controller.filteredItemList.elementAt(index)?.member?.id!),
              );
            })
          : ListTile(
              contentPadding: const EdgeInsets.all(2),
              leading: Padding(
                padding: const EdgeInsets.all(4.0),
                child: NetworkCircularImage(
                    url: controller.filteredItemList
                            .elementAt(index)
                            ?.member
                            ?.photo ??
                        ''),
              ),
              title: Text(
                controller.filteredItemList
                        .elementAt(index)
                        ?.member
                        ?.username ??
                    '-',
                style: AppTextStyles.textStyleNormalBodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
    );
  }
}
