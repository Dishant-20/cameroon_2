// import 'package:dust_trip_it/controllers/login/login.dart';
// import 'package:dust_trip_it/controllers/splash/splash.dart';
// ignore_for_file: no_leading_underscores_for_local_identifiers

// import 'dart:js';

import 'package:cameroon_2/classes/notifications/notifications.dart';
import 'package:cameroon_2/classes/page_control/page_control.dart';
import 'package:cameroon_2/classes/splash.dart';
import 'package:cameroon_2/classes/translation/LocalString.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:your_own_words/pages/splash/splash.dart';
// import 'package:your_own_words/pages/public_chat_screen/chat_screen.dart';
// import 'package:your_own_words/pages/welcome/welcome.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';

RemoteMessage? initialMessage;
FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

void main() async {
  //
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // show notification alert ( banner )
  NotificationSettings settings = await _firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('User granted permission =====> ${settings.authorizationStatus}');
  }
  //
  //
  final token = await _firebaseMessaging.getToken();
  //
  //
  if (kDebugMode) {
    print(token);
  }
  // save token locally
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('deviceToken', token.toString());
  //

  // background access
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // foreground access
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // CLICK ON NOTIFICATION EITHER IN FOREGORUND OR BACKGROUN
  FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
    if (kDebugMode) {
      print('=====> CLICK NOTIFICATION <=====');
    }
  });

  //
  //
  // notification data print here
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      // if (kDebugMode) {
      if (kDebugMode) {
        print("notification 2 ====> ${message.notification!.body}");
      }

      if (kDebugMode) {
        print('Handling a foreground message ${message.messageId}');
      }
      if (kDebugMode) {
        print('Notification Message: ${message.data}');
      }

      if (message.notification != null) {
        if (kDebugMode) {
          print(
              'Message also contained a notification: ${message.notification}');
        }
      }

      //
      //.. rest of your code
      // NotificationService.showNotification(message);

      // }
    },
    onDone: () {
      print('am i done');
    },
  );

  runApp(
    GetMaterialApp(
      translations: LocalString(),

      locale: const Locale('en', 'EN'),

      //
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    ),
  );
}

void showDialog(BuildContext context, Map<String, dynamic> message) {
  // data
  print('show');
}

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}
