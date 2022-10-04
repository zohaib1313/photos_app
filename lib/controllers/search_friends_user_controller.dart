import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/user_defaults.dart';
import 'package:photos_app/models/user_model.dart';

import '../common/app_pop_ups.dart';
import '../dio_networking/api_client.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';
import '../models/search_user_response_model.dart';

class SearchFriendsUserController extends GetxController {
  RxBool isLoading = false.obs;
  int pageToLoad = 1;
  bool hasNewPage = false;
  TextEditingController searchController = TextEditingController();

  RxList<SearchUserResponseModel?> usersList = <SearchUserResponseModel?>[].obs;
  RxList<SearchUserResponseModel?> filteredItemList =
      <SearchUserResponseModel?>[].obs;
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

    Map<String, dynamic> data = {
      "page": pageToLoad,
      "user_id": UserDefaults.getCurrentUserId(),
      "username": userName
    };
    APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
        .request(
            needToAuthenticate: true,
            route: APIRoute(
              APIType.searchUniqueUser,
              body: data,
            ),
            create: () => APIListResponse<SearchUserResponseModel>(
                create: () => SearchUserResponseModel()),
            apiFunction: searchForFriendFromApi)
        .then((response) async {
      isLoading.value = false;
      List<SearchUserResponseModel> model = response.response?.data ?? [];
      model.removeWhere((element) =>
          element.searchedUser?.id.toString() ==
          UserDefaults.getCurrentUserId());
      usersList.addAll(model);
      filteredItemList.addAll(usersList);

      // if ((model?.results?.length ?? 0) > 0) {
      //  if ((model?.next ?? '').isNotEmpty) {
      //     pageToLoad++;
      //     hasNewPage = true;
      //   } else {
      //     hasNewPage = false;
      //   }
      //
      //   usersList.addAll(model?.results ?? []);
      //
      //   ///removing current user from the list so that it don't show up in the list result.....
      //   ///and user should not sent friend request to ownself.....
      //   usersList.removeWhere((element) =>
      //   element?.id.toString() == UserDefaults.getCurrentUserId());
      //   filteredItemList.addAll(usersList);
      // } else {
      //   if (showAlert) {
      //     AppPopUps.showDialogContent(
      //         title: 'Alert',
      //         description: 'No User Found',
      //         dialogType: DialogType.INFO);
      //   }
      // }
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

  void sendFriendRequest({required String? friendId}) {
    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;

    Map<String, dynamic> data = {
      "friend_fk[0]": friendId,
      "user_fk": UserDefaults.getCurrentUserId(),
      "len": '1',
    };
    APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
        .request(
            needToAuthenticate: true,
            route: APIRoute(
              APIType.sendFriendRequest,
              body: data,
            ),
            create: () => APIResponse(decoding: false),
            apiFunction: sendFriendRequest)
        .then((response) async {
      isLoading.value = false;

      if ((response.response?.success ?? false)) {
        AppPopUps.showDialogContent(
            title: 'success',
            description: 'Friend request sent',
            dialogType: DialogType.SUCCES);
      } else {
        AppPopUps.showDialogContent(
            title: 'Alert',
            description: response.response?.responseMessage ?? '',
            dialogType: DialogType.WARNING);
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
