import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/models/user_model.dart';

import '../common/app_pop_ups.dart';
import '../dio_networking/api_client.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';
import '../models/search_user_response_model.dart';

class SearchUserController extends GetxController {
  RxBool isLoading = false.obs;
  int pageToLoad = 1;
  bool hasNewPage = false;
  TextEditingController searchController = TextEditingController();

  RxList<UserModel?> usersList = <UserModel?>[].obs;
  RxList<UserModel?> filteredItemList = <UserModel?>[].obs;
  ScrollController listViewController = ScrollController();

  String lastQueryUserName = '';

  @override
  void onInit() {
    listViewController.addListener(() {
      if (listViewController.position.extentBefore ==
          listViewController.position.maxScrollExtent) {
        print('end of the page');
        if (hasNewPage) {
          if (searchController.text.isNotEmpty) {
            // searchForFriendFromApi(userName: searchController.text.toString());
          }
        }
      }
    });

    super.onInit();
  }

  void searchForFriendFromApi(
      {required String userName, bool showAlert = false}) {
    isLoading.value = true;

    Map<String, dynamic> data = {"page": pageToLoad, "username": userName};
    APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
        .request(
            needToAuthenticate: true,
            route: APIRoute(
              APIType.searchUniqueUser,
              body: data,
            ),
            create: () => APIResponse<SearchUserResponseModel>(
                create: () => SearchUserResponseModel()),
            apiFunction: searchForFriendFromApi)
        .then((response) async {
      isLoading.value = false;
      SearchUserResponseModel? model = response.response?.data;

      if ((model?.results?.length ?? 0) > 0) {
        if ((model?.next ?? '').isNotEmpty) {
          pageToLoad++;
          hasNewPage = true;
        } else {
          hasNewPage = false;
        }
        usersList.addAll(model?.results ?? []);
        filteredItemList.addAll(usersList);
      } else {
        if (showAlert) {
          AppPopUps.showDialogContent(
              title: 'Alert',
              description: 'No User Found',
              dialogType: DialogType.INFO);
        }
      }
    }).catchError((error) {
      print(error);
      isLoading.value = false;
      AppPopUps.showDialogContent(
          title: 'Error',
          description: error.toString(),
          dialogType: DialogType.ERROR);
      return Future.value(null);
    });
  }
}
