import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photos_app/controllers/dashboard_controller.dart';
import '../../../../common/loading_widget.dart';
import '../common/app_pop_ups.dart';
import '../common/styles.dart';

class DashboardPage extends GetView<DashBoardController> {
  DashboardPage({Key? key}) : super(key: key);
  static const id = '/DashboardPage';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await AppPopUps.showConfirmDialog(
          title: 'Confirm',
          message: 'Are you sure to exit from the app',
          onSubmit: () {
            Navigator.pop(context, true);
          },
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: GetX<DashBoardController>(
          initState: (state) {},
          builder: (_) {
            return SafeArea(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 85.h),
                    child: IndexedStack(
                        index: controller.selectedIndex.value,
                        children: controller.viewsList),
                  ),
                  CircleNavBar(
                    activeIcons: [
                      Icon(Icons.home, color: controller.activeColor),
                      Icon(Icons.person, color: controller.activeColor),
                      Icon(Icons.account_box, color: controller.activeColor),
                      Icon(Icons.settings, color: controller.activeColor),
                    ],
                    inactiveIcons: [
                      Icon(Icons.home, color: controller.inActiveColor),
                      Icon(Icons.person, color: controller.inActiveColor),
                      Icon(Icons.account_box, color: controller.inActiveColor),
                      Icon(Icons.settings, color: controller.inActiveColor),
                    ],
                    color: Colors.white,
                    height: 80.h,
                    circleWidth: 75.h,
                    initIndex: 0,
                    onChanged: (v) {
                      controller.selectedIndex.value = v;
                    },
                    // tabCurve: ,
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                    cornerRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(24),
                      bottomLeft: Radius.circular(24),
                    ),
                    shadowColor: AppColor.primaryColor,
                    elevation: 10,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
