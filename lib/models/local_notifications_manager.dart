import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../helpers/logger.dart';
import '../router/app_router.dart';
import 'core.dart';
import 'local_db_state.dart';

class LocalNotificationsManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool initialized = false;
  LocalDbState get state => GetIt.I<LocalDbState>();

  LocalNotificationsManager() {
    tz.initializeTimeZones();
  }

  bool get isSupported => !kIsWeb && !Platform.isWindows;

  Future<void> init() async {
    if (!isSupported) return;
    AppLogger.instance.d("Initializing notifications");
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
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
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) {
      AppLogger.instance.d(
          "Received notification: ${details.id}, payload: ${details.payload}");
      if (details.payload != null) {
        AppRouter appRouter = GetIt.I<AppRouter>();
        final reminderId = details.payload!;
        final reminder = state.reminders.singleWhere((a) => a.id == reminderId);
        appRouter.navigateNamed("/todo/${reminder.todo}");
      }
    });
    flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((notification) {
      if (notification != null &&
          notification.didNotificationLaunchApp &&
          notification.notificationResponse != null &&
          notification.notificationResponse!.payload != null) {
        AppRouter appRouter = GetIt.I<AppRouter>();
        final reminderId = notification.notificationResponse!.payload!;
        final reminder = state.reminders.singleWhere((a) => a.id == reminderId);
        appRouter.navigateNamed("/todo/${reminder.todo}");
      }
    });
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
      await Permission.ignoreBatteryOptimizations.request();
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

  Future<List<PendingNotificationRequest>> pendingNotificationRequests() =>
      flutterLocalNotificationsPlugin.pendingNotificationRequests();

  Future<void> cancelNotification(int id) =>
      flutterLocalNotificationsPlugin.cancel(id);

  Future<void> _zonedSchedule(ReminderData reminder, TodoData todo) =>
      flutterLocalNotificationsPlugin.zonedSchedule(
        reminder.id.hashCode,
        todo.title,
        todo.pipeline,
        tz.TZDateTime.from(reminder.time, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            "remnders",
            "Reminders",
            channelDescription: "To show reminders of a todo",
            category: AndroidNotificationCategory.reminder,
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
        payload: reminder.id,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

  Future<void> syncReminders(
    List<ReminderData> reminders,
    List<TodoData> todos,
  ) async {
    if (!isSupported) return;
    if (!initialized) return;
    final pendingNotifications = await pendingNotificationRequests();
    for (var pendingNotification in pendingNotifications) {
      if (reminders
          .where((a) => a.id.hashCode == pendingNotification.id)
          .isEmpty) {
        // When reminder is not present, cancel notification
        await cancelNotification(pendingNotification.id);
      }
    }
    for (final reminder in reminders) {
      if (reminder.time.compareTo(DateTime.now()) >= 0) {
        // When notification not present, schedule it
        if (pendingNotifications
            .where((a) => a.id == reminder.id.hashCode)
            .isEmpty) {
          final todo = todos.where((a) => a.id == reminder.todo).singleOrNull;
          if (todo != null) {
            await _zonedSchedule(reminder, todo);
            AppLogger.instance
                .i("Scheduled new notification at ${reminder.time}");
          }
        }
      }
    }
  }
}
