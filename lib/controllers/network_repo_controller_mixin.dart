import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/models/my_data_model.dart';
import 'package:photos_app/models/my_data_response_model.dart';

import '../dio_networking/api_client.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';

mixin NetworkContentControllerMixin on GetxController {
  int pageToLoad = 1;
  bool hasNewPage = false;
  RxBool isLoading = false.obs;
  RxList<MyDataModel?> sharedDataList = <MyDataModel?>[].obs;
  RxList<MyDataModel?> sharedFilteredItemList = <MyDataModel?>[].obs;

  RxList<MyDataModel?> receivedDataList = <MyDataModel?>[].obs;
  RxList<MyDataModel?> receivedFilteredItemList = <MyDataModel?>[].obs;

  Future<void> addNewFolderFile({
    bool showAlert = false,
    required String name,
    required String parentId,
    required String userId,
    String filePath = '',
    required onSuccess,
  }) async {
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

  void loadPrivateFolder({
    bool showAlert = false,
    required MyDataModel model,
    required subListItem,
  }) {
    Map<String, dynamic> body = {
      'page': pageToLoad.toString(),
      'user_id': model.userFk?.toString(),
      'parent_id': model.id?.toString() ?? '',
    };
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

      List<MyDataModel> myDateModelList =
          response.response?.data?.results ?? [];
      if (myDateModelList.isNotEmpty) {
        subListItem(myDateModelList);
      } else {
        subListItem(null);
      }

      /*if (myDateModelList.isNotEmpty) {
        onComplete(myDateModelList);
      } else {
        AppPopUps.showDialogContent(
            title: 'Alert',
            description: 'Folder is empty add new file or folder',
            dialogType: DialogType.INFO);
      }*/
    }).catchError((error) {
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }

/* void loadSharedFolder({bool showAlert = false}) {
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
  }*/
}
