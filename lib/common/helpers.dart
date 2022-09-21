import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../common/styles.dart';
import '../my_application.dart';

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach(
      // ignore: avoid_print
      (match) => print("***${match.group(0)}***"));
}

String formatDateTime(DateTime? dateTime) {
  return DateFormat('dd-MM-yyyy hh:mm a').format(dateTime ?? DateTime.now());
}

/// Sets the hour and minute of a [DateTime] from a [TimeOfDay].
DateTime combineDateTime(DateTime date, int? hour, int? minute, int? seconds) =>
    DateTime(
        date.year, date.month, date.day, hour ?? 0, minute ?? 0, seconds ?? 0);

String getHourFromUnixTime({required int? unixDateTime}) {
  return DateFormat('hh a').format(
      DateTime.fromMillisecondsSinceEpoch((unixDateTime ?? 00000) * 1000));
}

String getDateFromUnix({required int? unixDateTime}) {
  return DateFormat('dd/MM').format(
      DateTime.fromMillisecondsSinceEpoch((unixDateTime ?? 00000) * 1000));
}

int daysDifference({required DateTime from, required DateTime to}) {
// get the difference in term of days, and not just a 24h difference
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);

  return to.difference(from).inDays;
}

myAppBar(
    {String? title,
    Color? backGroundColor,
    Color? iconColor,
    List<Widget>? actions,
    BuildContext? context,
    bool goBack = true,
    onBacKTap}) {
  return AppBar(
    elevation: 0,
    //iconTheme: IconThemeData(color: iconColor ?? myContext!.theme.cardColor),
    actions: actions ?? [],
    automaticallyImplyLeading: goBack,
    backgroundColor: backGroundColor ?? myContext!.theme.primaryColor,
    title: Text(
      title ?? "",
      style: AppTextStyles.textStyleBoldBodyMedium,
    ),
  );
}

myCheckBox(
    {onTickTap,
    onMessageTap,
    Color? fillColor,
    bool isActive = false,
    Color? checkColor,
    required String message,
    Color? messageColor}) {
  return Row(
    children: [
      Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: fillColor ?? myContext!.theme.hintColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: InkWell(
          onTap: onTickTap,
          child: Icon(
            Icons.check,
            size: 15.0,
            color: isActive
                ? (checkColor ?? Colors.black)
                : fillColor ?? myContext!.theme.hintColor,
          ),
        ),
      ),
      SizedBox(
        width: 50.w,
      ),
      InkWell(
        onTap: onMessageTap,
        child: Text(
          message,
          style: AppTextStyles.textStyleNormalBodySmall
              .copyWith(color: messageColor ?? myContext!.theme.hintColor),
        ),
      )
    ],
  );
}

Future<void> showDatePickerDialog(
    {required BuildContext context,
    required Function(dynamic date) onDateSelected,
    DatePickerMode initialDatePickerMode = DatePickerMode.day}) async {
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDatePickerMode: initialDatePickerMode,
      initialDate: DateTime.now(),
      firstDate: DateTime(1905),
      lastDate: DateTime(3905));
  if (picked != null && picked != DateTime.now()) {
    onDateSelected(DateFormat('yyyy-MM-dd').format(picked));
  }
}

Future pickDateRange({
  required BuildContext context,
  DateTimeRange? initialRange,
  required Function(DateTimeRange date) onRangeSelect,
}) async {
  DateTime now = DateTime.now();
  DateTimeRange dateRange = DateTimeRange(
    start: now,
    end: DateTime(now.year, now.month, now.day + 1),
  );

  DateTimeRange? newDateRange = await showDateRangePicker(
    context: context,
    initialDateRange: initialRange ?? dateRange,
    firstDate: DateTime(2019),
    lastDate: DateTime(2023),
  );

  if (newDateRange != null) {
    onRangeSelect(newDateRange);
  }
}

Future<void> showMyTimePicker(
    {required BuildContext context,
    required Function(dynamic date) onTimeSelected,
    TimePickerEntryMode initialDatePickerMode =
        TimePickerEntryMode.dial}) async {
  final TimeOfDay? picked =
      await showTimePicker(context: context, initialTime: TimeOfDay.now());
  if (picked != null) {
    onTimeSelected(picked.format(context));
  }
}
