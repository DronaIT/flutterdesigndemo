import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutterdesigndemo/ui/announcements/all_announcements.dart';
import 'package:flutterdesigndemo/ui/home.dart';
import 'package:flutterdesigndemo/utils/preference.dart';
import 'package:flutterdesigndemo/utils/tablenames.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PushNotificationService {
  String deviceToken = '';

  RemoteMessage? initialMessage;

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future initialize() async {
    if (!kIsWeb) {
      if (Platform.isIOS) {
        await _fcm.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
      }
    }

    // Enable Background Notification to retrieve any message which caused the application to open from a terminated state
    initialMessage = await _fcm.getInitialMessage();
    // This handles routing to a specific page when there's a click event on the notification
    void handleMessage(RemoteMessage message) {
      debugPrint("Message => $message");
      final payloadData = message.data; //jsonDecode(message.data);
      handleScreenRedirection(payloadData);
    }

    // This handles background notifications when the app is not terminated
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    //Enable foreground Notification for iOS
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    // To handle messages while your application is in foreground for android we listen to the onMessage stream.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("onSelectNotification=>$message");

      await showNotification(message);
    });
    //This is used to define the initialization settings for iOS and android
    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    // This handles routing to a specific page when there's a click event on the notification
    void onSelectNotification(NotificationResponse notificationResponse) async {
      var payloadData = jsonDecode(notificationResponse.payload!);
      debugPrint("onSelectNotification=>$payloadData");
      handleScreenRedirection(payloadData);
    }

    _flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onSelectNotification);
  }

  @pragma('vm:entry-point')
  Future showNotification(RemoteMessage message) async {
    debugPrint("onSelectNotification=>$message");

    // We create an Android Notification Channel that overrides the default FCM channel to enable heads up notifications.
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'fcm_default_channel',
      'High Importance Notifications',
      importance: Importance.high,
    );
    // This creates the channel on the device and if a channel with an id already exists, it will be updated
    await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    //This is used to display the foreground notification
    var notificationType = message.data["type"] as String?;
    debugPrint("Notification Type in showNotification $notificationType");
    if (message.notification != null) {
      RemoteNotification? notification = message.notification;
      AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channel.id,
        channel.name,
        importance: Importance.max,
        playSound: true,
        channelDescription: channel.description,
        priority: Priority.high,
        //  ongoing: true,
        styleInformation: const BigTextStyleInformation(''),
      );
      var iOSChannelSpecifics = const DarwinNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);

      if (notification?.android != null) {
        await _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification?.title,
          notification?.body,
          platformChannelSpecifics,
          payload: jsonEncode(message.data),
        );
      }
    } else {
      handleScreenRedirection(message.data);
    }
  }

  handleScreenRedirection(Map<String, dynamic> payload) {
    debugPrint("handleScreenRedirection: $payload");
    final notificationType = PushNotificationTypeX.from(payload["type"] as String?);
    final role = payload["role"] as String?;
    debugPrint("notificationType: $payload ==> $role");
    switch (notificationType) {
      case PushNotificationType.announcement:
        Get.to(const AllAnnouncements(), arguments: notificationType, preventDuplicates: false);
        break;
      case PushNotificationType.unknown:
        Get.to(const Home(), arguments: notificationType, preventDuplicates: false);
        break;
    }
  }

  static void sendNotificationToMultipleDevices(List<String> deviceTokens, String title, String body) async {
    if (PreferenceUtils.getIsPushEnabled() == "1") {
      final Map<String, dynamic> notification = {
        'title': title,
        'body': body,
      };
      final Map<String, dynamic> data = {
        'type': "unknown",
      };
      final Map<String, dynamic> payload = {
        'registration_ids': deviceTokens,
        'notification': notification,
        'data': data,
      };
      try {
        final http.Response response = await http.post(
          Uri.parse(TableNames.FCM_PUSH_API),
          body: jsonEncode(payload),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=${TableNames.FCM_KEY}',
          },
        );
        if (response.statusCode == 200) {
          debugPrint('Notification sent successfully to multiple devices.');
        } else {
          debugPrint('Failed to send notification. Error: ${response.reasonPhrase}');
        }
      } catch (e) {
        debugPrint('Exception while sending notification: $e');
      }
    }
  }
}

enum PushNotificationType {
  helpdesk,
  announcement,
  placement,
  unknown,
}

extension PushNotificationTypeX on PushNotificationType {
  static PushNotificationType from(String? value) {
    switch (value) {
      case "helpdesk":
        return PushNotificationType.helpdesk;
      case "announcement":
        return PushNotificationType.announcement;
      case "placement":
        return PushNotificationType.placement;
      default:
        return PushNotificationType.unknown;
    }
  }
}
