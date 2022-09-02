import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/common/app_utils.dart';
import 'package:photos_app/common/constants.dart';
import 'package:photos_app/models/my_data_model.dart';
import 'package:photos_app/models/my_menu_item_model.dart';
import 'package:photos_app/models/my_model_response_model.dart';
import 'package:photos_app/my_application.dart';
import 'package:photos_app/pages/home_page/folder_view_page.dart';
import 'package:uuid/uuid.dart';

import '../common/helpers.dart';
import '../common/user_defaults.dart';
import '../dio_networking/api_client.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';
import '../models/my_menu_item_model.dart';
import '../models/user_model.dart';

class HomePageController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController searchController = TextEditingController();
  int pageToLoad = 1;
  bool hasNewPage = false;

  RxList<MyDataModel?> myDataList = <MyDataModel?>[].obs;
  RxList<MyDataModel?> filteredItemList = <MyDataModel?>[].obs;

  Rx<MyMenuItem> pinnedMenuFolder = MyMenuItem(
      id: '1',
      name: 'Pinned',
      isFolder: true,
      path: 'Pinned',
      subItemList: []).obs;

  var sharedMenuItem = MyMenuItem(
      id: '2',
      name: 'Shared',
      path: 'Shared',
      isFolder: true,
      subItemList: []).obs;

  var privateMenuItem = MyMenuItem(
      id: '3',
      name: 'Private',
      path: 'Private',
      isFolder: true,
      subItemList: []).obs;

  var receivedMenuItem = MyMenuItem(
      id: '4',
      name: 'Received',
      path: 'Received',
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

  void loadFolders({bool showAlert = false}) {
    UserModel? user = UserDefaults.getUserSession();

    Map<String, dynamic> body = {'page': pageToLoad.toString()};
    isLoading.value = true;
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.getReminders,
              body: body,
            ),
            create: () => APIResponse<MyDataModelResponseModel>(
                create: () => MyDataModelResponseModel()),
            apiFunction: loadFolders)
        .then((response) {
      isLoading.value = false;
      MyDataModelResponseModel? model = response.response?.data;

      if ((model?.results?.length ?? 0) > 0) {
        if ((model?.next ?? '').isNotEmpty) {
          pageToLoad++;
          hasNewPage = true;
        } else {
          hasNewPage = false;
        }
        myDataList.addAll(model?.results ?? []);
        filteredItemList.addAll(myDataList);
      } else {
        if (showAlert) {
          AppPopUps.showDialogContent(
              title: 'Alert',
              description: 'No result found',
              dialogType: DialogType.INFO);
        }
      }
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }
}
