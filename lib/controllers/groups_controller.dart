import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupsController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController searchController = TextEditingController();

  TextEditingController groupTitleController = TextEditingController();

  TextEditingController groupDescriptionController = TextEditingController();

  Rxn<File?> profileImage = Rxn<File>();

  void updateGroup({required int index}) {}

  void addNewGroup() {}
}
