import 'package:flutter/material.dart';
import 'package:leety/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:leety/intro/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasCompletedOnboarding =
      prefs.getBool('hasCompletedOnboarding') ?? false;

  runApp(MyApp(hasCompletedOnboarding: hasCompletedOnboarding));
}

class MyApp extends StatelessWidget {
  final bool hasCompletedOnboarding;

  const MyApp({Key? key, required this.hasCompletedOnboarding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: hasCompletedOnboarding ? HomePage() : OnboardingScreen());
    // home: OnboardingScreen());
  }
}
