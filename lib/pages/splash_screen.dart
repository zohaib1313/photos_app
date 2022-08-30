import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:photos_app/pages/dashboard_page.dart';
import 'package:photos_app/pages/login_page/login_page.dart';
import '../common/constants.dart';
import '../common/styles.dart';

class SplashScreen extends StatefulWidget {
  static const id = "/SplashScreen";

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () => {gotoRelevantScreenOnUserType()});
  }

  void gotoRelevantScreenOnUserType() async {
    Get.offNamed(LoginPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(38.0),
          child: Icon(
            Icons.share,
            size: 50,
            color: AppColor.whiteColor,
          ) /*Image.asset("assets/images/logo.png")*/,
        ),
      ),
    );
  }
}
