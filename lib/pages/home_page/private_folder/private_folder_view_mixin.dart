import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/models/my_data_model.dart';

import '../../../common/spaces_boxes.dart';
import '../../../my_application.dart';

mixin PrivateFolderViewMixin {
  Widget getFolderCard(
      {required MyDataModel myFolderModel,
      required HomePageController controller,
      required BuildContext context}) {
    return getFocusedMenu(
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
                myFolderModel.subFolder.isEmpty
                    ? Expanded(
                        child: getFocusedMenu(
                          item: myFolderModel,
                          controller: controller,
                          context: context,
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColor.primaryColor,
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                              child: Icon(Icons.add, color: AppColor.alphaGrey),
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: myFolderModel.subFolder.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            MyDataModel item =
                                myFolderModel.subFolder.elementAt(index);
                            return getFolderFileView(
                                item: item,
                                context: context,
                                controller: controller);
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
        controller: controller);
  }

  getFolderFileView(
      {required MyDataModel item,
      required HomePageController controller,
      required BuildContext context}) {
    return getFocusedMenu(
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
                        child: Icon(
                            (item.type == 'folder')
                                ? Icons.folder
                                : Icons.file_copy,
                            color: AppColor.yellowColor,
                            size: 16),
                      ),
                      /*if (item.type == 'folder')*/
                      Text(
                        '(id=${item.id})',
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
        ),
        controller: controller);
  }

  Widget getFocusedMenu(
      {required MyDataModel item,
      required BuildContext context,
      required HomePageController controller,
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
                item.type == 'folder'
                    ? {
                        controller.loadPrivateFolder(
                            model: item,
                            subListItem: (List<MyDataModel>? myDataModelList) {
                              item.subFolder.clear();
                              if (myDataModelList != null) {
                                item.subFolder.addAll(myDataModelList);
                              }

                              controller.openFolder(item: item);
                            })
                      }
                    : controller.openFile(item: item);
              }),
          /*  if (item.type == 'folder')
            FocusedMenuItem(
                title: Text("Add New File",
                    style: AppTextStyles.textStyleBoldBodySmall),
                trailingIcon:
                    const Icon(Icons.file_copy_outlined, color: AppColor.green),
                onPressed: () {
                  controller.addNewFile(item: item);
                }),
          if (item.type == 'folder')
            FocusedMenuItem(
                title: Text("Add New Folder",
                    style: AppTextStyles.textStyleBoldBodySmall),
                trailingIcon: Icon(Icons.folder, color: AppColor.primaryColor),
                onPressed: () {
                  /// ///////////.............................adding new folder///////////.............................
                  //   controller.addNewFolder(item: item);
                }),*/
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

  Widget focusMenueForFab(
      {required MyDataModel item,
      required BuildContext context,
      required HomePageController controller,
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
          FocusedMenuItem(
              title: Text("File", style: AppTextStyles.textStyleBoldBodySmall),
              trailingIcon: const Icon(Icons.file_copy),
              onPressed: () {
                controller.addNewFile(item: item, context: context);
              }),
          FocusedMenuItem(
              title:
                  Text("Folder", style: AppTextStyles.textStyleBoldBodySmall),
              trailingIcon: const Icon(Icons.folder),
              onPressed: () {
                controller.addNewFolder(item: item);
              }),
        ],
        onPressed: () {},
        child: child);
  }
}
