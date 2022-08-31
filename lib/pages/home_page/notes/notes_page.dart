import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photos_app/common/app_alert_bottom_sheet.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/common/common_widgets.dart';
import 'package:photos_app/models/notes_response_model.dart';
import 'package:photos_app/my_application.dart';

import '../../../../common/loading_widget.dart';
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
                              controller.getNotes(showAlert: true);
                            },
                            child: Text(
                              "Refresh",
                              style: AppTextStyles.textStyleBoldBodyMedium
                                  .copyWith(
                                      decoration: TextDecoration.underline,
                                      color: AppColor.primaryColor),
                            ),
                          ),
                        ],
                      ))
                    : RefreshIndicator(
                        onRefresh: () {
                          print('on refresh');
                          controller.notesList.clear();
                          controller.filteredItemList.clear();
                          controller.getNotes(showAlert: true);
                          return Future.delayed(const Duration(seconds: 1));
                        },
                        child: ListView.builder(
                          itemCount: controller.filteredItemList.length,
                          controller: controller.listViewController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            NotesModel? model =
                                controller.filteredItemList.elementAt(index);
                            return getNotesCard(item: model!);
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

  Widget getNotesCard({required NotesModel item}) {
    return Card(
      margin: const EdgeInsets.all(4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(4),
        title: Text(item.name ?? '-',
            style: AppTextStyles.textStyleBoldBodyXSmall),
        leading: InkWell(
            onTap: () {
              ///edit reminder....
            },
            child: const Icon(Icons.edit)),
        subtitle: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.content ?? '-',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.textStyleNormalBodySmall),
          ],
        ),
        trailing: Text(
          formatDateTime(DateTime.tryParse(item.createdAt ?? '')),
          style: AppTextStyles.textStyleNormalBodyXSmall,
          maxLines: 1,
        ),
      ),
    );
  }

  void _showBottomSheet() {
    controller.notesContentController.clear();
    AppBottomSheets.showAppAlertBottomSheet(
        isFull: true,
        isDismissable: false,
        title: 'Add new note',
        context: myContext!,
        child: Column(
          children: [
            vSpace,
            MyTextField(
              hintText: 'Name',
              leftPadding: 0,
              rightPadding: 0,
              controller: controller.notesNameController,
            ),
            vSpace,
            MyTextField(
              hintText: 'Add your content here...',
              leftPadding: 0,
              rightPadding: 0,
              minLines: 4,
              maxLines: 7,
              controller: controller.notesContentController,
            ),
            vSpace,
            Button(
              buttonText: 'Add Note',
              onTap: () {
                if ((controller.notesContentController.text.isNotEmpty) &&
                    (controller.notesNameController.text.isNotEmpty)) {
                  controller.addNotes();
                } else {
                  AppPopUps.showDialogContent(
                      title: 'Alert', description: 'Enter all fields');
                }
              },
            )
          ],
        ));
  }
}
