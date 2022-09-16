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
import 'package:photos_app/pages/home_page/private_folder/private_folder_view_mixin.dart';

import '../../../../../common/loading_widget.dart';
import '../../../common/spaces_boxes.dart';
import '../../../common/user_defaults.dart';
import '../../../controllers/private_folder_controller.dart';
import '../home_page_views_mixin.dart';

class PrivateFolderViewPage extends GetView<PrivateFolderController>
    with PrivateFolderViewMixin {
  const PrivateFolderViewPage({Key? key}) : super(key: key);
  static const id = '/PrivateFolderViewPage';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return controller.closeLastFolder();
        },
        child: GetX<PrivateFolderController>(
          initState: (_) {
            controller.loadPrivateFolder(
                model: MyDataModel(
                  userFk: int.tryParse(
                    UserDefaults.getCurrentUserId() ?? '',
                  ),
                ),
                subListItem: (List<MyDataModel>? dataModel) {
                  if (dataModel != null) {
                    controller.openFolder(item: dataModel.first);
                  }
                });
          },
          builder: (logic) {
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
                                itemCount: controller
                                    .privateFoldersStack.last.subFolder.length,
                                itemBuilder: (context, index) {
                                  MyDataModel innerItem = controller
                                      .privateFoldersStack
                                      .last
                                      .subFolder[index];
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
          },
        ));
  }

  _getPath() {
    String path = '';
    for (final element in controller.privateFoldersStack) {
      path = "$path/${element.name}";
    }
    return path;
  }
}
