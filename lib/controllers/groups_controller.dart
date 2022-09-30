import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/models/groups_response_model.dart';
import 'package:photos_app/network_repositories/groups_network_repo.dart';

import '../common/app_pop_ups.dart';
import '../common/user_defaults.dart';

class GroupsController extends GetxController {
  RxBool isLoading = false.obs;

  int pageToLoad = 1;

  bool hasNewPage = false;
  RxList<GroupModel> groupList = <GroupModel>[].obs;

  RxList<GroupModel> filteredList = <GroupModel>[].obs;

  ScrollController listViewController = ScrollController();

  TextEditingController searchController = TextEditingController();

  TextEditingController groupTitleController = TextEditingController();

  TextEditingController groupDescriptionController = TextEditingController();

  Rxn<File?> profileImage = Rxn<File>();

  void updateGroup({required int index}) {}

  void addNewGroup() {}

  void loadGroups({bool showAlert = false}) async {
    isLoading.value = true;
    try {
      final apiResponse =
          await GroupNetworkRepo.loadGroupsFromServer(queryMap: {
        'page': pageToLoad,
        'admin_fk': UserDefaults.getCurrentUserId(),
      });
      isLoading.value = false;
      if (apiResponse?.data != null) {
        if (apiResponse?.data?.next != null) {
          pageToLoad++;
        }
        groupList.addAll(apiResponse?.data?.groupModelList ?? []);

        filteredList.addAll(groupList);
      } else {
        if (showAlert) {
          AppPopUps.showDialogContent(
              title: 'Alert',
              description: 'No Group found',
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

  void clearLists() {
    groupList.clear();
    filteredList.clear();
  }
}
