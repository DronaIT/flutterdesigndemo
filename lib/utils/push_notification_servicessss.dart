import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class PushNotificationServicess {
  static void sendPushNotification(String title, String body) async {
    final fcmToken = "66616B652D61706E732D746F6B656E2D666F722D73696D756C61746F72";
    Map<String, String> data = {
      'title': title,
      'body': body,
    };

    await FirebaseMessaging.instance.sendMessage(to: fcmToken, data: data);
  }

  static void sendNotification(String title, String body) async {
    final fcmToken =
        "dVT3AwH5SjC57axONg1Ib_:APA91bEwOWWVFv-e7ndaZki2bY0n-N__Nt5my2Iiz9jxmbMVXSEqW5YdLMmnJ25XhDkcZIMMPI9fPGr8HH4ZXjjXbVLMqz9ZXPRnBZMYXnRfM_PngCEG4VlwnYYO8NjWIWS83Zzn7j9L";
    final apiUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final serverKey =
        'AAAAoZqBw4M:APA91bEtTRpbCXGa_hffoFkrDrUueNPyOlP3pEeKWrCOoNotzovGkejCozJfJqyhFGhM-vcmmzRTHAzpLgfAK269CzVmetr9EEXgs0X-GmmN-J0XLN1W9hAeihr-MCWsuLskqSK20GOz';
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
      debugPrint("Notification sent successfully");
    } else {
      debugPrint("Failed to send notification. Error: ${response.body}");
    }
  }

  static void sendNotificationToMultipleDevices(List<String> deviceTokens) async {
    deviceTokens.add("ecfLgmoHTCCk-dkR6lnpmo:APA91bFtyuFXKws4SZcBzg6QgXuksisxq9phkQ6LTiP6O4k-OTm0ZUIpotmVHSAr_n1FU1UyV3SJg_U3k-63aYRIKrKyR50yOORjvxucsPLzV5OoTpNAooipTZKcdK5NHkKuDEfPwweg");
    deviceTokens.add("dVT3AwH5SjC57axONg1Ib_:APA91bEwOWWVFv-e7ndaZki2bY0n-N__Nt5my2Iiz9jxmbMVXSEqW5YdLMmnJ25XhDkcZIMMPI9fPGr8HH4ZXjjXbVLMqz9ZXPRnBZMYXnRfM_PngCEG4VlwnYYO8NjWIWS83Zzn7j9L");
    deviceTokens.add("dPH8i9sjSFWbjT7gduLEdq:APA91bF0MEO7sB9NRjfoo2rchoFE3m8ptblOzwVB3PBfdI_Iz-1g-o4EZr9m1bOBoDrYENB5pjakx_C5QbOvAgNCeLtdZGiugK1nQviwf3oseJ6M4DDLLtndMW9Coq1-rp_E6kInC7z_");
    deviceTokens.add("dX_SgLhwSTWOIpmnk9S7nW:APA91bEYqeeTBYVXz6fpTUvfGRbwZSyN48eIK7sbVU0MERmLAjdINf5oQi0JmMZt_D2GI9Ty_qFSVmFgAQ8hRnkuqmRXpOx6b3LeI5DSQIifWI3Vsj3qCgpj2eVBuLcb-RnfKg2kYV5J");

    const serverKey =
        'AAAAoZqBw4M:APA91bEtTRpbCXGa_hffoFkrDrUueNPyOlP3pEeKWrCOoNotzovGkejCozJfJqyhFGhM-vcmmzRTHAzpLgfAK269CzVmetr9EEXgs0X-GmmN-J0XLN1W9hAeihr-MCWsuLskqSK20GOz';
    const String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
    final Map<String, dynamic> notification = {
      'title': 'hello thanks ',
      'body': 'YO yoooo yyooo ',
    };
    final Map<String, dynamic> data = {
      'type': 'announcement',
    };
    final Map<String, dynamic> payload = {
      'registration_ids': deviceTokens,
      'notification': notification,
      'data': data,
    };
    try {
      final http.Response response = await http.post(
        Uri.parse(fcmUrl),
        body: jsonEncode(payload),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
      if (response.statusCode == 200) {
        print('Notification sent successfully to multiple devices.');
      } else {
        print('Failed to send notification. Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Exception while sending notification: $e');
    }
  }
}
