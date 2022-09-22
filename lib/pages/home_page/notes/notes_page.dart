import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photos_app/common/app_alert_bottom_sheet.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/common/common_widgets.dart';
import 'package:photos_app/models/notes_response_model.dart';
import 'package:photos_app/my_application.dart';

import '../../../../common/loading_widget.dart';
import '../../../common/app_utils.dart';
import '../../../common/helpers.dart';
import '../../../common/my_search_bar.dart';
import '../../../common/spaces_boxes.dart';
import '../../../common/styles.dart';
import '../../../controllers/notes_controller.dart';

class NotesPage extends GetView<NotesController> {
  const NotesPage({Key? key}) : super(key: key);
  static const id = '/NotesPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          _showBottomSheet();
        },
      ),
      appBar: myAppBar(goBack: true, title: 'Notes', actions: [
        MyAnimSearchBar(
          width: context.width,
          onSuffixTap: () {
            controller.searchController.clear();
          },
          closeSearchOnSuffixTap: true,
          textController: controller.searchController,
        ),
      ]),
      body: GetX<NotesController>(
        initState: (state) {
          controller.getNotes();
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                ((controller.isLoading.value == false &&
                        controller.notesList.isEmpty))
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("No Notes Found",
                              style: AppTextStyles.textStyleBoldBodyMedium),
                          InkWell(
                            onTap: () {
                              controller.notesList.clear();
                              controller.filteredItemList.clear();
                              controller.getNotes(showAlert: true);
                            },
                            child: Text(
                              "Refresh",
                              style: AppTextStyles.textStyleBoldBodyMedium
                                  .copyWith(
                                      decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ))
                    : RefreshIndicator(
                        onRefresh: () {
                          controller.notesList.clear();
                          controller.filteredItemList.clear();
                          controller.getNotes(showAlert: true);
                          return Future.delayed(const Duration(seconds: 2));
                        },
                        child: ListView.builder(
                          itemCount: controller.filteredItemList.length,
                          controller: controller.listViewController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return getNotesListItem(index: index);
                          },
                        ),
                      ),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getNotesListItem({required int index}) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (x) {
              _showBottomSheet(index: index);
            },
            icon: Icons.update,
            label: 'Update',
          ),
        ],
      ),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (x) {
              controller.deleteNotes(index: index);
            },
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.all(4),
        color: AppColor.alphaGrey,
        child: ListTile(
          contentPadding: const EdgeInsets.all(4),
          title: Text(controller.filteredItemList.elementAt(index)?.name ?? '-',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.textStyleNormalBodySmall
                  .copyWith(color: AppColor.whiteColor)),
          subtitle: Text(
              controller.filteredItemList.elementAt(index)?.content ?? '-',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.textStyleNormalBodySmall
                  .copyWith(color: AppColor.whiteColor)),
          trailing: Text(
              formatDateTime(DateTime.tryParse(
                  controller.filteredItemList.elementAt(index)?.content ?? '')),
              style: AppTextStyles.textStyleNormalBodySmall
                  .copyWith(color: AppColor.whiteColor)),

          /*  leading: const Icon(
            Icons.arrow_back_ios,
            size: 14,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
          ),*/
        ),
      ),
    );
  }

  void _showBottomSheet({int? index}) {
    if (index == null) {
      controller.notesTitleController.clear();
      controller.notesDescriptionController.clear();
    } else {
      controller.notesTitleController.text =
          controller.filteredItemList.elementAt(index)?.name ?? '';
      controller.notesDescriptionController.text =
          controller.filteredItemList.elementAt(index)?.content ?? '';
    }
    AppBottomSheets.showAppAlertBottomSheet(
        isFull: true,
        isDismissable: false,
        title: 'Add new note',
        context: myContext!,
        child: Column(
          children: [
            vSpace,
            MyTextField(
              hintText: 'Add title...',
              leftPadding: 0,
              rightPadding: 0,
              controller: controller.notesTitleController,
            ),
            vSpace,
            MyTextField(
              hintText: 'Add Content...',
              leftPadding: 0,
              rightPadding: 0,
              minLines: 4,
              maxLines: 7,
              controller: controller.notesDescriptionController,
            ),
            vSpace,
            Button(
              buttonText: index != null ? 'Update' : 'Add Note',
              onTap: () {
                if ((controller.notesTitleController.text.isNotEmpty) &&
                    (controller.notesDescriptionController.text.isNotEmpty)) {
                  if (index != null) {
                    controller.updateNotes(index: index);
                  } else {
                    controller.AddNotes();
                  }
                } else {
                  AppPopUps.showSnackBar(
                      context: myContext!, message: 'Enter all fields');
                }
              },
            )
          ],
        ));
  }
}
