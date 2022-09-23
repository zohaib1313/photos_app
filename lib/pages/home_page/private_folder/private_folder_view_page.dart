import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/models/my_data_model.dart';
import 'package:photos_app/pages/home_page/private_folder/private_folder_view_mixin.dart';
import '../../../../../common/loading_widget.dart';
import '../../../common/spaces_boxes.dart';

class PrivateFolderViewPage extends GetView<HomePageController>
    with PrivateFolderViewMixin {
  const PrivateFolderViewPage({Key? key}) : super(key: key);
  static const id = '/PrivateFolderViewPage';

  @override
  Widget build(BuildContext context) {
    print("folder stack in private folder view");
    print(controller.privateFoldersStack.length.toString());
    return WillPopScope(onWillPop: () {
      return controller.closeLastFolder();
    }, child: Obx(() {
      return Scaffold(
        appBar: myAppBar(
            onBacKTap: () async {
              if (await controller.closeLastFolder()) {
                Get.back();
              }
            },
            goBack: true,
            title: controller.privateFoldersStack.isNotEmpty
                ? controller.privateFoldersStack.last.name
                : '-'),
        body: SafeArea(
          child: Stack(
            children: [
              if (controller.privateFoldersStack.isNotEmpty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(6),
                        color: AppColor.alphaGrey.withOpacity(0.5),
                        child: Text(_getPath(),
                            style: AppTextStyles.textStyleNormalBodyXSmall)),
                    vSpace,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller
                              .privateFoldersStack.last.subFolder.length,
                          itemBuilder: (context, index) {
                            MyDataModel innerItem = controller
                                .privateFoldersStack.last.subFolder[index];
                            return SizedBox(
                              height: 120.h,
                              child: getFolderFileView(
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
              if (controller.privateFoldersStack.isNotEmpty)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: focusMenueForFab(
                      item: controller.privateFoldersStack.last,
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
    }));
  }

  _getPath() {
    String path = '';
    for (final element in controller.privateFoldersStack) {
      path = "$path/${element.name}";
    }
    return path;
  }
}
