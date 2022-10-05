import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/common_widgets.dart';
import 'package:photos_app/common/spaces_boxes.dart';
import 'package:photos_app/my_application.dart';

import '../../../../common/loading_widget.dart';
import '../../common/app_alert_bottom_sheet.dart';
import '../../common/helpers.dart';
import '../../common/my_search_bar.dart';
import '../../common/styles.dart';
import '../../common/user_defaults.dart';
import '../../controllers/friends_page_controller.dart';
import '../../models/friends_list_model_response.dart';
import 'search_friends_user_page.dart';

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
                  await Get.toNamed(SearchFriendsUserPage.id);
                  controller.friendsList.clear();
                  controller.filteredList.clear();
                  controller.loadFriendsList(
                      showAlert: true, getOnlyFriendsAccepted: isForUpdate);
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
            controller.loadFriendsList(getOnlyFriendsAccepted: isForUpdate);
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
                          Text("No Record Found",
                              style: AppTextStyles.textStyleBoldBodyMedium),
                          InkWell(
                            onTap: () {
                              controller.filteredList.clear();
                              controller.friendsList.clear();
                              controller.loadFriendsList(
                                  showAlert: true,
                                  getOnlyFriendsAccepted: isForUpdate);
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
                              showAlert: true,
                              getOnlyFriendsAccepted: isForUpdate);
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
              url: controller.filteredList
                          .elementAt(index)
                          .friendFk
                          ?.id
                          .toString() ==
                      UserDefaults.getCurrentUserId()
                  ? controller.filteredList.elementAt(index).userFk?.photo ?? ''
                  : controller.filteredList.elementAt(index).friendFk?.photo ??
                      ''),
        ),
        title: Text(
          controller.filteredList.elementAt(index).friendFk?.id.toString() ==
                  UserDefaults.getCurrentUserId()
              ? controller.filteredList.elementAt(index).userFk?.username ?? '-'
              : controller.filteredList.elementAt(index).friendFk?.username ??
                  '-',
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
                  controller.loadFriendsList(getOnlyFriendsAccepted: false);
                },
                child: Text('Select',
                    style: AppTextStyles.textStyleBoldBodyMedium))
            : getRequestButton(index: index),
      ),
    );
  }

  Widget getRequestButton({required int index}) {
    switch (controller.filteredList
        .elementAt(index)
        .friendRequestStatus
        .toString()) {
      case 'pending':

        ///request has received and you can accept it only...
        if (controller.filteredList.elementAt(index).friendFk?.id.toString() ==
            UserDefaults.getCurrentUserId()) {
          return SizedBox(
            width: 150,
            child: Row(
              children: [
                Button(
                    buttonText: 'Accept',
                    color: AppColor.greenColor,
                    //  ...unable to update friend request due to not allowed....
                    onTap: () {
                      controller.acceptRequest(
                          id: controller.filteredList.elementAt(index).id!,
                          onSuccess: (FriendsModel? f) {
                            if (f != null) {
                              controller.filteredList[index] = f;
                            }
                          });
                    }),
                hSpace,
                Button(
                    buttonText: 'Reject',
                    color: AppColor.redColor,
                    onTap: () {
                      controller.removeFriend(
                          id: controller.filteredList.elementAt(index).id!,
                          onSuccess: () {
                            controller.filteredList.removeAt(index);
                          });
                    }),
              ],
            ),
          );
        } else {
          ///request has been sent by you
          return TextButton(
              onPressed: () {
                controller.removeFriend(
                    id: controller.filteredList.elementAt(index).id!,
                    onSuccess: () {
                      controller.filteredList.removeAt(index);
                    });
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
        }
      case 'accept':
        return TextButton(
            onPressed: () {
              controller.removeFriend(
                  id: controller.filteredList.elementAt(index).id!,
                  onSuccess: () {
                    controller.filteredList.removeAt(index);
                  });
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
        child: ListView(
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
              buttonText: 'friends',
              textColor: AppColor.whiteColor,
              onTap: () {
                controller.filterListBy('friends');
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
                /*  controller.requestsReceivedPage = 1;
                Get.back();
                controller.getReceivedFriendsRequest(
                    onRequestOfFriends: (List<FriendsModel> friensList) {
                  showFriendRequestedBottomSheet(friendsList: friensList);
                });*/
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

  void showFriendRequestedBottomSheet(
      {required List<FriendsModel> friendsList}) {
    AppBottomSheets.showAppAlertBottomSheet(
      isFull: true,
      isDismissable: false,
      title: 'Requests',
      context: myContext!,
      child: ListView.builder(
        itemCount: friendsList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Padding(
                padding: const EdgeInsets.all(4.0),
                child: NetworkCircularImage(
                    url: friendsList.elementAt(index).userFk?.photo ?? ''),
              ),
              title: Text(friendsList.elementAt(index).userFk?.username ?? '',
                  style: AppTextStyles.textStyleBoldBodyMedium),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "${friendsList.elementAt(index).friendFk?.username ?? ''} sent you request",
                      style: AppTextStyles.textStyleNormalBodyXSmall),
                  vSpace,
                  Row(
                    children: [
                      Button(
                          buttonText: 'Accept',
                          color: AppColor.greenColor,
                          //  ...unable to update friend request due to not allowed....
                          onTap: () {
                            controller.acceptRequest(
                                id: friendsList.elementAt(index).id!,
                                onSuccess: (FriendsModel? f) {
                                  if (f != null) friendsList[0] = f;
                                });
                          }),
                      hSpace,
                      Button(
                          buttonText: 'Reject',
                          color: AppColor.redColor,
                          onTap: () {
                            controller.removeFriend(
                                id: friendsList.elementAt(index).id!,
                                onSuccess: () {
                                  controller.filteredList.removeAt(index);
                                });
                          }),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
