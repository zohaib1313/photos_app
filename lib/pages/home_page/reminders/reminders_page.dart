import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/loading_widget.dart';
import '../../../controllers/reminder_controller.dart';

class ReminderPage extends GetView<ReminderController> {
  ReminderPage({Key? key}) : super(key: key);
  static const id = '/ReminderPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<ReminderController>(
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
