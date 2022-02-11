class DateType {
  static String full = 'yyyy-MM-dd HH:mm:ss';
  static String y_mo_d_h_m = 'yyyy-MM-dd HH:mm';
  static String y_mo_d = 'yyyy-MM-dd';
  static String y_mo = 'yyyy-MM';
  static String mo_d = 'MM-dd';
  static String mo_d_h_m = 'MM-dd HH:mm';
  static String h_m_s = 'HH:mm:ss';
  static String h_m = 'HH:mm';

  static String zh_full = 'yyyy年MM月dd日 HH时mm分ss秒';
  static String zh_y_mo_d_h_m = 'yyyy年MM月dd日 HH时mm分';
  static String zh_y_mo_d = 'yyyy年MM月dd日';
  static String zh_y_mo = 'yyyy年MM月';
  static String zh_mo_d = 'MM月dd日';
  static String zh_mo_d_h_m = 'MM月dd日 HH时mm分';
  static String zh_h_m_s = 'HH时mm分ss秒';
  static String zh_h_m = 'HH时mm分';
}

Map<int, int> MONTH_DAY = {
  1: 31, 2: 28, 3: 31,
  4: 30, 5: 31, 6: 30,
  7: 31, 8: 31, 9: 30,
  10: 31, 11: 30, 12: 31,
};


class DateUtil {
  static DateTime? getDateTime(String dateStr, {bool? isUtc}) {
    DateTime? dateTime = DateTime.tryParse(dateStr);
    if (isUtc != null) {
      if (isUtc) {
        dateTime = dateTime?.toUtc();
      } else {
        dateTime = dateTime?.toLocal();
      }
    }
    return dateTime;
  }

  static DateTime getDateTimeByMs(int ms, {bool isUtc = false}) {
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
  }

  static int? getDateMsByTimeStr(String dateStr, {bool? isUtc}) {
    DateTime? dateTime = getDateTime(dateStr, isUtc: isUtc);
    return dateTime?.millisecondsSinceEpoch;
  }

  static int getNowDateMs() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static String getNowDateStr() {
    return formatDate(DateTime.now());
  }

  static String formatDateMs(int ms, {bool isUtc = false, String? format}) {
    return formatDate(getDateTimeByMs(ms, isUtc: isUtc), format: format);
  }

  static String formatDateStr(String dateStr, {bool? isUtc, String? format}) {
    return formatDate(getDateTime(dateStr, isUtc: isUtc), format: format);
  }

  static String formatDate(DateTime? dateTime, {String? format}) {
    if (dateTime == null) return '';
    format = format ?? DateType.full;
    if (format.contains('yy')) {
      String year = dateTime.year.toString();
      if (format.contains('yyyy')) {
        format = format.replaceAll('yyyy', year);
      } else {
        format = format.replaceAll(
            'yy', year.substring(year.length - 2, year.length));
      }
    }

    format = _comFormat(dateTime.month, format, 'M', 'MM');
    format = _comFormat(dateTime.day, format, 'd', 'dd');
    format = _comFormat(dateTime.hour, format, 'H', 'HH');
    format = _comFormat(dateTime.minute, format, 'm', 'mm');
    format = _comFormat(dateTime.second, format, 's', 'ss');
    format = _comFormat(dateTime.millisecond, format, 'S', 'SSS');

    return format;
  }

  static String _comFormat(
      int value, String format, String single, String full) {
    if (format.contains(single)) {
      if (format.contains(full)) {
        format =
            format.replaceAll(full, value < 10 ? '0$value' : value.toString());
      } else {
        format = format.replaceAll(single, value.toString());
      }
    }
    return format;
  }

  static String getWeekday(DateTime? dateTime,
      {String languageCode = 'en', bool short = false}) {
    if (dateTime == null) return "";
    String weekday = "";
    switch (dateTime.weekday) {
      case 1:
        weekday = languageCode == 'zh' ? '星期一' : 'Monday';
        break;
      case 2:
        weekday = languageCode == 'zh' ? '星期二' : 'Tuesday';
        break;
      case 3:
        weekday = languageCode == 'zh' ? '星期三' : 'Wednesday';
        break;
      case 4:
        weekday = languageCode == 'zh' ? '星期四' : 'Thursday';
        break;
      case 5:
        weekday = languageCode == 'zh' ? '星期五' : 'Friday';
        break;
      case 6:
        weekday = languageCode == 'zh' ? '星期六' : 'Saturday';
        break;
      case 7:
        weekday = languageCode == 'zh' ? '星期日' : 'Sunday';
        break;
      default:
        break;
    }
    return languageCode == 'zh'
        ? (short ? weekday.replaceAll('星期', '周') : weekday)
        : weekday.substring(0, short ? 3 : weekday.length);
  }

  static String getWeekdayByMs(int milliseconds,
      {bool isUtc = false, String languageCode = 'en', bool short = false}) {
    DateTime dateTime = getDateTimeByMs(milliseconds, isUtc: isUtc);
    return getWeekday(dateTime, languageCode: languageCode, short: short);
  }

  static int getDayOfYear(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month;
    int days = dateTime.day;
    for (int i = 1; i < month; i++) {
      days = days + MONTH_DAY[i]!;
    }
    if (isLeapYearByYear(year) && month > 2) {
      days = days + 1;
    }
    return days;
  }

  static int getDayOfYearByMs(int ms, {bool isUtc = false}) {
    return getDayOfYear(DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc));
  }

  static bool isToday(int? milliseconds, {bool isUtc = false, int? locMs}) {
    if (milliseconds == null || milliseconds == 0) return false;
    DateTime old =
    DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
    DateTime now;
    if (locMs != null) {
      now = DateUtil.getDateTimeByMs(locMs);
    } else {
      now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    }
    return old.year == now.year && old.month == now.month && old.day == now.day;
  }

  static bool isYesterday(DateTime dateTime, DateTime locDateTime) {
    if (yearIsEqual(dateTime, locDateTime)) {
      int spDay = getDayOfYear(locDateTime) - getDayOfYear(dateTime);
      return spDay == 1;
    } else {
      return ((locDateTime.year - dateTime.year == 1) &&
          dateTime.month == 12 &&
          locDateTime.month == 1 &&
          dateTime.day == 31 &&
          locDateTime.day == 1);
    }
  }

  static bool isYesterdayByMs(int ms, int locMs) {
    return isYesterday(DateTime.fromMillisecondsSinceEpoch(ms),
        DateTime.fromMillisecondsSinceEpoch(locMs));
  }

  static bool isWeek(int? ms, {bool isUtc = false, int? locMs}) {
    if (ms == null || ms <= 0) {
      return false;
    }
    DateTime _old = DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
    DateTime _now;
    if (locMs != null) {
      _now = DateUtil.getDateTimeByMs(locMs, isUtc: isUtc);
    } else {
      _now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    }

    DateTime old =
    _now.millisecondsSinceEpoch > _old.millisecondsSinceEpoch ? _old : _now;
    DateTime now =
    _now.millisecondsSinceEpoch > _old.millisecondsSinceEpoch ? _now : _old;
    return (now.weekday >= old.weekday) &&
        (now.millisecondsSinceEpoch - old.millisecondsSinceEpoch <=
            7 * 24 * 60 * 60 * 1000);
  }

  static bool yearIsEqual(DateTime dateTime, DateTime locDateTime) {
    return dateTime.year == locDateTime.year;
  }

  static bool yearIsEqualByMs(int ms, int locMs) {
    return yearIsEqual(DateTime.fromMillisecondsSinceEpoch(ms),
        DateTime.fromMillisecondsSinceEpoch(locMs));
  }

  static bool isLeapYear(DateTime dateTime) {
    return isLeapYearByYear(dateTime.year);
  }

  static bool isLeapYearByYear(int year) {
    return year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
  }
}