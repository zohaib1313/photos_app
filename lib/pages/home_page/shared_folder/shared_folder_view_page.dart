import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/common/app_utils.dart';
import 'package:photos_app/common/common_widgets.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/models/shared_data_response_model.dart';

import '../../../../../common/loading_widget.dart';
import '../../../common/spaces_boxes.dart';

class SharedReceivedFolderViewPage extends GetView<HomePageController> {
  const SharedReceivedFolderViewPage({Key? key}) : super(key: key);
  static const id = '/SharedFolderViewPage';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      return Future.value(true);
      // return controller.closeLastFolder();
    }, child: Obx(() {
      return Scaffold(
        appBar: myAppBar(goBack: true, title: 'Folder'),
        body: SafeArea(
          child: Stack(
            children: [
              if (controller.sharedReceivedFolderStack.isNotEmpty)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      color: AppColor.alphaGrey,
                      child: Text(' Folder',
                          style: AppTextStyles.textStyleNormalBodyXSmall),
                    ),
                    vSpace,
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount:
                              controller.sharedReceivedFolderStack.length,
                          itemBuilder: (context, index) {
                            SharedReceivedDataModel sharedModel =
                                controller.sharedReceivedFolderStack[index];
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
                                if (sharedModel.contentFk?.type == 'folder') {
                                  controller.privateFoldersStack.clear();
                                  controller.openFolder(
                                      item: sharedModel.contentFk!);
                                } else if (sharedModel.contentFk?.type ==
                                    'file') {
                                  controller.openFile(
                                      item: sharedModel.contentFk!,
                                      isLoading: (isLoading) {
                                        controller.isLoading.value = isLoading;
                                      });
                                }
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        sharedModel.contentFk?.type == 'folder'
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
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: AppTextStyles
                                                    .textStyleBoldBodyMedium),
                                            Text(
                                                'User :${sharedModel.sharedByFk?.username ?? '-'}',
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
                                                      .sharedByFk?.photo ??
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
      );
    }));
  }

/* _getPath() {
    String path = '';
    for (final element in controller.sharedFolderStack) {
      path = "$path/${element.name}";
    }
    return path;
  }*/
}
