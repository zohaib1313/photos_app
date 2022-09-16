import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/controllers/home_page_controller.dart';
import 'package:photos_app/controllers/private_folder_controller.dart';
import 'package:photos_app/controllers/shared_folder_controller.dart';
import 'package:photos_app/models/my_data_model.dart';
import 'package:photos_app/models/my_menu_item_model.dart';

import '../../../../common/loading_widget.dart';
import '../../common/spaces_boxes.dart';

import '../../common/user_defaults.dart';
import '../../models/my_menu_item_model.dart';

mixin HomePageViewsMixin {
  Widget getMainCards(
      {required BuildContext context,
      required String title,
      required Color color,
      required onTap,
      Color textColor = AppColor.blackColor,
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
                        .copyWith(color: textColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
