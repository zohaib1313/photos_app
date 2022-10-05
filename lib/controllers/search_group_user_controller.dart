import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/user_defaults.dart';
import 'package:photos_app/models/group_member_response_model.dart';
import 'package:photos_app/models/user_model.dart';
import 'package:photos_app/network_repositories/groups_network_repo.dart';

import '../common/app_pop_ups.dart';
import '../dio_networking/api_client.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';
import '../models/search_user_response_model.dart';

class SearchGroupUserController extends GetxController {
  RxBool isLoading = false.obs;
  int pageToLoad = 1;
  bool hasNewPage = false;
  TextEditingController searchController = TextEditingController();

  RxList<GroupMemberSearchResponseModel?> filteredItemList =
      <GroupMemberSearchResponseModel?>[].obs;
  ScrollController listViewController = ScrollController();

  String lastQueryUserName = '';

  RxSet<int> selectedMemberSet = <int>{}.obs;

  @override
  void onInit() {
    selectedMemberSet.clear();
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

  void searchForMemberFromApi(
      {required String userName,
      required int groupId,
      bool showAlert = false}) async {
    isLoading.value = true;

    APIListResponse<GroupMemberSearchResponseModel>? response =
        await GroupNetworkRepo.searchMemberFromServer(queryMap: {
      "username": userName,
      "group_id": groupId,
      "page": 1,
    });
    isLoading.value = false;

    if (response != null && (response.status ?? false)) {
      isLoading.value = false;

      ///removing current user id...
      /*List<GroupMemberSearchResponseModel> model = model.removeWhere(
          (element) =>
              element.member?.id.toString() ==
              UserDefaults.getCurrentUserId());*/

      filteredItemList.addAll(response.data ?? []);
    }
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
