import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String get formattedDate {
    return DateFormat('dd.MM.yyyy').format(this);
  }

  String get formattedDateTime {
    return DateFormat('dd.MM.yyyy HH:mm').format(this);
  }

  String get formattedTime {
    return DateFormat('HH:mm').format(this);
  }

  String get timeAgo {
    final difference = DateTime.now().difference(this);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} yıl önce';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} ay önce';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} gün önce';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} saat önce';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} dakika önce';
    } else {
      return 'Az önce';
    }
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  DateTime startOfDay() {
    return DateTime(year, month, day);
  }

  DateTime endOfDay() {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }
}
