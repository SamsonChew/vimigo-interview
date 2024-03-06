import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'home_screen.dart'; // Adjust this import to your app's home screen

class OnboardingScreen extends StatelessWidget {
  List<PageViewModel> getPages() {
    return [
      PageViewModel(
        title: "Welcome to Attendance Tracker",
        body: "Track attendance records with ease.",
        image: Center(child: Icon(Icons.access_time, size: 175.0)),
      ),
      PageViewModel(
        title: "Add Records",
        body: "Quickly add new attendance records.",
        image: Center(child: Icon(Icons.note_add, size: 175.0)),
      ),
      PageViewModel(
        title: "View Details",
        body: "See detailed information about each record.",
        image: Center(child: Icon(Icons.details, size: 175.0)),
      ),
      PageViewModel(
        title: "Share",
        body: "Easily share attendance records.",
        image: Center(child: Icon(Icons.share, size: 175.0)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: getPages(),
      onDone: () {
        // When done button is press
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen()), // Navigate to your main app screen
        );
      },
      onSkip: () {
        // You can also override onSkip callback
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeScreen()), // Navigate to your main app screen
        );
      },
      showSkipButton: true,
      skip: const Icon(Icons.skip_next),
      next: const Icon(Icons.navigate_next),
      done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).primaryColor,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
    );
  }
}