import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import '../../../../common/loading_widget.dart';
import '../../controllers/friends_page_controller.dart';

class FriendsPage extends GetView<FriendsPageController> {
  FriendsPage({Key? key}) : super(key: key);
  static const id = '/FriendsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<FriendsPageController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                Center(child: Text("FriendsPage")),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
