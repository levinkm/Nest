import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class FCMService {
  static final FCMService _instance = FCMService._();
  factory FCMService() => _instance;
  FCMService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permission
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      developer.log('FCM: Permission granted');

      // Get FCM token
      final token = await _messaging.getToken();
      if (token != null) {
        developer.log('FCM Token: $token');
        await _saveToken(token);
      }

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Handle notification taps
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
    }
  }

  Future<void> _initializeLocalNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        developer.log('Notification tapped: ${details.payload}');
      },
    );
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    developer.log('Foreground message: ${message.notification?.title}');

    if (message.notification != null) {
      await _showLocalNotification(
        message.notification!.title ?? 'Nest',
        message.notification!.body ?? '',
        message.data,
      );
    }
  }

  Future<void> _showLocalNotification(
    String title,
    String body,
    Map<String, dynamic> data,
  ) async {
    const android = AndroidNotificationDetails(
      'nest_channel',
      'Nest Notifications',
      channelDescription: 'Financial notifications from Nest',
      importance: Importance.high,
      priority: Priority.high,
    );
    const ios = DarwinNotificationDetails();
    const details = NotificationDetails(android: android, iOS: ios);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: data.toString(),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    developer.log('Notification opened: ${message.data}');
    // Handle navigation based on message.data
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fcm_token');
  }

  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    developer.log('Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    developer.log('Unsubscribed from topic: $topic');
  }
}

// Top-level function for background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  developer.log('Background message: ${message.notification?.title}');
}
