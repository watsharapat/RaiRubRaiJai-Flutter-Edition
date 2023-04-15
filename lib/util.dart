import 'data_model/date.dart';

int getDayOfWeek(Date date) {
  final int day = date.day;
  final int month = date.month;
  final int year = date.year;
  final int a = (14 - month) ~/ 12;
  final int y = year - a;
  final int m = month + 12 * a - 2;
  final int d = (day + y + y ~/ 4 - y ~/ 100 + y ~/ 400 + (31 * m) ~/ 12) % 7;
  return d;
}

int getNumDayOfMonth(Date date) {
  final int month = date.month;
  final int year = date.year;
  if (month == 2) {
    if (year % 4 == 0) {
      return 29;
    } else {
      return 28;
    }
  } else if (month == 4 || month == 6 || month == 9 || month == 11) {
    return 30;
  } else {
    return 31;
  }
}

String getMonthName(int monthIdx) {
  switch (monthIdx) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return 'Invalid month';
  }
}
