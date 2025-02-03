import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';

const dateFormatYyyyMMDd = "yyyy-MM-dd";
const dateTimeFormatYyyyMMDdHhMm = "yyyy-MM-dd kk:mm";
const dateFormatMMDdYyyyHhMmSs = "MM:dd:yyyy hh:mm:ss";
const dateTimeFormatDdMMMYyyyHhMm = "dd MMM yyyy | hh:mm a";

String formatDate(DateTime? dateTime, {String format = dateTimeFormatDdMMMYyyyHhMm}) {
  if (dateTime != null) {
    String formatStr = DateFormat(format).format(dateTime.toLocal());
    return formatStr;
  } else {
    return "";
  }
}

String getVerboseDateTime(DateTime? dateTime) {
  if (dateTime == null) return '';
  DateTime now = DateTime.now();
  DateTime justNow = now.subtract(const Duration(minutes: 1));
  DateTime localDateTime = dateTime.toLocal();

  if (!localDateTime.difference(justNow).isNegative) {
    return 'Just Now'.tr;
  }

  String roughTimeString = DateFormat('jm').format(localDateTime);
  if (localDateTime.day == now.day && localDateTime.month == now.month && localDateTime.year == now.year) {
    return 'Today, $roughTimeString';
  }

  DateTime yesterday = now.subtract(const Duration(days: 1));

  if (localDateTime.day == yesterday.day && localDateTime.month == now.month && localDateTime.year == now.year) {
    return 'Yesterday, $roughTimeString';
  }

  if (now.difference(localDateTime).inDays < 4) {
    String weekday = DateFormat('EEEE').format(localDateTime);

    return '$weekday, $roughTimeString';
  }

  return '${DateFormat('dd MMM yy').format(localDateTime)}, $roughTimeString';
}
