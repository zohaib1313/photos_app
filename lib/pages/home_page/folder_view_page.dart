import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/models/my_menu_item_model.dart';
import '../../../../common/loading_widget.dart';
import '../../common/spaces_boxes.dart';
import '../../controllers/folder_view_page_controller.dart';

class FolderViewPage extends GetView<HomePageController> {
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
                  ? controller.foldersStack.last.name ?? '-'
                  : "-"),
          body: SafeArea(
              child: Stack(
            children: [
              if (controller.foldersStack.isNotEmpty)
                Column(
                  children: [
                    Container(
                        padding: const EdgeInsets.all(6),
                        color: AppColor.alphaGrey,
                        child: Text(controller.foldersStack.last.path ?? '-',
                            style: AppTextStyles.textStyleNormalBodyXSmall)),
                    vSpace,
                    getCard(
                        myFolderModel: controller.foldersStack.last,
                        context: context)
                  ],
                ),
              if (controller.isLoading.isTrue) LoadingWidget(),
            ],
          )),
        );
      }),
    );
  }

  Widget getCard(
      {required MyMenuItem myFolderModel, required BuildContext context}) {
    return _getFocusedMenu(
        item: myFolderModel,
        context: context,
        child: Card(
          color: AppColor.alphaGrey,
          child: Container(
            height: 180.h,
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(myFolderModel.name ?? '-',
                    style: AppTextStyles.textStyleBoldBodyMedium),
                vSpace,
                myFolderModel.subItemList.isEmpty
                    ? Expanded(
                        child: _getFocusedMenu(
                          item: myFolderModel,
                          context: context,
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColor.primaryColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Center(
                              child: Icon(Icons.add),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: myFolderModel.subItemList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            MyMenuItem item =
                                myFolderModel.subItemList.elementAt(index);
                            return getItemView(item: item, context: context);
                          },
                        ),
                      ),
              ],
            ),
          ),
        ));
  }

  getItemView({required MyMenuItem item, required BuildContext context}) {
    return _getFocusedMenu(
        item: item,
        context: context,
        child: Card(
          child: Container(
            padding: const EdgeInsets.all(4),
            width: 550.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      Flexible(
                        child: item.icon ??
                            Icon(item.isFolder ? Icons.folder : Icons.file_copy,
                                color: AppColor.deepPurple, size: 16),
                      ),
                      if (item.isFolder)
                        Text(
                          '(${item.subItemList.length})',
                          style: AppTextStyles.textStyleNormalBodyXSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                Text(
                  '${item.name}',
                  style: AppTextStyles.textStyleBoldBodyXSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ));
  }

  Widget _getFocusedMenu(
      {required MyMenuItem item,
      required BuildContext context,
      required Widget child}) {
    return FocusedMenuHolder(
        menuWidth: MediaQuery.of(context).size.width * 0.50,
        blurSize: 5.0,
        menuItemExtent: 45,
        menuBoxDecoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        duration: const Duration(milliseconds: 100),
        animateMenuItems: true,
        blurBackgroundColor: Colors.black54,
        openWithTap: true,
        // Open Focused-Menu on Tap rather than Long Press
        menuOffset: 10.0,
        // Offset value to show menuItem from the selected item
        bottomOffsetHeight: 80.0,
        // Offset height to consider, for showing the menu item ( for example bottom navigation bar), so that the popup menu will be shown on top of selected item.
        menuItems: <FocusedMenuItem>[
          // Add Each FocusedMenuItem  for Menu Options
          FocusedMenuItem(
              title: Text("Open", style: AppTextStyles.textStyleBoldBodySmall),
              trailingIcon: const Icon(Icons.open_in_new),
              onPressed: () {
                item.isFolder
                    ? controller.openFolder(item: item)
                    : controller.openFile(item: item);
              }),
          if (item.isFolder)
            FocusedMenuItem(
                title: Text("Add New File",
                    style: AppTextStyles.textStyleBoldBodySmall),
                trailingIcon:
                    const Icon(Icons.file_copy_outlined, color: AppColor.green),
                onPressed: () {
                  controller.addNewFile(item: item);
                }),
          if (item.isFolder)
            FocusedMenuItem(
                title: Text("Add New Folder",
                    style: AppTextStyles.textStyleBoldBodySmall),
                trailingIcon: Icon(Icons.folder, color: AppColor.primaryColor),
                onPressed: () {
                  /// ///////////.............................adding new folder///////////.............................
                  controller.addNewFolder(item: item);
                }),
          FocusedMenuItem(
              title: Text("Share", style: AppTextStyles.textStyleBoldBodySmall),
              trailingIcon: const Icon(Icons.share),
              onPressed: () {}),
          FocusedMenuItem(
              title: Text("Delete",
                  style: AppTextStyles.textStyleBoldBodySmall
                      .copyWith(color: Colors.redAccent)),
              trailingIcon: const Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onPressed: () {}),
        ],
        onPressed: () {},
        child: child);
  }
}
