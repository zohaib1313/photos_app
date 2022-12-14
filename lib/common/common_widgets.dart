// ignore_for_file: avoid_print, must_be_immutable, unnecessary_question_mark, prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/styles.dart';
import 'package:photos_app/dio_networking/app_apis.dart';
import 'package:photos_app/my_application.dart';
import 'constants.dart';
import 'helpers.dart';

typedef FieldValidator = String? Function(String? data);

class SvgViewer extends StatelessWidget {
  final String svgPath;
  final double? height;
  final double? width;
  final Color? color;

  const SvgViewer(
      {Key? key, required this.svgPath, this.height, this.width, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgPath,
      color: color,
      height: height ?? 18,
      width: width ?? 18,
    );
  }
}

class MyTextField extends StatelessWidget {
  final Color? fillColor;
  final String? labelText;
  final String? hintText;
  final Color? hintColor;
  final Color? labelColor;
  final String? prefixIcon;
  final String? suffixIcon;
  final Color? focusBorderColor;
  final Color? unfocusBorderColor;
  final double? contentPadding;
  final bool? enable;
  final String? text;
  final String? sufixLabel;

  final onChanged;
  final double? leftPadding;
  final double? rightPadding;
  final TextEditingController? controller;
  final Function? focusListner;
  late FocusNode focusNode;
  final FieldValidator? validator;
  final TextInputType? keyboardType;
  final inputFormatters;
  final Color? textColor;
  final bool? obsecureText;
  final Widget? suffixIconWidet;
  int minLines = 1;
  int maxLines = 1;
  TextDirection? textDirection;

  MyTextField(
      {Key? key,
      this.textDirection,
      this.textColor,
      this.obsecureText,
      this.fillColor,
      this.labelText,
      this.maxLines = 1,
      this.minLines = 1,
      this.hintText,
      this.hintColor,
      this.labelColor,
      this.prefixIcon,
      this.inputFormatters,
      this.suffixIcon,
      this.focusBorderColor,
      this.unfocusBorderColor,
      this.onChanged,
      this.contentPadding,
      this.enable = true,
      this.text,
      this.sufixLabel,
      this.leftPadding,
      this.rightPadding,
      this.controller,
      this.focusListner,
      this.validator,
      this.suffixIconWidet,
      this.keyboardType})
      : super(key: key) {
    focusNode = FocusNode();
    if (focusListner != null) {
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          focusListner!();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding ?? 50.w,
        right: rightPadding ?? 50.w,
      ),
      child: TextFormField(
        obscureText: obsecureText ?? false,
        /*  style:
            AppTextStyles.textStyleNormalBodySmall.copyWith(color: textColor),
      */
        controller: controller ?? TextEditingController(),
        initialValue: text,
        minLines: minLines,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType ?? TextInputType.text,
        enabled: enable,
        //onFieldSubmitted: onChanged,
        focusNode: focusNode,
        validator: validator,
        onChanged: onChanged,
        autofocus: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(contentPadding ?? 25.h),
          //  fillColor: fillColor,
          labelText: hintText ?? "",
          hintText: hintText,
          filled: fillColor != null,
          /* hintStyle:
              AppTextStyles.textStyleBoldBodySmall.copyWith(color: hintColor),
          labelStyle: AppTextStyles.textStyleNormalBodySmall
              .copyWith(color: labelColor),*/
          prefixIcon: (prefixIcon != null)
              ? Padding(
                  padding: EdgeInsets.all(contentPadding ?? 100.w),
                  child: SvgViewer(
                    svgPath: prefixIcon!,
                    width: 20.w,
                    height: 20.h,
                  ),
                )
              : null,
          suffixIcon: sufixLabel != null
              ? Padding(
                  padding: EdgeInsets.all(25.h),
                  child: Text(
                    sufixLabel ?? '',
                    style: AppTextStyles.textStyleBoldBodySmall,
                  ),
                )
              : (suffixIcon != null)
                  ? Padding(
                      padding: EdgeInsets.all(25.h),
                      child: SvgViewer(
                        svgPath: suffixIcon!,
                        width: 20.w,
                        height: 20.h,
                      ),
                    )
                  : (suffixIconWidet != null)
                      ? suffixIconWidet
                      : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.r),
            borderSide:
                BorderSide(color: focusBorderColor ?? AppColor.alphaGrey),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.r),
            borderSide:
                BorderSide(color: focusBorderColor ?? AppColor.alphaGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.r),
            borderSide:
                BorderSide(color: unfocusBorderColor ?? AppColor.alphaGrey),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.r),
            borderSide: BorderSide(color: AppColor.redColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.r),
            borderSide:
                BorderSide(color: focusBorderColor ?? AppColor.primaryColor),
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String buttonText;
  final onTap;
  final double? padding;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final double? width;
  final Widget? prefixIcon;
  final Widget? postFixIcon;
  final double? height;
  final double? cornerRadius;
  final TextStyle? textStyle;
  final double? leftPadding;
  final double? rightPading;

  const Button(
      {Key? key,
      required this.buttonText,
      this.onTap,
      this.prefixIcon,
      this.postFixIcon,
      this.padding,
      this.color,
      this.textColor,
      this.cornerRadius,
      this.borderColor,
      this.textStyle,
      this.width,
      this.height,
      this.leftPadding,
      this.rightPading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: () {},
      child: Padding(
        padding: EdgeInsets.only(
            left: leftPadding == null ? 0.w : leftPadding!,
            right: rightPading == null ? 0.w : rightPading!),
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(padding ?? 80.w),
          decoration: BoxDecoration(
              border: borderColor == null
                  ? null
                  : Border.all(
                      color: borderColor!,
                    ),
              borderRadius:
                  BorderRadius.all(Radius.circular(cornerRadius ?? 50.r)),
              color: color ?? AppColor.primaryColor),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              prefixIcon ?? const IgnorePointer(),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  buttonText,
                  textAlign: TextAlign.center,
                  style: textStyle ??
                      AppTextStyles.textStyleBoldBodySmall
                          .copyWith(color: textColor ?? AppColor.alphaGrey),
                ),
              ),
              postFixIcon ?? const IgnorePointer(),
            ],
          )),
        ),
      ),
    );
  }
}

typedef String ItemAsString(dynamic x);

class MyDropDown extends StatefulWidget {
  Color? fillColor;
  Function(dynamic? value)? onChange;
  dynamic? value;
  Color? borderColor;
  final Color? labelColor;
  final Color? textColor;
  final String? prefixIcon;
  final String? suffixIcon;
  List<dynamic> items = [];
  final String? labelText;
  final String? hintText;
  final Color? hintColor;
  final double? leftPadding;
  final double? rightPadding;
  final FormFieldValidator<dynamic>? validator;
  bool isDense;
  bool isItalicHint;
  Color? suffixIconColor;
  ItemAsString? itemAsString;

  bool isValidate = true;

  MyDropDown(
      {Key? key,
      this.fillColor,
      this.isValidate = true,
      required this.onChange,
      this.textColor,
      this.suffixIconColor,
      this.value,
      this.items = const [],
      this.borderColor,
      this.labelColor,
      this.prefixIcon,
      this.itemAsString,
      this.suffixIcon,
      this.labelText,
      this.hintText,
      this.hintColor,
      this.leftPadding,
      this.rightPadding,
      this.validator,
      this.isDense = true,
      this.isItalicHint = false})
      : super(key: key);

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.leftPadding ?? 50.w,
        right: widget.rightPadding ?? 50.w,
      ),
      child: DropdownSearch<dynamic>(
        // showClearButton: true,
        selectedItem: widget.value,
        itemAsString: widget.itemAsString,
        dropdownDecoratorProps: DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(
              labelText: widget.labelText,
              hintText: widget.hintText,
              suffixIconColor: widget.suffixIconColor,
              isCollapsed: false,
              hintStyle: AppTextStyles.textStyleBoldBodySmall.copyWith(
                  fontStyle: widget.isItalicHint
                      ? FontStyle.italic
                      : FontStyle.normal),
              prefixIcon: (widget.prefixIcon != null)
                  ? Padding(
                      padding: EdgeInsets.all(100.w),
                      child: SvgViewer(svgPath: widget.prefixIcon!),
                    )
                  : null,
              contentPadding: EdgeInsets.all(10.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide:
                    BorderSide(color: widget.borderColor ?? AppColor.alphaGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide:
                    BorderSide(color: widget.borderColor ?? AppColor.alphaGrey),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide: BorderSide(color: AppColor.redColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
                borderSide:
                    BorderSide(color: widget.borderColor ?? AppColor.alphaGrey),
              ),
              filled: true,
              fillColor: widget.fillColor ?? Colors.transparent),
        ),
        popupProps: const PopupProps.modalBottomSheet(showSearchBox: true),
        onChanged: widget.onChange,
        validator: widget.isValidate
            ? (value) {
                if ((value ?? '') == '') {
                  return 'Required';
                }
                return null;
              }
            : null,
        items: widget.items,
      ),
    );
  }
}

class ExpandableCardContainer extends StatefulWidget {
  bool isExpanded;
  Widget collapsedChild;
  Widget expandedChild;

  ExpandableCardContainer(
      {Key? key,
      required this.isExpanded,
      required this.collapsedChild,
      required this.expandedChild})
      : super(key: key);

  @override
  _ExpandableCardContainerState createState() =>
      _ExpandableCardContainerState();
}

class _ExpandableCardContainerState extends State<ExpandableCardContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 4000),
        curve: Curves.easeInOut,
        child: widget.isExpanded ? widget.expandedChild : widget.collapsedChild,
      ),
    );
  }
}

class NetworkCircularImage extends StatefulWidget {
  String url = '';
  double radius;
  double? width;
  double? height;
  BoxFit? fit;
  bool clearCache = false;
  Color? bgColor;
  var completedLoading;

  NetworkCircularImage(
      {Key? key,
      this.url = '',
      this.radius = 34,
      this.width,
      this.bgColor = Colors.transparent,
      this.clearCache = false,
      this.height,
      this.completedLoading,
      this.fit})
      : super(key: key);

  @override
  _NetworkCircularImageState createState() => _NetworkCircularImageState();
}

class _NetworkCircularImageState extends State<NetworkCircularImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: (widget.url.isNotEmpty)
          ? widget.url.startsWith('/')
              ? ApiConstants.baseUrlNoSlash + widget.url
              : ApiConstants.baseUrl + widget.url
          : ApiConstants.imageNetworkPlaceHolder,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      color: widget.bgColor,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        backgroundImage: imageProvider,
        radius: widget.radius,
        backgroundColor: widget.bgColor,
      ),
      placeholder: (context, url) => CircleAvatar(
        radius: widget.radius,
        child: CircularProgressIndicator(
          color: AppColor.primaryColor,
        ),
      ),
      // progressIndicatorBuilder: (BuildContext context, String url,
      //     DownloadProgress downloadProgress) {
      //   if (downloadProgress.downloaded == downloadProgress.totalSize) {
      //     widget.completedLoading();
      //   }
      //   printWrapped("total downloaded");
      //   printWrapped(downloadProgress.totalSize.toString());
      //   printWrapped(downloadProgress.downloaded.toString());
      //
      //   return Container(
      //       child: CircularProgressIndicator(
      //           value: downloadProgress.progress, color: AppColor.whiteColor));
      // },
      errorWidget: (context, url, error) {
        printWrapped(error.toString());
        return CircleAvatar(
          backgroundImage: const AssetImage('assets/images/logo.png'),
          radius: widget.radius,
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.clearCache) {
      // DefaultCacheManager().removeFile(widget.url);
    }
  }
}

class NetworkPlainImage extends StatefulWidget {
  String url;

  double? width;
  double? height;
  BoxFit? fit;

  NetworkPlainImage(
      {Key? key, required this.url, this.width, this.height, this.fit})
      : super(key: key);

  @override
  _NetworkPlainImageState createState() => _NetworkPlainImageState();
}

class _NetworkPlainImageState extends State<NetworkPlainImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: (widget.url.isNotEmpty)
          ? widget.url.startsWith('/')
              ? ApiConstants.baseUrlNoSlash + widget.url
              : ApiConstants.baseUrl + widget.url
          : ApiConstants.imageNetworkPlaceHolder,
      width: widget.width,
      height: widget.height,
      key: UniqueKey(),
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.redColor.withOpacity(0.5)),
        child: const Center(
          child: Icon(Icons.error),
        ),
      ),
    );
  }
}

Widget keyValueRowWidget(
    {required String title, required String value, required bool isGrey}) {
  return Container(
    padding: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: isGrey ? AppColor.alphaGrey : AppColor.alphaGrey),
    child: Row(
      children: [
        Expanded(
            child: Center(
          child: Text(
            title,
            style: AppTextStyles.textStyleNormalBodyMedium,
          ),
        )),
        Expanded(
            child: Center(
          child: Text(
            value,
            style: AppTextStyles.textStyleNormalBodyMedium,
          ),
        )),
      ],
    ),
  );
}

Widget getFeatureItem({required String title, Color? color}) {
  return Container(
    margin: const EdgeInsets.all(5),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
        color: color ?? AppColor.alphaGrey,
        borderRadius: BorderRadius.circular(10)),
    child: Text(
      title,
      style: AppTextStyles.textStyleNormalBodyMedium.copyWith(
          color: color != null ? AppColor.whiteColor : AppColor.whiteColor),
    ),
  );
}

Widget getImageWidget(Rx<File?> file, {String? networkImage = ''}) {
  return Stack(
    children: [
      (file.value != null)
          ? CircleAvatar(
              radius: 70, backgroundImage: Image.file(file.value!).image)
          : (networkImage != ''
              ? NetworkCircularImage(radius: 70, url: networkImage ?? '')
              : const CircleAvatar(
                  radius: 70,
                  backgroundImage:
                      AssetImage('assets/images/place_your_image.png'))),
      Positioned(
        bottom: 1,
        right: 10,
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color: Colors.white,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(
                  50,
                ),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(2, 4),
                  color: Colors.black.withOpacity(
                    0.3,
                  ),
                  blurRadius: 3,
                ),
              ]),
          child: const Padding(
            padding: EdgeInsets.all(2.0),
            child: Icon(Icons.add_a_photo, color: Colors.black),
          ),
        ),
      ),
    ],
  );
}

class NamedIcon extends StatelessWidget {
  final IconData iconData;
  final String text;
  final VoidCallback? onTap;
  final int notificationCount;

  const NamedIcon({
    Key? key,
    this.onTap,
    required this.text,
    required this.iconData,
    this.notificationCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(iconData),
                Text(text, overflow: TextOverflow.ellipsis),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                alignment: Alignment.center,
                child: Text('$notificationCount'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
