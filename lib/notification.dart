import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show Platform;
import 'package:rxdart/subjects.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification>
      didRecievedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;
  NotificationPlugin._() {
    init();
  }

  init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermision();
    }

    initializePlatformSpecifics();
  }

  void _requestIOSPermision() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(alert: true, badge: true, sound: true);
  }

  void initializePlatformSpecifics() {
    var initializeSettingAndroid = AndroidInitializationSettings('icon');
    var initializeSettingIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceivedNotification receivedNotification = ReceivedNotification(
              id: id, title: title, payload: payload, body: body);

          didRecievedLocalNotificationSubject.add(receivedNotification);
        });

    initializationSettings = InitializationSettings(
        android: initializeSettingAndroid, iOS: initializeSettingIOS);
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      await onNotificationClick(payload);
    });
  }

  setListnerForLowerVersions(Function onNotificationInlowerVersions) {
    didRecievedLocalNotificationSubject.listen((value) {
      onNotificationInlowerVersions(value);
    });
  }

  clearAllNotification() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> showNotification(id, title, body, payload,type) async {
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESC',
      importance: Importance.max,
      priority: Priority.high,
      enableLights: true,
      enableVibration: true,
      autoCancel: true,
      playSound: true,
    );

    var iosChannel = IOSNotificationDetails();

    var platformChannel =
        NotificationDetails(android: androidChannel, iOS: iosChannel);

    await flutterLocalNotificationsPlugin.show(id, title, body, platformChannel,
        payload: type+'/'+payload.toString());
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({this.body, this.id, this.payload, this.title});
}
