// /lib/models/attendance_record.dart

class AttendanceRecord {
  final String name;
  final String contactInfo;
  final DateTime time;

  AttendanceRecord({
    required this.name,
    required this.contactInfo,
    required this.time,
  });

  // Converts an AttendanceRecord instance into a Map object.
  Map<String, dynamic> toJson() {
    return {
    //       {
    //   "user": "Chan Saw Lin",
    //   "phone": "0152131113",
    //   "check-in": "2020-06-30 16:10:05"
    // },
      'user': name,
      'phone': contactInfo,
      'check-in': time.toIso8601String(),
    };
  }

  // Creates an AttendanceRecord from a Map object.
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      name: json['user'],
      contactInfo: json['phone'],
      time: DateTime.parse(json['check-in']),
    );
  }
}