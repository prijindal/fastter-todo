import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_windows/flutter_local_notifications_windows.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../helpers/logger.dart';
import 'core.dart';

class LocalNotificationsManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FlutterLocalNotificationsWindows flutterLocalNotificationsWindows =
      FlutterLocalNotificationsWindows();
  bool initialized = false;

  LocalNotificationsManager() {
    tz.initializeTimeZones();
  }

  Future<void> init() async {
    AppLogger.instance.d("Initializing notifications");
    if (Platform.isWindows) {
      final WindowsInitializationSettings initializationSettingsWindows =
          WindowsInitializationSettings(
        appName: "Fastter Todo",
        appUserModelId: "com.prijindal.FastterTodo",
        guid: "d49b0314-ee7a-4626-bf79-97cdb8a991bb",
      );
      flutterLocalNotificationsWindows
          .initialize(initializationSettingsWindows);
    } else {
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
  }

  Future<bool> requestPermissions() async {
    if (kIsWasm) return false;
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
    if (kIsWeb) return false;
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
      Platform.isWindows
          ? flutterLocalNotificationsWindows.pendingNotificationRequests()
          : flutterLocalNotificationsPlugin.pendingNotificationRequests();

  Future<void> _cancelNotification(int id) => Platform.isWindows
      ? flutterLocalNotificationsWindows.cancel(id)
      : flutterLocalNotificationsPlugin.cancel(id);

  Future<void> _zonedSchedule(ReminderData reminder) => Platform.isWindows
      ? flutterLocalNotificationsWindows.zonedSchedule(
          reminder.id.hashCode,
          reminder.title,
          reminder.title,
          tz.TZDateTime.from(reminder.time, tz.local),
          WindowsNotificationDetails(),
        )
      : flutterLocalNotificationsPlugin.zonedSchedule(
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
    if (kIsWeb) return;
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
