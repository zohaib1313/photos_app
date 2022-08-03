import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/controllers/dashboard_controller.dart';
import '../../../../common/loading_widget.dart';

class DashboardPage extends GetView<DashBoardController> {
  DashboardPage({Key? key}) : super(key: key);
  static const id = '/DashboardPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<DashBoardController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                Text("home"),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
