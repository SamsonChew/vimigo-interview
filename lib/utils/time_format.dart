import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class TimeFormat {
  static String formatDateTime(DateTime dateTime) {
    final dateFormat = DateFormat('dd MMM yyyy, h:mm a');
    return dateFormat.format(dateTime);
  }

  static String timeAgo(DateTime dateTime) {
    return timeago.format(dateTime, allowFromNow: true);
  }
}