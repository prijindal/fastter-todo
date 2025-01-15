import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../helpers/logger.dart';
import 'core.dart';

class LocalNotificationsManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool initialized = false;

  LocalNotificationsManager() {
    tz.initializeTimeZones();
  }

  bool get isSupported => !kIsWeb && !Platform.isWindows;

  Future<void> init() async {
    if (!isSupported) return;
    AppLogger.instance.d("Initializing notifications");
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  Future<bool> requestPermissions() async {
    if (!isSupported) return false;
    AppLogger.instance.d("Requesting permissions for notifications");
    if (Platform.isAndroid) {
      final platformSpecificImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (platformSpecificImplementation == null) return false;
      final notificationPermission = await platformSpecificImplementation
              .requestNotificationsPermission() ??
          false;
      final alarmPermission =
          await platformSpecificImplementation.requestExactAlarmsPermission() ??
              false;
      return notificationPermission && alarmPermission;
    } else if (Platform.isIOS) {
      return await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: false,
                badge: false,
                sound: false,
              ) ??
          false;
    } else if (Platform.isMacOS) {
      return await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  MacOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(
                alert: false,
                badge: false,
                sound: false,
              ) ??
          false;
    }
    return true;
  }

  Future<bool> register() async {
    if (!isSupported) return false;
    if (!initialized) {
      await init();
      final status = await requestPermissions();
      if (status == false) {
        return false;
      }
      initialized = true;
    }
    return true;
  }

  Future<List<PendingNotificationRequest>> _pendingNotificationRequests() =>
      flutterLocalNotificationsPlugin.pendingNotificationRequests();

  Future<void> _cancelNotification(int id) =>
      flutterLocalNotificationsPlugin.cancel(id);

  Future<void> _zonedSchedule(ReminderData reminder) =>
      flutterLocalNotificationsPlugin.zonedSchedule(
        reminder.id.hashCode,
        reminder.title,
        reminder.title,
        tz.TZDateTime.from(reminder.time, tz.local),
        NotificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

  Future<void> syncReminders(List<ReminderData> reminders) async {
    if (!isSupported) return;
    if (!initialized) return;
    final pendingNotifications = await _pendingNotificationRequests();
    for (var pendingNotification in pendingNotifications) {
      if (reminders
          .where((a) => a.id.hashCode == pendingNotification.id)
          .isEmpty) {
        // When reminder is not present, cancel notification
        await _cancelNotification(pendingNotification.id);
      }
    }
    for (final reminder in reminders) {
      if (reminder.time.compareTo(DateTime.now()) >= 0) {
        // When notification not present, schedule it
        if (pendingNotifications
            .where((a) => a.id == reminder.id.hashCode)
            .isEmpty) {
          await _zonedSchedule(reminder);
          AppLogger.instance
              .i("Scheduled new notification at ${reminder.time}");
        }
      }
    }
  }
}
