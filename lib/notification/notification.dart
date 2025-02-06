import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseApi {
  final _firebasemessageing = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    "High importance Notifications",
    description: "Booking done",
    importance: Importance.defaultImportance,
  );
  final _localNotications = FlutterLocalNotificationsPlugin();
  Future<void> handleBackgroudMessage(RemoteMessage message) async {
    print("Title:${message.notification?.title}");
    print("body:${message.notification?.body}");
    print("Payload:${message.data}");
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((value) => handleBackgroudMessage);
    FirebaseMessaging.onMessageOpenedApp
        .listen((event) => handleBackgroudMessage);
    FirebaseMessaging.onMessage.listen((event) {
      final notification = event.notification;
      if (notification == null) return;
      _localNotications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_launcher',
              playSound: true,
            ),
          ),
          payload: jsonEncode(event.toMap()));
    });
  }

  Future initLocalNotifications() async {
    const android = AndroidInitializationSettings("@drawable/ic_launcher");
    const settings = InitializationSettings(
      android: android,
    );
    await _localNotications.initialize(settings);
    final platform = _localNotications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  /*Future<void> initNotifications() async {
    await _firebasemessageing.requestPermission();
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    //final fcmToken = await _firebasemessageing.getToken();
    // print("token --  $fcmToken");
    await initPushNotifications();
    await initLocalNotifications();
    FirebaseMessaging.onBackgroundMessage(
        (message) => handleBackgroudMessage(message));
  }
  */

  Future<void> initNotifications() async {
    try {
      await Future.wait([
        _firebasemessageing.requestPermission(),
        FirebaseMessaging.instance.setAutoInitEnabled(true),
        initPushNotifications(),
        initLocalNotifications(),
      ]);

      FirebaseMessaging.onBackgroundMessage(
          (message) => handleBackgroudMessage(message));
    } catch (e) {
      print("Error initializing notifications: $e");
    }
  }
}
