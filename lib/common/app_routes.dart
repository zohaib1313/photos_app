import 'package:get/get.dart';
import 'package:photos_app/controllers/dashboard_controller.dart';
import 'package:photos_app/pages/dashboard_page.dart';

appRoutes() {
  return <GetPage>[
    GetPage(
      name: DashboardPage.id,
      page: () => DashboardPage(),
      binding: BindingsBuilder(
        () {
          /*Get.lazyPut<DashBoardController>(
              () => DashBoardController(),*/
          Get.put(DashBoardController());
        },
      ),
    ),
  ];
}
