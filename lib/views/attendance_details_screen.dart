import 'dart:html';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import '../models/attendance_record.dart';
import '../utils/time_format.dart';

class AttendanceDetailsScreen extends StatelessWidget {
  final AttendanceRecord record;

  const AttendanceDetailsScreen({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Formatting the date time to show in "dd MMM yyyy, h:mm a" format.
    final formattedTime = DateFormat('dd MMM yyyy, h:mm a').format(record.time);

    void shareContactDetails() {
      final String content = 'Name: ${record.name}\n'
          'Contact Info: ${record.contactInfo}\n'
          'Time: $formattedTime';
      Share.share(content);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Record Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Name: ${record.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Contact Info: ${record.contactInfo}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Time: $formattedTime', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: shareContactDetails,
              child: Text('Share'),
            ),
          ],
        ),
      ),
    );
  }
}