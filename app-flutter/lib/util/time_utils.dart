import 'package:intl/intl.dart';

class TimeUtils {
  static String formatTimestamp(int timestamp, {String? format}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    // Use custom format if provided, otherwise default to the original format
    String formattedDate = format != null && format.isNotEmpty
        ? DateFormat(format).format(dateTime)
        : DateFormat.yMMMMd().add_jm().format(dateTime);

    return formattedDate;
  }

  static bool isTodayOrLaterThanSecondDay(String inputDate) {
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(inputDate);
    DateTime today = DateTime.now();
    DateTime secondDay = parsedDate.add(const Duration(days: 2));
    return today.isAfter(secondDay) || today.isAtSameMomentAs(secondDay);
  }

  static String getCurrentDateTimeString() {
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }

  static List<String> getNextSevenDays(String inputDate) {
    DateTime startDate = DateFormat('yyyy-MM-dd HH:mm:ss').parse(inputDate);
    List<String> dateList = [];
    for (int i = 0; i < 7; i++) {
      DateTime currentDate = startDate.add(Duration(days: i));
      String formattedDate = DateFormat('MM/dd').format(currentDate);
      dateList.add(formattedDate);
    }
    return dateList;
  }
}
