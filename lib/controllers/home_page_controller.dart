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
import 'package:photos_app/models/my_data_response_model.dart';
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

  RxList<MyDataModel> foldersStack = <MyDataModel>[].obs;

  RxList<MyDataModel?> privateDataList = <MyDataModel?>[].obs;
  RxList<MyDataModel?> privateFilteredItemList = <MyDataModel?>[].obs;

  RxList<MyDataModel?> sharedDataList = <MyDataModel?>[].obs;
  RxList<MyDataModel?> sharedFilteredItemList = <MyDataModel?>[].obs;

  RxList<MyDataModel?> receivedDataList = <MyDataModel?>[].obs;
  RxList<MyDataModel?> receivedFilteredItemList = <MyDataModel?>[].obs;

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

  void addNewFile({required MyDataModel item}) async {
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
          /*item.subFolder.add(MyMenuItem(
              name: file.name,
              isFolder: false,
              path: file.path,
              id: const Uuid().v4(),
              icon: icon,
              subItemList: []));*/
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

  openFolder({required MyDataModel item}) {
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

  openFile({required MyDataModel item}) {
    if (!(item.type == 'folder') && item.name != null) {
      AppUtils.openFile(File(item.name ?? ''));
    }
  }

  void loadPrivateFolder({bool showAlert = false}) {
    UserModel? user = UserDefaults.getUserSession();

    Map<String, dynamic> body = {'page': pageToLoad.toString()};
    isLoading.value = true;
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.getMyData,
              body: body,
            ),
            create: () => APIResponse<MyDataModelResponseModel>(
                create: () => MyDataModelResponseModel()),
            apiFunction: loadPrivateFolder)
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

        privateDataList.addAll(model?.results ?? []);
        privateFilteredItemList.addAll(privateDataList);
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

  void loadSharedFolder({bool showAlert = false}) {
    UserModel? user = UserDefaults.getUserSession();

    Map<String, dynamic> body = {'page': pageToLoad.toString()};
    isLoading.value = true;
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.getSharedData,
              body: body,
            ),
            create: () => APIResponse<MyDataModelResponseModel>(
                create: () => MyDataModelResponseModel()),
            apiFunction: loadSharedFolder)
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

        sharedDataList.addAll(model?.results ?? []);
        sharedFilteredItemList.addAll(sharedDataList);
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

  void loadReceivedFolder({bool showAlert = false}) {
    UserModel? user = UserDefaults.getUserSession();

    Map<String, dynamic> body = {'page': pageToLoad.toString()};
    isLoading.value = true;
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.getSharedData,
              body: body,
            ),
            create: () => APIResponse<MyDataModelResponseModel>(
                create: () => MyDataModelResponseModel()),
            apiFunction: loadReceivedFolder)
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

        receivedDataList.addAll(model?.results ?? []);
        receivedFilteredItemList.addAll(receivedDataList);
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
