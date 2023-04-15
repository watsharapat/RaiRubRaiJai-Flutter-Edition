class Date {
  final int year;
  final int month;
  final int day;

  int get numDayOfMonth {
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

  Date copyWith({
    int? year,
    int? month,
    int? day,
  }) {
    return Date(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
    );
  }

  const Date(this.year, this.month, this.day);

  factory Date.fromDateTime(DateTime dateTime) {
    return Date(dateTime.year, dateTime.month, dateTime.day);
  }

  factory Date.today() {
    return Date.fromDateTime(DateTime.now());
  }

  factory Date.yesterday() {
    return Date.fromDateTime(DateTime.now().subtract(const Duration(days: 1)));
  }

  factory Date.fromJson(Map<String, dynamic> json) {
    return Date(
      json['year'] as int,
      json['month'] as int,
      json['day'] as int,
    );
  }

  factory Date.fromString(String str) {
    final split = str.split('/');
    return Date(
      int.parse(split[2]),
      int.parse(split[1]),
      int.parse(split[0]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'month': month,
      'day': day,
    };
  }

  @override
  String toString() {
    return '$day/$month/$year';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Date &&
        other.year == year &&
        other.month == month &&
        other.day == day;
  }

  @override
  int get hashCode => year.hashCode ^ month.hashCode ^ day.hashCode;

  int compareTo(Date other) {
    if (year != other.year) {
      return year.compareTo(other.year);
    }
    if (month != other.month) {
      return month.compareTo(other.month);
    }
    return day.compareTo(other.day);
  }
}
