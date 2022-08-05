import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/my_application.dart';
import 'package:url_launcher/url_launcher.dart';

import 'helpers.dart';

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
}
