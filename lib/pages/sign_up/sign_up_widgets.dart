import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../common/common_widgets.dart';
import '../../common/styles.dart';

mixin SignupWidgetsMixin {
  getTextField(
      {required String hintText,
      required TextEditingController controller,
      String? validateText,
      bool validate = true,
      bool enabled = true,
      int minLines = 1,
      int maxLines = 2,
      List<TextInputFormatter> inputFormatters = const [],
      TextInputType inputType = TextInputType.text,
      onChanged,
      validator}) {
    return MyTextField(
        controller: controller,
        enable: enabled,
        hintText: hintText,
        minLines: minLines,
        maxLines: maxLines,
        contentPadding: 20,
        onChanged: onChanged,
        keyboardType: inputType,
        inputFormatters: inputFormatters,
        focusBorderColor: AppColor.alphaGrey,
        textColor: AppColor.whiteColor,
        hintColor: AppColor.whiteColor,
        fillColor: AppColor.alphaGrey,
        validator: validator ??
            (String? value) => validate
                ? (value!.trim().isEmpty ? validateText ?? "Required" : null)
                : null);
  }
}
