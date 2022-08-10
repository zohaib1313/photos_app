import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController searchController = TextEditingController();
}
