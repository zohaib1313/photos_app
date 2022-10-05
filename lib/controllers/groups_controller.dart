import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:path/path.dart';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/dio_networking/api_response.dart';
import 'package:photos_app/models/groups_response_model.dart';
import 'package:photos_app/models/user_model.dart';
import 'package:photos_app/my_application.dart';
import 'package:photos_app/network_repositories/groups_network_repo.dart';

import '../common/app_pop_ups.dart';
import '../common/user_defaults.dart';

class GroupsController extends GetxController {
  RxBool isLoading = false.obs;

  int pageToLoad = 1;

  bool hasNewPage = false;

  RxList<GroupModel> filteredList = <GroupModel>[].obs;

  ScrollController listViewController = ScrollController();

  TextEditingController searchController = TextEditingController();

  TextEditingController groupTitleController = TextEditingController();

  TextEditingController groupDescriptionController = TextEditingController();

  Rxn<File?> profileImage = Rxn<File>();

  void updateGroup({required int index, bool showAlert = true}) async {
    Map<String, dynamic> map = {
      "id": filteredList.elementAt(index).id.toString(),
      "group_name": groupTitleController.text.trim(),
      "description": groupDescriptionController.text.trim(),
    };
    if (profileImage.value != null) {
      map['group_photo'] = await dio.MultipartFile.fromFile(
          profileImage.value!.path,
          filename: basename(profileImage.value!.path));
    }

    ///close sheet
    Get.back();
    isLoading.value = true;

    try {
      final apiResponse = await GroupNetworkRepo.updateGroup(data: map);
      isLoading.value = false;

      if ((apiResponse?.success ?? false) && apiResponse?.data != null) {
        AppPopUps.showDialogContent(
            title: 'Success',
            description: 'Group updated',
            dialogType: DialogType.SUCCES);
        filteredList[index] = apiResponse!.data!;
      } else {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: 'Failed to updated',
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

        filteredList.add(apiResponse!.data!);
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
        'member_fk': UserDefaults.getCurrentUserId(),
      });
      isLoading.value = false;
      if (apiResponse?.data != null) {
        if (apiResponse?.data?.next != null) {
          pageToLoad++;
        }

        ///adding all groups .....
        apiResponse?.data?.groupModelList?.forEach((element) {
          filteredList.add(element.groupModel!);
        });
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

  void removeMemberFromGroup(
      {required UserModel user,
      required int groupId,
      required onSuccess,
      bool showAlert = true}) async {
    AppPopUps.showConfirmDialog(
        title: 'Confirm',
        message: 'Are you sure to remove this user',
        onSubmit: () async {
          ///to close dialog....
          Get.back();
          isLoading.value = true;
          try {
            final apiResponse = await GroupNetworkRepo.deleteMemberFromGroup(
                data: {"member_fk": user.id.toString(), "group_fk": groupId});
            isLoading.value = false;

            if (apiResponse?.success ?? false) {
              debugPrint('Group deleted');
              AppPopUps.showSnackBar(
                  message: 'member deleted', context: myContext!);
              onSuccess();
            } else {
              if (showAlert) {
                AppPopUps.showDialogContent(
                    title: 'Alert',
                    description: 'User not found',
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

  void addMemberInGroup(
      {required GroupModel groupModel,
      required List<int> groupMemberIdsList,
      required onSuccess}) async {
    isLoading.value = true;
    Map<String, dynamic> map = {
      "approved": "True",
      "group_fk": groupModel.id.toString(),
      "len": groupMemberIdsList.length,
    };
    for (var i = 0; i < groupMemberIdsList.length; i++) {
      map["member_fk[$i]"] = groupMemberIdsList[i];
    }

    APIResponse? response = await GroupNetworkRepo.addMemberInGroup(data: map);
    isLoading.value = false;
    if (response?.success ?? false) {
      AppPopUps.showSnackBar(message: 'Members added', context: myContext!);
    }
  }
}
