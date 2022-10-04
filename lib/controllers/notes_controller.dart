import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/models/notes_response_model.dart';

import '../common/app_pop_ups.dart';
import '../common/helpers.dart';
import '../common/user_defaults.dart';
import '../dio_networking/api_client.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';
import '../my_application.dart';

class NotesController extends GetxController {
  RxBool isLoading = false.obs;

  RxList<NotesModel?> notesList = <NotesModel?>[].obs;
  RxList<NotesModel?> filteredItemList = <NotesModel?>[].obs;

  TextEditingController searchController = TextEditingController();
  TextEditingController notesTitleController = TextEditingController();
  TextEditingController notesDescriptionController = TextEditingController();

  int pageToLoad = 1;
  bool hasNewPage = false;

  ScrollController listViewController = ScrollController();
  @override
  void onInit() {
    listViewController.addListener(() {
      if (listViewController.position.extentBefore ==
          listViewController.position.maxScrollExtent) {
        debugPrint('end of the page');
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

  void getNotes({bool showAlert = false}) {
    Map<String, dynamic> body = {
      'page': pageToLoad.toString(),
      "user_id": UserDefaults.getCurrentUserId(),
    };
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

  void AddNotes() {
    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;

    ///to close bottomsheet
    Get.back();
    Map<String, dynamic> data = {
      "name": notesTitleController.text.trim(),
      "content": notesDescriptionController.text.trim(),
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
            apiFunction: AddNotes)
        .then((response) async {
      isLoading.value = false;
      NotesModel? model = response.response?.data;
      if (model != null) {
        notesList.add(model);
        filteredItemList.add(model);
      } else {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: 'Failed to add notes',
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

  void updateNotes({required int index}) {
    FocusManager.instance.primaryFocus?.unfocus();
    isLoading.value = true;

    ///to close bottomsheet
    Get.back();
    Map<String, dynamic> data = {
      "id": filteredItemList.elementAt(index)!.id,
      "name": notesTitleController.text.trim(),
      "content": notesDescriptionController.text.trim(),
    };
    var client = APIClient(isCache: false, baseUrl: ApiConstants.baseUrl);
    client
        .request(
            needToAuthenticate: true,
            route: APIRoute(
              APIType.updateNotes,
              body: data,
            ),
            create: () => APIResponse<NotesModel>(create: () => NotesModel()),
            apiFunction: updateNotes)
        .then((response) async {
      isLoading.value = false;
      NotesModel? model = response.response?.data;
      if (model != null) {
        notesList[index] = model;
        filteredItemList[index] = model;
      } else {
        AppPopUps.showDialogContent(
            title: 'Error',
            description: 'Failed to update notes',
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

  void deleteNotes({required int index}) {
    AppPopUps.showConfirmDialog(
        title: 'Alert',
        message: 'Are you sure delete this reminder',
        onSubmit: () {
          ///delete with api and also reminder alarm scheduled

          isLoading.value = true;

          ///to close bottomsheet
          Get.back();
          Map<String, dynamic> data = {
            "id": filteredItemList.elementAt(index)?.id
          };
          APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
              .request(
                  needToAuthenticate: true,
                  route: APIRoute(
                    APIType.deleteNotes,
                    body: data,
                  ),
                  create: () => APIResponse(decoding: false),
                  apiFunction: deleteNotes)
              .then((response) async {
            isLoading.value = false;

            if (response.response?.success ?? false) {
              AppPopUps.showSnackBar(
                  message: 'Note deleted', context: myContext!);
              notesList.removeAt(index);
              filteredItemList.removeAt(index);
            } else {
              AppPopUps.showDialogContent(
                  title: 'Error',
                  description: 'Failed to delete',
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
        });
  }
}
