import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/models/my_data_model.dart';
import 'package:photos_app/models/my_menu_item_model.dart';

import '../../../../common/loading_widget.dart';
import '../../common/spaces_boxes.dart';
import 'home_page_views_mixin.dart';

class FolderViewPage extends GetView<HomePageController>
    with HomePageViewsMixin {
  const FolderViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return controller.closeLastFolder();
      },
      child: Obx(() {
        return Scaffold(
          appBar: myAppBar(
              onBacKTap: () async {
                if (await controller.closeLastFolder()) {
                  Get.back();
                }
              },
              goBack: true,
              title: controller.foldersStack.isNotEmpty
                  ? controller.foldersStack.last.name
                  : '-'),
          body: SafeArea(
            child: Stack(
              children: [
                if (controller.foldersStack.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        color: AppColor.alphaGrey,
                        child: Text(_getPath(),
                            style: AppTextStyles.textStyleNormalBodyXSmall),
                      ),
                      vSpace,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount:
                                controller.foldersStack.last.subFolder.length,
                            itemBuilder: (context, index) {
                              MyDataModel innerItem =
                                  controller.foldersStack.last.subFolder[index];
                              return SizedBox(
                                height: 120.h,
                                child: getItemView(
                                    item: innerItem,
                                    controller: controller,
                                    context: context),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                if (controller.foldersStack.isNotEmpty)
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: getFocusedMenu(
                        item: controller.foldersStack.last,
                        context: context,
                        controller: controller,
                        child: const CircleAvatar(
                          radius: 26,
                          child: Icon(
                            Icons.add,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          ),
        );
      }),
    );
  }

  _getPath() {
    String path = '';
    for (final element in controller.foldersStack) {
      path = "$path/${element.name}";
    }
    return path;
  }
}
