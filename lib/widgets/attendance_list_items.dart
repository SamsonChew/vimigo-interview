import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/attendance_record.dart';

class AttendanceListItem extends StatelessWidget {
  final AttendanceRecord record;
  final bool useTimeAgoFormat;
  final VoidCallback onTap;

  const AttendanceListItem({
    Key? key,
    required this.record,
    required this.useTimeAgoFormat,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String displayTime = useTimeAgoFormat
        ? timeago.format(record.time, allowFromNow: true)
        : DateFormat('dd MMM yyyy, h:mm a').format(record.time);

    return ListTile(
      title: Text(record.name, style: TextStyle(fontSize: 18)),
      subtitle: Text(displayTime, style: TextStyle(color: Colors.grey[600])),
      onTap: onTap,
    
    );
  }
}