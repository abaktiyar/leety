import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:leety/notification_controller.dart';
import 'package:leety/pages/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:leety/graphql/leety_gql_client.dart';
import 'package:leety/intro/onboarding_screen.dart';

void main() async {
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: "basic_channel_group",
      channelKey: "leety_channel",
      channelName: "Basic Notifications",
      channelDescription: "Channel for leety notifications",
    ),
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: "basic_channel_group",
        channelGroupName: "Basic Channel Group"),
  ]);
  bool isAllowedToSendNotifications =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotifications) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool hasCompletedOnboarding =
      prefs.getBool('hasCompletedOnboarding') ?? false;

  runApp(MyApp(hasCompletedOnboarding: hasCompletedOnboarding));
}

class MyApp extends StatefulWidget {
  final bool hasCompletedOnboarding;
  const MyApp(
      {super.key = const Key('app'), required this.hasCompletedOnboarding});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod:
            NotificationController.onNotificationReceivedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onNotificationReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreateMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: widget.hasCompletedOnboarding ? HomePage() : OnboardingScreen());
    // home: OnboardingScreen());
  }
}
