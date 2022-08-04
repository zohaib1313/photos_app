import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import '../../../../common/loading_widget.dart';
import '../../common/my_search_bar.dart';
import '../../common/spaces_boxes.dart';
import '../../models/my_folder_model.dart';

class HomePage extends GetView<HomePageController> {
  HomePage({Key? key}) : super(key: key);
  static const id = '/HomePage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Hello, John doe', actions: [
        MyAnimSearchBar(
          width: context.width * 0.8,
          onSuffixTap: () {
            controller.searchController.clear();
          },
          closeSearchOnSuffixTap: true,
          textController: controller.searchController,
        ),
        hSpace,
        const Icon(Icons.notification_important_outlined),
        hSpace,
        hSpace,
      ]),
      body: GetX<HomePageController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            vSpace,
                            getCard(myFolderModel: controller.pinnedMenuFolder),
                            vSpace,
                            getCard(myFolderModel: controller.sharedMenuItem),
                            vSpace,
                            getCard(myFolderModel: controller.privateMenuItem),
                            vSpace,
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (controller.isLoading.isTrue) LoadingWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getCard({required Rx<MyMenuItem> myFolderModel}) {
    return Card(
      color: AppColor.alphaGrey,
      child: Container(
        height: 180.h,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(myFolderModel.value.name ?? '-',
                style: AppTextStyles.textStyleBoldBodyMedium),
            vSpace,
            myFolderModel.value.subItemList.isEmpty
                ? Expanded(
                    child: InkWell(
                    onTap: () {
                      ///add folder of file....
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColor.primaryColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12)),
                      child: const Center(
                        child: Icon(Icons.add),
                      ),
                    ),
                  ))
                : Expanded(
                    child: ListView.builder(
                      itemCount: myFolderModel.value.subItemList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        MyMenuItem item =
                            myFolderModel.value.subItemList.elementAt(index);
                        return getItemView(item: item);
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  getItemView({required MyMenuItem item}) {
    return InkWell(
      onTap: () {
        if (item.isFolder) {
          ///add new file or folder
          print(item.id);
        } else {
          ///open file
        }
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(4),
          width: 550.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Icon(item.isFolder ? Icons.folder : Icons.file_copy,
                      color: AppColor.deepPurple, size: 16),
                  if (item.isFolder)
                    Text(
                      '(${item.subItemList.length})',
                      style: AppTextStyles.textStyleNormalBodyXSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
              Text(
                '${item.name} +',
                style: AppTextStyles.textStyleBoldBodyXSmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
