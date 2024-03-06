// lib/services/preferences_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _timeFormatKey = 'timeFormatPreference';

  // Save the time format preference
  Future<void> setTimeFormatPreference(bool useTimeAgo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_timeFormatKey, useTimeAgo);
  }

  // Get the time format preference
  Future<bool> getTimeFormatPreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_timeFormatKey) ?? false; // Default to false if not set
  }
}