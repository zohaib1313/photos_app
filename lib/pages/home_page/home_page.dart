import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import '../../../../common/loading_widget.dart';

class HomePage extends GetView<HomePageController> {
  HomePage({Key? key}) : super(key: key);
  static const id = '/HomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<HomePageController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                Center(child: Text("homePage")),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
