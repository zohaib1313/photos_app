import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/common/app_utils.dart';
import 'package:photos_app/common/constants.dart';
import 'package:photos_app/models/my_data_model.dart';
import 'package:photos_app/my_application.dart';
import 'package:photos_app/pages/home_page/folder_view_page.dart';

import '../common/user_defaults.dart';
import '../models/user_model.dart';
import 'network_repo_controller_mixin.dart';

class HomePageController extends GetxController
    with NetworkContentControllerMixin {
  UserModel? user = UserDefaults.getUserSession();

  TextEditingController searchController = TextEditingController();

  RxList<MyDataModel> foldersStack = <MyDataModel>[].obs;

  void addNewFolder({required MyDataModel item}) async {
    print("adding new folder on ${item.toString()}");
    await AppPopUps.showOneInputDialog(
        title: 'Enter Folder Name',
        description: 'Enter folder name to create',
        onSubmit: (folderName) {
          addNewFolderFile(
              name: folderName,
              parentId: item.id.toString(),
              userId: UserDefaults.getCurrentUserId().toString(),
              onSuccess: () {
                loadPrivateFolder(
                    model: item,
                    subListItem: (List<MyDataModel>? dataList) {
                      ///list of current folder
                      if (dataList != null) {
                        item.subFolder.clear();
                        item.subFolder.addAll(dataList);
                        refreshCurrentViewList(item);
                      }
                    });
              });
        });
  }

  void addNewFile(
      {required MyDataModel item, required BuildContext context}) async {
    try {
      AppUtils.showPicker(
          context: context,
          onComplete: (File? file) {
            if (file != null) {
              isLoading.value = true;

              addNewFolderFile(
                  name: basename(file.path),
                  parentId: item.id.toString(),
                  filePath: file.path.toString(),
                  userId: UserDefaults.getCurrentUserId().toString(),
                  onSuccess: () {
                    loadPrivateFolder(
                        model: item,
                        subListItem: (List<MyDataModel>? dataList) {
                          ///list of current folder
                          if (dataList != null) {
                            item.subFolder.clear();
                            item.subFolder.addAll(dataList);
                            refreshCurrentViewList(item);
                          }
                        });
                  });
            }
          });
    } catch (e) {
      isLoading.value = false;
      AppPopUps.showSnackBar(
          message: 'Failed to add file', context: myContext!);
    }

    /* try {
      List<PlatformFile>? files = await AppUtils.pickMultipleFiles();
      if (files != null) {
        isLoading.value = true;

        for (var file in files) {
      File fileOwn= File(file.path!);
                printWrapped(file.path.toString());
        printWrapped(file.extension.toString());
        printWrapped(file.name.toString());
          Widget? icon = _getFileIcon(file: file);
          item.subFolder.add(MyMenuItem(
              name: file.name,
              isFolder: false,
              path: file.path,
              id: const Uuid().v4(),
              icon: icon,
              subItemList: []));
        }
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      AppPopUps.showSnackBar(
          message: 'Failed to add file', context: myContext!);
    }*/
  }

  Widget? _getFileIcon({required PlatformFile file}) {
    if (AppConstants.imageFilesExtension.contains(file.extension)) {
      ///its an image
      if (file.path != null) {
        return Image.file(
          File(file.path!),
          fit: BoxFit.fill,
        );
      }
    }
  }

  openFolder({required MyDataModel item}) {
    print("***********opening folder***********");
    print(item.id);
    if (foldersStack.isEmpty) {
      foldersStack.add(item);
      Get.to(() => const FolderViewPage(), preventDuplicates: false);
    } else {
      foldersStack.add(item);
    }
  }

  Future<bool> closeLastFolder() {
    foldersStack.removeLast();
    return Future.value(foldersStack.isEmpty);
  }

  openFile({required MyDataModel item}) {
    if (!(item.type == 'folder') && item.name != null) {
      AppUtils.openFile(File(item.name ?? ''));
    }
  }

  void refreshCurrentViewList(MyDataModel item) {
    if (foldersStack.isNotEmpty) {
      foldersStack.removeLast();
      foldersStack.add(item);
    }
  }
}
