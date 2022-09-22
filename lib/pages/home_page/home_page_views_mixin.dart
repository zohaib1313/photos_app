import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/styles.dart';

import '../../my_application.dart';

mixin HomePageViewsMixin {
  Widget getMainCards(
      {required BuildContext context,
      required String title,
      required Color color,
      required onTap,
      Color? textColor,
      required Widget icon}) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        splashColor: color,
        onTap: onTap,
        child: Card(
          color: color,
          shadowColor: color,
          elevation: 30,
          margin: EdgeInsets.zero,
          surfaceTintColor: color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: icon),
              Flexible(
                child: Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.textStyleNormalLargeTitle
                        .copyWith(color: AppColor.whiteColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
