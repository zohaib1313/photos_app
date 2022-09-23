import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/common_widgets.dart';
import 'package:photos_app/common/spaces_boxes.dart';
import 'package:photos_app/common/user_defaults.dart';
import 'package:photos_app/my_application.dart';
import 'package:photos_app/pages/search_user_page.dart';
import '../../../../common/loading_widget.dart';
import '../../common/app_alert_bottom_sheet.dart';
import '../../common/helpers.dart';
import '../../common/my_search_bar.dart';
import '../../common/styles.dart';
import '../../controllers/friends_page_controller.dart';

class FriendsPage extends GetView<FriendsPageController> {
  var isForUpdate = false;

  FriendsPage({Key? key, this.isForUpdate = false}) : super(key: key);
  static const id = '/FriendsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isForUpdate
          ? const IgnorePointer()
          : Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () async {
                  await Get.toNamed(SearchUserPage.id);
                  controller.friendsList.clear();
                  controller.filteredList.clear();
                  controller.loadFriendsList(
                      showAlert: true, isForUpdate: isForUpdate);
                },
              ),
            ),
      appBar: myAppBar(
          backGroundColor: AppColor.primaryColor,
          goBack: true,
          title: 'Friends',
          actions: [
            MyAnimSearchBar(
              width: context.width * 0.8,
              color: AppColor.primaryColor,
              iconColor: AppColor.whiteColor,
              onSuffixTap: () {
                controller.searchController.clear();
              },
              closeSearchOnSuffixTap: true,
              textController: controller.searchController,
            ),

            ///if this page is being used for update then remove filtering of list
            if (!isForUpdate)
              IconButton(
                  icon: const Icon(Icons.filter_alt),
                  onPressed: () {
                    _showBottomSheet();
                  }),
            hSpace,
          ]),
      body: GetX<FriendsPageController>(
        initState: (state) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            controller.friendsList.clear();
            controller.filteredList.clear();
            controller.loadFriendsList(isForUpdate: isForUpdate);
          });
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
                              controller.filteredList.clear();
                              controller.friendsList.clear();
                              controller.loadFriendsList(
                                  showAlert: true, isForUpdate: isForUpdate);
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
                          controller.filteredList.clear();
                          controller.friendsList.clear();
                          controller.loadFriendsList(
                              showAlert: true, isForUpdate: isForUpdate);
                          return Future.delayed(const Duration(seconds: 2));
                        },
                        child: ListView.builder(
                          itemCount: controller.filteredList.length,
                          controller: controller.listViewController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return getFriendItemCard(index: index);
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

  Widget getFriendItemCard({required int index}) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(2),
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: NetworkCircularImage(
              url: controller.filteredList.elementAt(index).friendFk?.photo ??
                  ''),
        ),
        title: Text(
          controller.filteredList.elementAt(index).friendFk?.username ?? '-',
          style: AppTextStyles.textStyleNormalBodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isForUpdate

            ///if this page is used for picking up the user then select that user and return to back page....
            ? TextButton(
                onPressed: () {
                  Get.back(result: controller.filteredList.elementAt(index));
                  controller.filteredList.clear();
                  controller.friendsList.clear();
                  controller.loadFriendsList(isForUpdate: false);
                },
                child: Text('Select',
                    style: AppTextStyles.textStyleBoldBodyMedium))
            : controller.filteredList.elementAt(index).userFk?.id.toString() ==
                    UserDefaults.getCurrentUserId()
                ? getRequestButton(index: index)
                : const IgnorePointer(),
      ),
    );
  }

  Widget getRequestButton({required int index}) {
    switch (controller.filteredList
        .elementAt(index)
        .friendRequestStatus
        .toString()) {
      case 'pending':
        return TextButton(
            onPressed: () {
              controller.removeFriend(index: index);
            },
            child: Column(
              children: [
                Text(
                  'request sent',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.textStyleNormalBodyXSmall
                      .copyWith(color: AppColor.blackColor),
                ),
                Text('Cancel',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.textStyleBoldBodyMedium),
              ],
            ));
      case 'accept':
        return TextButton(
            onPressed: () {
              controller.removeFriend(index: index);
            },
            child: Column(
              children: [
                Text(
                  'friend added',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.textStyleNormalBodyXSmall
                      .copyWith(color: AppColor.blackColor),
                ),
                Text('Remove',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.textStyleBoldBodyMedium),
              ],
            ));
      case 'reject':
        return const IgnorePointer();
    }
    return const IgnorePointer();
  }

  void _showBottomSheet() {
    AppBottomSheets.showAppAlertBottomSheet(
        isFull: false,
        isDismissable: true,
        title: 'Filter by',
        context: myContext!,
        child: Column(
          children: [
            vSpace,
            Button(
              buttonText: 'All',
              textColor: AppColor.whiteColor,
              onTap: () {
                controller.filterListBy('all');
                Get.back();
              },
            ),
            vSpace,
            Button(
              buttonText: 'Request Received',
              textColor: AppColor.whiteColor,
              onTap: () {
                controller.filterListBy('received');
                Get.back();
              },
            ),
            vSpace,
            Button(
              buttonText: 'Request Sent',
              textColor: AppColor.whiteColor,
              onTap: () {
                controller.filterListBy('pending');
                Get.back();
              },
            ),
          ],
        ));
  }
}
