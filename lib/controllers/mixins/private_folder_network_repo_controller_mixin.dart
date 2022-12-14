import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/common/app_utils.dart';
import 'package:photos_app/common/constants.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/models/my_data_model.dart';
import 'package:photos_app/models/my_data_response_model.dart';
import 'package:photos_app/models/user_model.dart';
import 'package:photos_app/my_application.dart';
import 'package:photos_app/pages/home_page/private_folder/private_folder_view_page.dart';

import '../../common/user_defaults.dart';
import '../../dio_networking/api_client.dart';
import '../../dio_networking/api_response.dart';
import '../../dio_networking/api_route.dart';
import '../../dio_networking/app_apis.dart';
import '../../models/friends_list_model_response.dart';
import '../../models/groups_response_model.dart';
import '../../network_repositories/notification_repo.dart';

mixin PrivateFolderNetworkContentControllerMixin on GetxController {
  int pageToLoad = 1;
  bool hasNewPage = false;
  RxBool isLoading = false.obs;
  RxList<MyDataModel> privateFoldersStack = <MyDataModel>[].obs;

  Future<void> addNewFolderFile({
    bool showAlert = false,
    required String name,
    required String parentId,
    required String userId,
    String filePath = '',
    required onSuccess,
  }) async {
    printWrapped('fileee nameee');
    printWrapped(name);

    Map<String, dynamic> body = {
      "name": name,
      "type": (filePath != '') ? 'file' : 'folder',
      "user_fk": userId,
      "parent_fk": parentId,
    };

    if (filePath != '') {
      body['doc_file'] =
          await dio.MultipartFile.fromFile(filePath, filename: name);
    }

    var data = dio.FormData.fromMap(body);
    isLoading.value = true;
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.postMyData,
              body: data,
            ),
            create: () => APIResponse<MyDataModel>(create: () => MyDataModel()),
            apiFunction: addNewFolderFile)
        .then((response) {
      isLoading.value = false;
      var result = (response.response?.success ?? false);

      if (result) {
        onSuccess();
        if (showAlert) {
          AppPopUps.showDialogContent(
              title: 'Alert',
              description: 'Document added',
              dialogType: DialogType.INFO);
        }
      } else {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: 'Failed to add document',
            dialogType: DialogType.ERROR);
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

  Future<List<MyDataModel>?> loadPrivateFolder({
    bool showAlert = false,
    required MyDataModel model,
    required subListItem,
  }) async {
    try {
      Map<String, dynamic> body = {
        'page': pageToLoad.toString(),
        'user_id': model.userFk?.toString(),
        'parent_id': model.id?.toString() ?? '',
      };
      isLoading.value = true;
      var response =
          await APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
              .request(
                  route: APIRoute(
                    APIType.getMyData,
                    body: body,
                  ),
                  create: () => APIResponse<MyDataModelResponseModel>(
                      create: () => MyDataModelResponseModel()),
                  apiFunction: loadPrivateFolder);
      isLoading.value = false;
      List<MyDataModel> myDateModelList =
          response.response?.data?.results ?? [];

      if (myDateModelList.isNotEmpty) {
        subListItem(myDateModelList);
      } else {
        subListItem(null);
      }
      return Future.value(myDateModelList);
    } catch (error) {
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return null;
    }
  }

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
      isLoading.value = true;
      AppUtils.showPicker(
          onBottomSheetClosed: () {
            isLoading.value = false;
          },
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
    print(
        "***********opening folder folder stack length is =${privateFoldersStack.length}***********");

    if (privateFoldersStack.isEmpty) {
      privateFoldersStack.add(item);

      Get.to(() => const PrivateFolderViewPage(), preventDuplicates: false);
      //    Get.toNamed(PrivateFolderViewPage.id, preventDuplicates: false);
    } else {
      privateFoldersStack.add(item);
    }
  }

  Future<bool> closeLastFolder() {
    if (privateFoldersStack.isNotEmpty) {
      privateFoldersStack.removeLast();
    }
    return Future.value(privateFoldersStack.isEmpty);
  }

  openFile({required MyDataModel item, required isLoading}) {
    if ((item.type == 'file') && item.docFile != null) {
      AppUtils.downloadAndOpenFile(url: item.docFile, isLoading: isLoading);
    }
  }

  void shareFolderWithFriend(
      {required FriendsModel friendModel,
      required int contentKey,
      bool showAlert = false,
      required onSuccess}) async {
    UserModel? user = UserDefaults.getUserSession();

    Map<String, dynamic> body = {
      "shared_by_fk": user!.id.toString(),
      "shared_with_fk": friendModel.friendFk?.id.toString(),
      "content_fk": contentKey
    };

    var data = dio.FormData.fromMap(body);
    isLoading.value = true;
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.postShareData,
              body: data,
            ),
            create: () => APIResponse(decoding: false),
            apiFunction: shareFolderWithFriend)
        .then((response) {
      isLoading.value = false;

      if ((response.response?.success ?? false)) {
        onSuccess();

        NotificationRepo.sendNotification(
            senderId: user.id.toString(),
            receiverId: friendModel.friendFk!.id.toString(),
            title: 'Document received',
            body: '${user.firstName ?? ''} shared a document with you.');

        if (showAlert) {
          AppPopUps.showSnackBar(
              color: Colors.green,
              message: 'Document shard',
              context: myContext!);
        }
      } else {
        AppPopUps.showSnackBar(
            message: response.response?.responseMessage ?? 'Failed to share.',
            context: myContext!);
      }
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showSnackBar(message: '$error', context: myContext!);

      return Future.value(null);
    });
  }

  void shareContentWithGroup(
      {required GroupModel groupModel,
      required int contentKey,
      required bool showAlert,
      required onSuccess}) async {
    UserModel? user = UserDefaults.getUserSession();

    Map<String, dynamic> body = {
      "content_fk": contentKey,
      "user_fk": user!.id.toString(),
      "group_fk": groupModel.id.toString()
    };

    isLoading.value = true;
    APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
        .request(
            route: APIRoute(
              APIType.shareDataInGroup,
              body: dio.FormData.fromMap(body),
            ),
            create: () => APIResponse(decoding: false),
            apiFunction: shareContentWithGroup)
        .then((response) {
      isLoading.value = false;

      if ((response.response?.success ?? false)) {
        onSuccess();

        ///sending notification to each member of the group....
        groupModel.members?.forEach((element) {
          Future.delayed(const Duration(seconds: 2), () {
            if (element.id != user.id) {
              NotificationRepo.sendNotification(
                  senderId: user.id.toString(),
                  receiverId: element.id.toString(),
                  title: 'Document received',
                  body: '${user.firstName ?? ''} shared a document with you.');
            }
          });
        });

        if (showAlert) {
          AppPopUps.showSnackBar(
              color: Colors.green,
              message: 'Document shared',
              context: myContext!);
        }
      } else {
        AppPopUps.showSnackBar(
            message:
                response.response?.responseMessage ?? 'Document sharing failed',
            context: myContext!);
      }
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showSnackBar(
          message: 'Document sharing failed $error', context: myContext!);

      return Future.value(null);
    });
  }

  void deleteContent(
      {required int contentKey,
      bool showAlert = false,
      required onSuccess}) async {
    isLoading.value = true;
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.deleteContent,
              body: {"id": contentKey},
            ),
            create: () => APIResponse(decoding: false),
            apiFunction: deleteContent)
        .then((response) {
      isLoading.value = false;

      if ((response.response?.success ?? false)) {
        onSuccess();

        if (showAlert) {
          AppPopUps.showSnackBar(
              message: 'Document deleted', context: myContext!);
        }
      } else {
        AppPopUps.showSnackBar(
            message: 'Document delete failed', context: myContext!);
      }
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showSnackBar(
          message: 'Document delete failed $error', context: myContext!);

      return Future.value(null);
    });
  }

  void refreshCurrentViewList(MyDataModel item) {
    if (privateFoldersStack.isNotEmpty) {
      privateFoldersStack.removeLast();
      privateFoldersStack.add(item);
    }
  }
}
