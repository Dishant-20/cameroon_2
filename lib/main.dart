// import 'package:dust_trip_it/controllers/login/login.dart';
// import 'package:dust_trip_it/controllers/splash/splash.dart';
import 'package:cameroon_2/classes/splash.dart';
import 'package:cameroon_2/classes/translation/LocalString.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:your_own_words/pages/splash/splash.dart';
// import 'package:your_own_words/pages/public_chat_screen/chat_screen.dart';
// import 'package:your_own_words/pages/welcome/welcome.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

void main() async {
  //
  //
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final token = await _firebaseMessaging.getToken();
  //
  //
  if (kDebugMode) {
    print(token);
  }

//
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  //
  FirebaseMessaging.onMessage.listen(
    (event) {
      if (kDebugMode) {
        print("event ${event.notification!.body}");
      }
    },
  );

// add something ?

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
