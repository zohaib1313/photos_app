import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'common/user_defaults.dart';
import 'my_application.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserDefaults.getPref();
  // await HiveDb.clearDb();
//  debugRepaintRainbowEnabled = (true);
  runApp(const MyApplication());
}
