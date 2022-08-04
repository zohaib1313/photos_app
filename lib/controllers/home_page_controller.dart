import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:photos_app/models/my_folder_model.dart';

import '../models/my_folder_model.dart';

class HomePageController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController searchController = TextEditingController();

  var pinnedMenuFolder = MyMenuItem(
    id: '1',
    name: 'Pinned menu',
    isFolder: true,
    /* subItemList: [
        MyMenuItem(id: '11', name: 'Pinned menu', isFolder: true)
      ]*/
  ).obs;

  var sharedMenuItem = MyMenuItem(
      id: '2',
      name: 'Shared menu',
      isFolder: true,
      subItemList: [
        MyMenuItem(id: '22', name: 'Shared menu', isFolder: true)
      ]).obs;

  var privateMenuItem = MyMenuItem(
      id: '3',
      name: 'Private menu',
      isFolder: true,
      subItemList: [
        MyMenuItem(id: '33', name: 'Private menu', isFolder: true)
      ]).obs;
}
