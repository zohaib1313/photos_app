import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/user_defaults.dart';
import 'package:photos_app/dio_networking/api_client.dart';
import 'package:photos_app/models/friends_list_model_response.dart';
import 'package:photos_app/models/user_model.dart';
import 'package:photos_app/network_repositories/friends_network_repo.dart';
import 'package:photos_app/network_repositories/notification_repo.dart';

import '../common/app_pop_ups.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';
import '../my_application.dart';

class FriendsPageController extends GetxController {
  RxBool isLoading = false.obs;
  int pageToLoad = 1;
  bool hasNewPage = false;
  TextEditingController searchController = TextEditingController();
  RxList<FriendsModel> friendsList = <FriendsModel>[].obs;
  RxList<FriendsModel> filteredList = <FriendsModel>[].obs;
  ScrollController listViewController = ScrollController();

  int requestsReceivedPage = 1;

  void loadFriendsList(
      {bool showAlert = false, required bool getOnlyFriendsAccepted}) async {
    isLoading.value = true;
    try {
      final apiResponse =
          await FriendsNetworkRepo.loadFriendsFromServer(queryMap: {
        'page': pageToLoad,
        '_id': UserDefaults.getCurrentUserId(),
      });
      isLoading.value = false;
      if (apiResponse?.data != null) {
        if (apiResponse?.data?.next != null) {
          pageToLoad++;
        }
        friendsList.addAll(apiResponse?.data?.friendsList ?? []);

        ///filter on only friends if picking up user for shairng files..
        if (getOnlyFriendsAccepted) {
          friendsList.removeWhere(
              (element) => (element.friendRequestStatus != 'accept'));
        }
        filteredList.addAll(friendsList);
      } else {
        if (showAlert) {
          AppPopUps.showDialogContent(
              title: 'Alert',
              description: 'Empty directory',
              dialogType: DialogType.WARNING);
        }
      }
    } catch (e) {
      isLoading.value = false;
      if (showAlert) {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: e.toString(),
            dialogType: DialogType.ERROR);
      }
    }
  }

  void removeFriend({required int id, required dynamic onSuccess}) {
    AppPopUps.showConfirmDialog(
        title: 'Alert',
        message: 'Are you sure remove/cancel',
        onSubmit: () async {
          try {
            ///delete with api and also reminder alarm scheduled

            isLoading.value = true;

            ///to close bottomsheet
            Get.back();
            final apiResponse =
                await FriendsNetworkRepo.removeFriend(data: {"id": id});
            isLoading.value = false;
            if (apiResponse?.success ?? false) {
              onSuccess();
              AppPopUps.showSnackBar(message: 'Removed', context: myContext!);
            } else {
              AppPopUps.showDialogContent(
                  title: 'Error',
                  description: 'Failed to delete',
                  dialogType: DialogType.ERROR);
            }
          } catch (error) {
            isLoading.value = false;
            AppPopUps.showDialogContent(
                title: 'Error',
                description: error.toString(),
                dialogType: DialogType.ERROR);
          }
        });
  }

  Future<void> filterListBy(String filter) async {
    isLoading.value = true;
    filteredList.clear();
    for (final element in friendsList) {
      switch (filter) {
        case 'pending':
          if (element.friendRequestStatus == 'pending') {
            filteredList.add(element);
          }
          break;
        case 'received':
          if (element.friendRequestStatus != 'accept' &&
              element.friendFk?.id.toString() ==
                  UserDefaults.getCurrentUserId()) {
            filteredList.add(element);
          }
          break;
        case 'all':
          filteredList.add(element);
          break;
        case 'friends':
          if (element.friendRequestStatus == 'accept') {
            filteredList.add(element);
          }
          break;
      }
    }
    isLoading.value = false;
  }

  Future<void> getReceivedFriendsRequest({dynamic onRequestOfFriends}) async {
    isLoading.value = true;
    try {
      ///if (friend_fk == current user) id it means these request are received...
      final apiResponse =
          await FriendsNetworkRepo.loadFriendsFromServer(queryMap: {
        'page': requestsReceivedPage,
        'friend_id': UserDefaults.getCurrentUserId(),
      });
      isLoading.value = false;
      if ((apiResponse?.data?.next ?? '').isNotEmpty) {
        requestsReceivedPage++;
      }
      if (apiResponse?.success ?? false) {
        onRequestOfFriends(apiResponse?.data?.friendsList ?? []);
      } else {
        AppPopUps.showSnackBar(
            message: 'Failed to remove', context: myContext!);
      }
    } catch (e) {
      isLoading.value = false;
      AppPopUps.showSnackBar(message: 'Failed to remove', context: myContext!);
      print(e.toString());
    }
  }

  void acceptRequest(
      {required FriendsModel friendModel, required onSuccess}) async {
    isLoading.value = true;
    try {
      UserModel? user = UserDefaults.getUserSession();

      ///if (friend_fk == current user) id it means these request are received...
      final apiResponse =
          await FriendsNetworkRepo.changeFriendRequestStatus(data: {
        'id': friendModel.id.toString(),
        'friend_request_status': 'accept',
      });
      isLoading.value = false;
      if (apiResponse?.success ?? false) {
        ///sending notification.......
        NotificationRepo.sendNotification(
            senderId: user!.id.toString(),
            receiverId: friendModel.userFk!.id!.toString(),
            title: 'Friend request accepted',
            body: '${user.firstName ?? ''} accepted your friend request.');
        onSuccess(apiResponse?.data);
      } else {
        AppPopUps.showSnackBar(
            message: 'Failed to update', context: myContext!);
      }
    } catch (e) {
      isLoading.value = false;
      AppPopUps.showSnackBar(message: 'Failed to update', context: myContext!);
      print(e.toString());
    }
  }
}
