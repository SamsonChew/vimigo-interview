import 'package:flutter/material.dart';
import 'core/constants.dart';
import 'services/storage_service.dart';
import 'views/home_screen.dart';
import 'views/onboarding_screen.dart';
import 'models/user_preference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isFirstLaunch = await StorageService.isFirstLaunch();

  // get preference for first launch
  final prefs = PreferencesService();
  bool useTimeAgoFormat = await prefs.getTimeFormatPreference();

  if (isFirstLaunch) {
    await StorageService.setFirstLaunch();
  }
  runApp(MyApp(useTimeAgoFormat: useTimeAgoFormat));
}

class MyApp extends StatelessWidget {

  final bool useTimeAgoFormat;

  const MyApp({Key? key, required this.useTimeAgoFormat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: ThemeData(
        primarySwatch: AppConstants.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: StorageService.isFirstLaunch(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data == true) {
              return HomeScreen();
            } else {
              return OnboardingScreen();
            }
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}