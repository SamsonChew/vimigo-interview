import 'package:flutter/material.dart';
import '../models/attendance_record.dart';
import '../utils/time_format.dart';
import '../widgets/attendance_list_items.dart';
import '../services/storage_service.dart';
import '../views/add_attendance_screen.dart';
import '../views/attendance_details_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AttendanceRecord> _records = [];
  List<AttendanceRecord> _filteredRecords = [];
  bool _useTimeAgoFormat = true;
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _showIndicator = false;

  @override
  void initState() {
    super.initState();
    _loadTimeFormatPreference();
    _loadAttendanceRecords();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        _showIndicator = true;
      });
    } else {
      setState(() {
        _showIndicator = false;
      });
    }
  }

  Future<void> _loadTimeFormatPreference() async {
    _useTimeAgoFormat = await StorageService.getTimeFormatPreference();
    setState(() {});
  }

  Future<void> _loadAttendanceRecords() async {
    _records = await StorageService.getAttendanceRecords();
    _filteredRecords = List.from(_records);
    setState(() {});
  }

  void _addAttendanceRecord(AttendanceRecord record) async {
    await StorageService.saveAttendanceRecord(record);
    _loadAttendanceRecords();
  }

  void _toggleTimeFormat() {
    setState(() {
      //update to User Preference
      StorageService.setTimeFormatPreference(!_useTimeAgoFormat);
      _useTimeAgoFormat = !_useTimeAgoFormat;
    });
  }

  void _filterRecords(String keyword) {
    setState(() {
      _filteredRecords = _records
          .where((record) =>
              record.name.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Tracker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _filterRecords(value),
              decoration: InputDecoration(
                labelText: 'Search by Name',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _filteredRecords.length + (_showIndicator ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _filteredRecords.length) {
                  return _buildIndicator();
                }
                AttendanceRecord record = _filteredRecords[index];
                //sort records by time
                _filteredRecords.sort((a, b) => b.time.compareTo(a.time));
                return AttendanceListItem(
                  record: record,
                  useTimeAgoFormat: _useTimeAgoFormat,
                  onTap: () {
                    // Handle item tap, possibly navigate to a detail screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            AttendanceDetailsScreen(record: record),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddAttendanceScreen(
                onAdd: (record) {
                  _addAttendanceRecord(record);
                  Navigator.pop(context);
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Attendance',
      ),
      persistentFooterButtons: <Widget>[
        IconButton(
          icon: Icon(_useTimeAgoFormat ? Icons.date_range : Icons.access_time),
          onPressed: _toggleTimeFormat,
        ),
      ],
    );
  }

  Widget _buildIndicator() {
    return Container(
      padding: EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text('You have reached the end of the list'),
    );
  }
}