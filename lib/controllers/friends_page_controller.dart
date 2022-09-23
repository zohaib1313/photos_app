import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/user_defaults.dart';
import 'package:photos_app/models/friends_list_model_response.dart';
import 'package:photos_app/network_repositories/friends_network_repo.dart';

import '../common/app_pop_ups.dart';
import '../my_application.dart';

class FriendsPageController extends GetxController {
  RxBool isLoading = false.obs;
  int pageToLoad = 1;
  bool hasNewPage = false;
  TextEditingController searchController = TextEditingController();
  RxList<FriendsModel> friendsList = <FriendsModel>[].obs;
  RxList<FriendsModel> filteredList = <FriendsModel>[].obs;
  ScrollController listViewController = ScrollController();

  void loadFriendsList(
      {bool showAlert = false, required bool isForUpdate}) async {
    isLoading.value = true;
    try {
      final apiResponse =
          await FriendsNetworkRepo.loadFriendsFromServer(queryMap: {
        'page': pageToLoad,
        'user_id': UserDefaults.getCurrentUserId(),
      });
      isLoading.value = false;
      if (apiResponse?.data != null) {
        if (apiResponse?.data?.next != null) {
          pageToLoad++;
        }
        friendsList.addAll(apiResponse?.data?.friendsList ?? []);

        ///filter on only friends if picking up user for shairng files..
        if (isForUpdate) {
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

  void removeFriend({required int index}) {
    AppPopUps.showConfirmDialog(
        title: 'Alert',
        message: 'Are you sure remove/cancel',
        onSubmit: () async {
          try {
            ///delete with api and also reminder alarm scheduled

            isLoading.value = true;

            ///to close bottomsheet
            Get.back();
            final apiResponse = await FriendsNetworkRepo.removeFriend(
                data: {"id": filteredList.elementAt(index).id});
            isLoading.value = false;
            if (apiResponse?.success ?? false) {
              AppPopUps.showSnackBar(message: 'Removed', context: myContext!);
              friendsList.removeAt(index);
              filteredList.removeAt(index);
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

  void filterListBy(String filter) {
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

          ///if (friend_fk == current user) id it means these request are received...
          if (element.friendFk?.id.toString() ==
              UserDefaults.getCurrentUserId()) {
            filteredList.add(element);
          }
          break;
        case 'all':
          filteredList.add(element);
          break;
      }
    }
    isLoading.value = false;
  }
}
