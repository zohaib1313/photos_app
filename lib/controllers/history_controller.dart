import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupsController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController searchController = TextEditingController();
}
