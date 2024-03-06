import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/attendance_record.dart';
import '../utils/time_format.dart';
import '../services/storage_service.dart'; // Placeholder for your storage handling
import 'add_attendance_screen.dart'; // Placeholder for the screen to add a new record
import 'attendance_details_screen.dart'; // Placeholder for the screen showing record details
import '../widgets/attendance_list_items.dart'; // Placeholder for the list item widget


class AttendanceListScreen extends StatefulWidget {
  @override
  _AttendanceListScreenState createState() => _AttendanceListScreenState();
}

class _AttendanceListScreenState extends State<AttendanceListScreen> {
  List<AttendanceRecord> records = [];
  bool _useTimeAgoFormat = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadRecords();
  }

  Future<void> _loadPreferences() async {
    _useTimeAgoFormat = await StorageService.getTimeFormatPreference();
    setState(() {});
  }

  Future<void> _loadRecords() async {
    // Load your records from storage here
    records = await StorageService.getAttendanceRecords();
  
    // This is a placeholder for loading logic
    // For example, you might have StorageService.getAttendanceRecords();
    // and then call setState() to update the state with the new records
    setState(() {
      //sort records by time
      records.sort((a, b) => b.time.compareTo(a.time));
      records = records;
    });
  }

  void _toggleTimeFormat(bool value) async {
    setState(() {
      _useTimeAgoFormat = value;
    });
    await StorageService.setTimeFormatPreference(value);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Records'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddAttendanceScreen(onAdd: _onRecordAdded)),
            ),
          ),
          Switch(
            value: _useTimeAgoFormat,
            onChanged: _toggleTimeFormat,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return AttendanceListItem(
            record: record,
            useTimeAgoFormat: _useTimeAgoFormat, // Assuming this is a state variable in AttendanceListScreen
            onTap: () {
              // Navigate to detail view or perform other actions
            },
          );
        },
      ),
    );
  }

  void _onRecordAdded(AttendanceRecord newRecord) {
    setState(() {
      records.add(newRecord);
    });
    _loadRecords(); // Refresh or reload your records if necessary
  }
}