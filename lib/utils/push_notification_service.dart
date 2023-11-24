import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class PushNotificationService {
  static void sendPushNotification(String title, String body) async {
    final fcmToken = "66616B652D61706E732D746F6B656E2D666F722D73696D756C61746F72";
    Map<String, String> data = {
      'title': title,
      'body': body,
    };

    await FirebaseMessaging.instance.sendMessage(to: fcmToken, data: data);
  }

  static void sendNotification(String title, String body) async {
    final fcmToken = "66616B652D61706E732D746F6B656E2D666F722D73696D756C61746F72";
    final apiUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final serverKey = 'AAAAoZqBw4M:APA91bEtTRpbCXGa_hffoFkrDrUueNPyOlP3pEeKWrCOoNotzovGkejCozJfJqyhFGhM-vcmmzRTHAzpLgfAK269CzVmetr9EEXgs0X-GmmN-J0XLN1W9hAeihr-MCWsuLskqSK20GOz';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final data = {
      'notification': {
        'title': title,
        'body': body,
      },
      'priority': 'high',
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
      },
      'to': fcmToken,
    };

    final response = await http.post(
      apiUrl,
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print("Notification sent successfully");
    } else {
      print("Failed to send notification. Error: ${response.body}");
    }
  }
}