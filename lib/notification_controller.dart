import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:leety/graphql/leety_gql_client.dart';
import "dart:async";

import 'package:shared_preferences/shared_preferences.dart';

class NotificationController {
  @pragma('vm:entry-point')
  static Future<void> onNotificationCreateMethod(
      ReceivedNotification receivedNotification) async {}
  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {}
  @pragma('vm:entry-point')
  static Future<void> onNotificationReceivedMethod(
      ReceivedNotification receivedNotification) async {}
  @pragma('vm:entry-point')
  static Future<void> onNotificationActionMethod(
      ReceivedNotification receivedNotification) async {}

  static Timer? _timer;

  static void scheduleNotificationChecks() {
    _timer?.cancel();

    _timer = Timer.periodic(Duration(hours: 5), (timer) async {
      print("checking for notifications...");
      await checkAndSendNotification();
    });
  }

  static Future<void> checkAndSendNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var userName = prefs.getString("userName");
    if (userName != null) {
      var userData = await fetchUserData(userName, 15);
      // var userData = await _getUserData();
      bool hasSolvedToday = await _checkIfSolvedToday(userData);
      if (!hasSolvedToday) {
        AwesomeNotifications().createNotification(
            content: NotificationContent(
                id: 2,
                channelKey: 'leety_channel',
                title: "Time for Leetcode!",
                body: "You haven't solved anything today..."));
      } else {
        print("Solved today");
      }
    }
  }

  static Future<bool> _checkIfSolvedToday(
      List<Map<String, String>>? userData) async {
    if (userData == null) {
      return false;
    }
    if (userData.isEmpty) {
      return false;
    }
    DateTime now = DateTime.now();
    for (var submission in userData) {
      String? timestampValue = submission['dateTime'];
      DateTime submissionDate = DateTime.parse(timestampValue!);
      if (submissionDate.day == now.day &&
          submissionDate.month == now.month &&
          submissionDate.year == now.year) {
        return true;
      }
    }

    return false;
  }

  static Future<List<Map<String, String>>> _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');
    if (userDataString != null) {
      List<dynamic> jsonData = jsonDecode(userDataString);
      var result =
          jsonData.map((item) => Map<String, String>.from(item)).toList();
      return result;
    }

    return [];
  }
}
