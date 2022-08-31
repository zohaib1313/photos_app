import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/my_application.dart';
import 'package:url_launcher/url_launcher.dart';

import 'helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photos_app/common/app_alert_bottom_sheet.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/common/common_widgets.dart';

import 'package:photos_app/my_application.dart';

import '../../../../common/loading_widget.dart';
import '../../../common/helpers.dart';
import '../../../common/my_search_bar.dart';
import '../../../common/spaces_boxes.dart';
import '../../../common/styles.dart';
import '../../../controllers/reminder_controller.dart';
import '../../../models/reminder_response_model.dart';

class AppUtils {
  static Future<List<PlatformFile>?> pickMultipleFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      printWrapped(result.files.first.name);
      return result.files;
    } else {
      // User canceled the picker
      printWrapped('user cancelled picking files');
      return null;
    }
  }

  static void openFile(File file) async {
    final String filePath = file.absolute.path;
    final Uri uri = Uri.file(filePath);
    printWrapped(file.path);

    printWrapped("xxxxx");

    printWrapped(file.absolute.path);
/*printWrapped('opening file');

    if (!File(uri.toFilePath()).existsSync()) {
      printWrapped('uri doesn exists');
      AppPopUps.showSnackBar(
          message: 'File does not exists', context: myContext!);
    }*/
    if (!await launchUrl(uri)) {
      printWrapped('failed to launc url');

      AppPopUps.showSnackBar(message: "Can't open file", context: myContext!);
    }
  }

  static String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('hh:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = '${diff.inDays} DAY AGO';
      } else {
        time = '${diff.inDays} DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = '${(diff.inDays / 7).floor()} WEEK AGO';
      } else {
        // time = '${(diff.inDays / 7).floor()} WEEKS AGO';
        time = DateFormat('hh:mm a\nMM:YYYY').format(date);
      }
    }

    return time;
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  static void showPicker({required BuildContext context, onComplete}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext x) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () async {
                      _pickImage(
                          source: 0,
                          onCompletedd: (File? file) {
                            print(file!.path.toString());
                            onComplete(file);
                          });

                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    _pickImage(
                        source: 1,
                        onCompletedd: (File file) {
                          onComplete(file);
                        });

                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  static void _pickImage({required int source, required onCompletedd}) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
          source: source == 1 ? ImageSource.camera : ImageSource.gallery);

      if (pickedFile != null) {
        onCompletedd(File(pickedFile.path));
      } else {
        Get.log('No image selected.');
        return null;
      }
    } catch (e) {
      Get.log(e.toString(), isError: true);
    }
  }

  static Future<void> dialNumber(
      {required String phoneNumber, required BuildContext context}) async {
    final url = "tel:$phoneNumber";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      AppPopUps.showSnackBar(
          message: "Unable to call $phoneNumber", context: context);
    }

    return;
  }

  static void showDatePicker(
      {required Null Function(DateTime dateTime) onComplete}) {
    DatePicker.showDatePicker(myContext!,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2050, 6, 7),
        onChanged: (date) {}, onConfirm: (DateTime? date) {
      onComplete(date ?? DateTime.now());
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  static void showTimePicker(
      {required Null Function(DateTime dateTime) onCompletePickTime}) {
    DatePicker.showTime12hPicker(myContext!,
        showTitleActions: true,
        onChanged: (date) {}, onConfirm: (DateTime? date) {
      onCompletePickTime(date ?? DateTime.now());
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }
}
