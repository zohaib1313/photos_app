import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:photos_app/models/notes_response_model.dart';

import '../common/app_pop_ups.dart';
import '../common/extensions.dart';
import '../common/helpers.dart';
import '../common/user_defaults.dart';
import '../dio_networking/api_client.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';
import '../models/reminder_response_model.dart';
import '../models/user_model.dart';
import '../my_application.dart';

class NotesController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<NotesModel?> notesList = <NotesModel?>[].obs;
  RxList<NotesModel?> filteredItemList = <NotesModel?>[].obs;

  TextEditingController searchController = TextEditingController();
  TextEditingController notesContentController = TextEditingController();
  TextEditingController notesNameController = TextEditingController();

  int pageToLoad = 1;
  bool hasNewPage = false;

  ScrollController listViewController = ScrollController();

  @override
  void onInit() {
    listViewController.addListener(() {
      if (listViewController.position.extentBefore ==
          listViewController.position.maxScrollExtent) {
        print('end of the page');
        if (hasNewPage) {
          getNotes();
        }
      }
    });
    searchController.addListener(searchFromList);

    super.onInit();
  }

  void searchFromList() {
    printWrapped('searching');
    filteredItemList.clear();
    if (searchController.text.isEmpty) {
      filteredItemList.addAll(notesList);
    } else {
      String query = searchController.text.toLowerCase();
      for (var element in notesList) {
        if (((element?.name ?? "null").toLowerCase()).contains(query)) {
          filteredItemList.add(element);
        }
      }
    }
    printWrapped(filteredItemList.length.toString());
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final before = notification.metrics.extentBefore;
      final max = notification.metrics.maxScrollExtent;

      if (before == max) {
        printWrapped("end of the page");
        if (hasNewPage) {
          getNotes();
        } // load next page
        // code here will be called only if scrolled to the very bottom
      }
    }
    return false;
  }

  void getNotes({bool showAlert = false}) {
    UserModel? user = UserDefaults.getUserSession();

    Map<String, dynamic> body = {'page': pageToLoad.toString()};
    isLoading.value = true;
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            route: APIRoute(
              APIType.getNotes,
              body: body,
            ),
            create: () => APIResponse<NotesResponseModel>(
                create: () => NotesResponseModel()),
            apiFunction: getNotes)
        .then((response) {
      isLoading.value = false;
      NotesResponseModel? model = response.response?.data;

      if ((model?.results?.length ?? 0) > 0) {
        if ((model?.next ?? '').isNotEmpty) {
          pageToLoad++;
          hasNewPage = true;
        } else {
          hasNewPage = false;
        }
        notesList.addAll(model?.results ?? []);
        filteredItemList.addAll(notesList);
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

  void addNotes() {
    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;

    ///to close bottomsheet
    Get.back();
    Map<String, dynamic> data = {
      "content": notesContentController.text.trim(),
      "name": notesNameController.text.trim(),
      "user_fk": UserDefaults.getCurrentUserId(),
    };
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            needToAuthenticate: true,
            route: APIRoute(
              APIType.createNotes,
              body: data,
            ),
            create: () => APIResponse<NotesModel>(create: () => NotesModel()),
            apiFunction: addNotes)
        .then((response) async {
      isLoading.value = false;
      NotesModel? model = response.response?.data;
      if (model != null) {
        notesList.add(model);
        filteredItemList.add(model);
      } else {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: 'Failed to signup',
            dialogType: DialogType.ERROR);
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
