import 'dart:convert';

import 'package:facebook/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import '../utils/auth_token.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permission for iOS devices
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground messages
      print(
          'Received message: ${message.notification?.title} ${message.notification?.body}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle background messages
      print('Message clicked!');
    });
  }

  void saveTokenToServer() async {
    String? deviceToken = await FirebaseMessaging.instance.getToken();
    if (deviceToken != null) {
      String? backendToken = AuthToken().getToken;
      final response = await http.post(
        Uri.parse('http://$ip:$port/api/users/update-token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $backendToken',
        },
        body: jsonEncode(<String, String>{
          'deviceToken': deviceToken,
        }),
      );

      if (response.statusCode == 200) {
        print('Device token updated successfully');
      } else {
        print('Failed to update device token');
      }
    }
  }
  // void initialize() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     showNotification(message);
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     // Handle background messages
  //     print('Message clicked!');
  //   });

  //   const AndroidInitializationSettings initializationSettingsAndroid =
  //       AndroidInitializationSettings('@mipmap/ic_launcher');
  //   final InitializationSettings initializationSettings =
  //       InitializationSettings(
  //     android: initializationSettingsAndroid,
  //   );

  //   flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  void showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  void requestPermission() async {
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
