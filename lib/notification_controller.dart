import 'package:awesome_notifications/awesome_notifications.dart';

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
}
