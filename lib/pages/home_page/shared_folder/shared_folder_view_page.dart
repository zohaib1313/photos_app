import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photos_app/common/common_widgets.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/models/my_data_model.dart';
import 'package:photos_app/models/shared_data_response_model.dart';

import '../../../../../common/loading_widget.dart';
import '../../../common/spaces_boxes.dart';
import '../../../common/user_defaults.dart';

class SharedFolderViewPage extends GetView<HomePageController> {
  const SharedFolderViewPage({Key? key}) : super(key: key);
  static const id = '/SharedFolderViewPage';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          return Future.value(true);
          // return controller.closeLastFolder();
        },
        child: Scaffold(
          appBar: myAppBar(goBack: true, title: 'Shared Folder'),
          body: SafeArea(
            child: Stack(
              children: [
                if (controller.sharedFolderStack.isNotEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        color: AppColor.alphaGrey,
                        child: Text('Shared Folder',
                            style: AppTextStyles.textStyleNormalBodyXSmall),
                      ),
                      vSpace,
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: controller.sharedFolderStack.length,
                            itemBuilder: (context, index) {
                              SharedReceivedDataModel sharedModel =
                                  controller.sharedFolderStack[index];
                              return InkWell(
                                onTap: () {
                                  /*    print(sharedModel.contentFk?.id);
                                  controller.loadPrivateFolder(
                                      model: MyDataModel(
                                          id: sharedModel.contentFk?.id),
                                      subListItem:
                                          (List<MyDataModel>? dataModel) {
                                        if (dataModel != null) {
                                          ///clearing folder stack

                                          sharedModel.contentFk!.subFolder
                                              .addAll(dataModel);

                                        }
                                      });*/
                                  controller.privateFoldersStack.clear();
                                  controller.openFolder(
                                      item: sharedModel.contentFk!);
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          sharedModel.contentFk?.type ==
                                                  'folder'
                                              ? Icons.folder
                                              : Icons.file_copy,
                                          color: AppColor.yellowColor,
                                          size: 30,
                                        ),
                                        hSpace,
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  sharedModel.contentFk?.name ??
                                                      '-',
                                                  style: AppTextStyles
                                                      .textStyleBoldBodyMedium),
                                              Text(
                                                  'Shared with:${sharedModel.sharedWithFk?.username ?? '-'}',
                                                  style: AppTextStyles
                                                      .textStyleNormalBodySmall),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            NetworkCircularImage(
                                                radius: 16,
                                                url: sharedModel
                                                        .sharedWithFk?.photo ??
                                                    ''),
                                            vSpace,
                                            Text(
                                                DateFormat('yyyy-MM-dd').format(
                                                    DateTime.tryParse(sharedModel
                                                                .createdAt ??
                                                            '') ??
                                                        DateTime.now()),
                                                style: AppTextStyles
                                                    .textStyleNormalBodySmall),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          ),
        ));
  }

/* _getPath() {
    String path = '';
    for (final element in controller.sharedFolderStack) {
      path = "$path/${element.name}";
    }
    return path;
  }*/
}
