import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/loading_widget.dart';
import '../../../controllers/check_list_controller.dart';
import '../../../controllers/history_controller.dart';

class CheckListPage extends GetView<CheckListController> {
  CheckListPage({Key? key}) : super(key: key);
  static const id = '/CheckListPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<CheckListController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                Center(child: Text("History")),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
