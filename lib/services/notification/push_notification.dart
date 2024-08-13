// ignore_for_file: unused_import

import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../Routes/routes.dart';

class PushNotification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        Map<String, dynamic> data = json.decode(payload.payload!);

        log('Notification tapped with payload: $payload');
        if (data.isNotEmpty) {
          try {
            log('Parsed notification data: $data');
            handleNotificationTap(data);
          } catch (e) {
            log('Error parsing notification payload: $e');
          }
        } else {
          log('Notification payload is null');
        }
      },
    );
  }

  static void requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not accepted permission');
    }
  }

  static void handleNotificationTap(Map<String, dynamic> data) {
    log('Notification tapped $data');
    String notificationType = data['notification_type'];
    if (notificationType == 'CALL_NOTIFICATION') {
      String callId = data['callID'] ?? data['call_id']; // Handle both keys
      log('Navigating to video call with callId: $callId');
      Get.toNamed(RouteName.videoCall, arguments: callId);
    } else if (notificationType == 'CLICK_NOTIFICATION') {
      if (data['type'] == 'chat') {
        String uid = data['uid'];
        log('Navigating to chat with uid: $uid');
        Get.toNamed(RouteName.chat, arguments: {'uid': uid});
      } else {
        log('Unknown notification type: ${data['type']}');
        log('Navigating to dashboard');
        Get.toNamed(RouteName.dashboard);
      }
    } else {
      log('Unknown notification type: $notificationType');
    }
  }

  static void showLocalNotification(
      String title, String body, Map<String, dynamic> payload) async {
    log('Showing local notification $title $body $payload');

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: json.encode(payload),
    );
  }

  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "car-fix-up",
      "private_key_id": "f456c5ab3014bd4e3788527f7006e652aac03942",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDCd1VvEBp5Ju5A\nTpMYczLzkDFjtwv+K/mPbvRxKEKq78OiDfSHHnM/XoXg7dKctJRmgt3LwqoHdXAg\nG4Xgqh1Vhf0RXvH9M7GZOyG5ppf3gJCk4rYDH99QKLPnZo9MK/zL8cPLJq5+UFd0\no+EaGwWLtl609oxP2NyKqG1hLA3gpvtsa3Zr5zX1kogGatY7fyo6J3Qjb4GjIFuN\nMAAKbRQmrARSx+GAhw8+DdmW14s9SgX8+5hEWS4Fs6PHOFpZHH0Q5FFzMo/cCXyp\nsWdZDol52PsjrPyuYkGm+Pkk0xZhEnRM2QT68J7NkjI13x3eaazt/jWWKcmE38N1\noPsUGAb7AgMBAAECggEAGdSB+5OXAJqkMNR/A1Nh5Co19Tm+FQ/AQUYKn/EqEcxx\nHthdr4ji4/rpK3xLalcuEwO09DiyHvWBZDJjsPjHlrGKcME8wVYZc/H/w8oWC2D/\nVXdrl7SnE92kL8tWo1aAaJJ/YD+OE+cWBr8xyibmsK0TnVPWRVDX0m8WwD56xWkM\n2MKK7kek6I4XHA8gPXprNYZJWIoxDwtuaJ5qZpeMfW5Zay+YwZmKYOySBtHWcX91\nzLjksQpu8XJJLPdClB2DN5UtBDS7mSeDPBv0wGrTj/pYLtjDb7Ig1gI1w02oa7hu\n6bKRZA05Tq+Y16A+tiwozHEtD+TngbpLm6UGdvnxMQKBgQD+f9MVJffj/Z11SqXB\n0J6rWaViWxBFPkVN9Ibbwtu2QqvCt5XH9erll4E3myanXi7ob4W116j2yekUSZb4\nJzDHkbdsplpGjHl93dOAAR9DIMUvLJjYSFmTbB9n8D/ymJcuLhV9li2nmnJckqA3\nerPZWGooX1gO0TmLBhmswto9WQKBgQDDnOMWHE4ZDrgto0QG5rnGIpqC+w5ncN6K\nFJ9KEbFy6xBRUvBYJWgy3wPTjeJRYONRqKwZ8xS77X/YTGrYK5/p7dtir63bF2sq\nIENlaAEJvjcrmHk14g/XMRW+VQd8yote/u4FeoF2bEwMmGu84cmtkiruZF+zgezw\nEDoMAFs4cwKBgQDQ9MCp/4ed8RDESer4zEJKrAsnS197ito6XEgRzda5udnuwO9A\nw7/+jDtzHXdKOgFHpLFjEVPQdQ1jM9y5mOvrH9A7bAZ5IENsPaK22bUCV7iut+4y\nvoyVh1Pt8gt/MxwFtZ69g32uvBejvFvB0YQzMu3OgiH54H1fkT2pZD7t2QKBgGjd\nKQvIXsGmF2w30xcUB1FFaal/5wfjBRnm1kHB3GvrwdKm8LuASizDS2zU6heQJiy3\njJNYsavRNTECPmDmehLQ9UQhQ8Vo94UcyKSLLctIUpEnawtMxgspgCuJr7rhZfem\nGHmNY+vVQKub5l3aeOB4tFUaMAeuRhOnz0ZxxnUrAoGAfvFO0u5eP/yKW5rKwPZ2\nDyxOtSQCj+JXhCtKRZIs6HNrAUIM8/ejJzhVEYPqLeELwfANiufqJYbjq01OK3x+\nZTXzIsU+LhZIXa3DCjX33ud1nWsDP38Ioyvh7D10jzSkWiNm2JIniAc5PJAHyyxE\nv8adEXGHg1WmDxr7A+Prm6I=\n-----END PRIVATE KEY-----\n",
      "client_email": "carfixupadmin@car-fix-up.iam.gserviceaccount.com",
      "client_id": "115696344430186044321",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/carfixupadmin%40car-fix-up.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
      client,
    );

    client.close();

    return credentials.accessToken.data;
  }

  static sendNotification(String deviceToken, String title, String body,
      Map<String, String> data) async {
    final String servrKey = await getAccessToken();
    log('Server key: $servrKey');
    String enPointFirebaseCloudMessage =
        'https://fcm.googleapis.com/v1/projects/car-fix-up/messages:send';
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $servrKey',
    };
    log("Server key: $servrKey");

    final Map<String, dynamic> payload = {
      "message": {
        "token": deviceToken,
        "notification": {"title": title, "body": body},
        "data": data
      }
    };
    final response = await http.post(
      Uri.parse(enPointFirebaseCloudMessage),
      headers: headers,
      body: json.encode(payload),
    );
    log(response.body);
    if (response.statusCode == 200) {
      log('Notification sent');
    } else {
      log('Notification not sent');
    }
  }
}
