import 'package:shared_preferences/shared_preferences.dart';
import '../models/attendance_record.dart';
import 'dart:convert';

class StorageService {
  // Key used for storing time format preference
  static const _useTimeAgoFormatKey = 'useTimeAgoFormat';


  

  // Save the user's preference for "time ago" format
  static Future<void> setTimeFormatPreference(bool useTimeAgo) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool(_useTimeAgoFormatKey));
    await prefs.setBool(_useTimeAgoFormatKey, useTimeAgo);
  }

  // Retrieve the user's preference for "time ago" format
  static Future<bool> getTimeFormatPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_useTimeAgoFormatKey) ?? false; // Default to false if not set
  }

  // Save an attendance record
  static Future<void> saveAttendanceRecord(AttendanceRecord record) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<AttendanceRecord> records = await getAttendanceRecords();
    records.add(record);
    // Convert the list of records to a JSON string
    List<String> jsonRecords = records.map((record) => json.encode(record.toJson())).toList();
    await prefs.setStringList('attendanceRecords', jsonRecords);
  }

  // Retrieve all attendance records
  static Future<List<AttendanceRecord>> getAttendanceRecords() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonRecords = prefs.getStringList('attendanceRecords');
    if (jsonRecords == null) return [];
    // Convert the JSON string back to AttendanceRecord objects
    return jsonRecords.map((recordJson) => AttendanceRecord.fromJson(json.decode(recordJson))).toList();
  }

  //load attendance records from data.json
  static Future<List<AttendanceRecord>> loadAttendanceRecords() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<AttendanceRecord> records = [];
    String? data = prefs.getString('data');
    if (data != null) {
      List<dynamic> jsonRecords = json.decode(data);
      records = jsonRecords.map((record) => AttendanceRecord.fromJson(record)).toList();
    }
    return records;
  }

  static Future<bool> isFirstLaunch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('firstLaunch') ?? true;
  }

  static Future<void> setFirstLaunch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstLaunch', false);
  }
  // Calculate and return a formatted "time ago" string
  String getTimeAgo(time) {
    Duration difference = DateTime.now().difference(time);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else if (difference.inDays == 1) {
      return '1 day ago';
    } else if (difference.inDays <= 30) {
      return '${difference.inDays} days ago';
    } else {
      int weeks = (difference.inDays / 7).floor();
      return '$weeks weeks ago';
    }
  }
}