import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:photos_app/models/my_folder_model.dart';

class FolderViewPageController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<Rxn<MyMenuItem>> myFolder = Rxn<MyMenuItem>().obs;

  void initialize({required MyMenuItem folder}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      myFolder.value.value = folder;
    });
  }
}
