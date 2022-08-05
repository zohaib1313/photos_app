import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/common/app_utils.dart';
import 'package:photos_app/common/constants.dart';
import 'package:photos_app/models/my_folder_model.dart';
import 'package:photos_app/my_application.dart';
import 'package:photos_app/pages/home_page/folder_view_page.dart';
import 'package:uuid/uuid.dart';

import '../common/helpers.dart';
import '../models/my_folder_model.dart';

class HomePageController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController searchController = TextEditingController();

  Rx<MyMenuItem> pinnedMenuFolder = MyMenuItem(
      id: '1',
      name: 'Pinned menu',
      isFolder: true,
      path: 'Pinned menu',
      subItemList: []).obs;

  var sharedMenuItem = MyMenuItem(
      id: '2',
      name: 'Shared menu',
      path: 'Shared menu',
      isFolder: true,
      subItemList: []).obs;

  var privateMenuItem = MyMenuItem(
      id: '3',
      name: 'Private menu',
      path: 'Private menu',
      isFolder: true,
      subItemList: []).obs;

  void addNewFolder({required MyMenuItem item}) async {
    await AppPopUps.showOneInputDialog(
        title: 'Enter Folder Name',
        description: 'enter folder name to create',
        onSubmit: (value) {
          isLoading.value = true;
          final folderId = const Uuid().v4();
          item.subItemList.add(MyMenuItem(
              id: folderId,
              name: value,
              path: "${item.path}/$value",
              isFolder: true,
              subItemList: []));
          isLoading.value = false;
        });
  }

  void addNewFile({required MyMenuItem item}) async {
    try {
      List<PlatformFile>? files = await AppUtils.pickMultipleFiles();
      if (files != null) {
        isLoading.value = true;

        for (var file in files) {
//       File fileOwn= File(file.path!);
          /*      printWrapped(file.path.toString());
        printWrapped(file.extension.toString());
        printWrapped(file.name.toString());*/
          Widget? icon = _getFileIcon(file: file);
          item.subItemList.add(MyMenuItem(
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
    }
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

  RxList<MyMenuItem> foldersStack = <MyMenuItem>[].obs;

  openFolder({required MyMenuItem item}) {
    if (foldersStack.isEmpty) {
      foldersStack.add(item);
      Get.to(const FolderViewPage(), preventDuplicates: false);
    } else {
      foldersStack.add(item);
    }
    printWrapped(foldersStack.length.toString());
  }

  Future<bool> closeLastFolder() {
    foldersStack.removeLast();
    return Future.value(foldersStack.isEmpty);
  }

  openFile({required MyMenuItem item}) {
    if (!item.isFolder && item.path != null) {
      AppUtils.openFile(File(item.path!));
    }
  }
}
