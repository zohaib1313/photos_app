import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart';

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

  void addNewGroup({bool showAlert = false}) async {
    if (profileImage.value == null) {
      AppPopUps.showConfirmDialog(message: 'Select Cover Image', title: "");
      return;
    }

    ///close sheet
    Get.back();
    isLoading.value = true;

    final data = dio.FormData.fromMap({
      "group_photo": await dio.MultipartFile.fromFile(profileImage.value!.path,
          filename: basename(profileImage.value!.path)),
      "group_name": groupTitleController.text.trim(),
      "description": groupDescriptionController.text.trim(),
      "admin_fk": UserDefaults.getCurrentUserId()
    });

    try {
      final apiResponse = await GroupNetworkRepo.addNewGroup(data: data);
      isLoading.value = false;

      if ((apiResponse?.success ?? false) && apiResponse?.data != null) {
        AppPopUps.showDialogContent(
            title: 'Success',
            description: 'Group Added',
            dialogType: DialogType.SUCCES);
        groupList.add(apiResponse!.data!);
        filteredList.add(apiResponse.data!);
      } else {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: 'Failed to add',
            dialogType: DialogType.ERROR);
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

  void deleteGroup({required GroupModel group, bool showAlert = false}) async {
    AppPopUps.showConfirmDialog(
        title: 'Confirm',
        message: 'Are you sure to delete this group',
        onSubmit: () async {
          ///to close dialog....
          Get.back();
          isLoading.value = true;
          try {
            final apiResponse = await GroupNetworkRepo.deleteGroup(
                data: {'id': group.id.toString()});
            isLoading.value = false;

            if (apiResponse?.success ?? false) {
              debugPrint('Group deleted');
              filteredList.remove(group);
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
        });
  }
}
