import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get.dart';
import 'package:photos_app/models/shared_data_response_model.dart';

import '../../common/app_pop_ups.dart';
import '../../dio_networking/api_client.dart';
import '../../dio_networking/api_response.dart';
import '../../dio_networking/api_route.dart';
import '../../dio_networking/app_apis.dart';
import '../../models/my_data_model.dart';

mixin SharedReceivedDataNetworkRepoMixin on GetxController {
  int pageToLoad = 1;
  bool hasNewPage = false;
  RxBool isLoading = false.obs;

  RxList<SharedReceivedDataModel> sharedReceivedFolderStack =
      <SharedReceivedDataModel>[].obs;

  void loadSharedReceivedData({
    bool showAlert = false,
    required MyDataModel model,
    required bool isForShareFolder,
    required subListItem,
  }) {
    Map<String, dynamic> body = {
      'page': pageToLoad.toString(),
      isForShareFolder ? 'shared_by' : 'shared_with': model.userFk?.toString(),
    };
    isLoading.value = true;
    APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
        .request(
            route: APIRoute(
              APIType.getSharedReceivedData,
              body: body,
            ),
            create: () => APIResponse<SharedReceivedDataResponseModel>(
                create: () => SharedReceivedDataResponseModel()),
            apiFunction: loadSharedReceivedData)
        .then((response) {
      isLoading.value = false;

      SharedReceivedDataResponseModel? sharedReceivedDataResponseModel =
          response.response?.data;

      if (sharedReceivedDataResponseModel != null) {
        subListItem(
            sharedReceivedDataResponseModel.sharedReceivedDataModelList);
      } else {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: 'Empty directory',
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
}
