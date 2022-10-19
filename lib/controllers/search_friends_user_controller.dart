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
import '../network_repositories/notification_repo.dart';

class SearchFriendsUserController extends GetxController {
  RxBool isLoading = false.obs;
  int pageToLoad = 1;
  bool hasNewPage = false;
  TextEditingController searchController = TextEditingController();

  RxList<SearchFriendUserResponseModel?> usersList =
      <SearchFriendUserResponseModel?>[].obs;
  RxList<SearchFriendUserResponseModel?> filteredItemList =
      <SearchFriendUserResponseModel?>[].obs;
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
            create: () => APIListResponse<SearchFriendUserResponseModel>(
                create: () => SearchFriendUserResponseModel()),
            apiFunction: searchForFriendFromApi)
        .then((response) async {
      isLoading.value = false;
      List<SearchFriendUserResponseModel> model = response.response?.data ?? [];
      model.removeWhere((element) =>
          element.searchedUser?.id.toString() ==
          UserDefaults.getCurrentUserId());
      usersList.addAll(model);
      filteredItemList.addAll(usersList);
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

  void sendFriendRequest({required SearchedFriendUserModel? searchUserModel}) {
    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;

    UserModel? user = UserDefaults.getUserSession();
    Map<String, dynamic> data = {
      "friend_fk[0]": searchUserModel?.id,
      "user_fk": user?.id.toString(),
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
        ///Sending notification....
        NotificationRepo.sendNotification(
            senderId: user!.id.toString(),
            receiverId: searchUserModel!.id!.toString(),
            title: 'Friend request received',
            body: '${user.firstName ?? ''} sent you friend request.');
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
