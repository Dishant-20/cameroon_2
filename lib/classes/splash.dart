// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:async';

// import 'package:cameroon_2/classes/dashboard/dashboard.dart';
// import 'package:cameroon_2/classes/get_started_now/get_started_now.dart';
// import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:cameroon_2/classes/audio_call/audio_call.dart';
import 'package:cameroon_2/classes/language_select/language_select.dart';
import 'package:cameroon_2/classes/page_control/page_control.dart';
import 'package:cameroon_2/classes/video_call/video_call.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'firebase_options.dart';

RemoteMessage? initialMessage;
FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;

  //
  String? notifTitle, notifBody;

  @override
  void initState() {
    super.initState();

    //
    // FirebaseMessaging.instance.getToken().then(
    //       (value) => {
    //         print("FCM Token Is: ============> newly"),
    //         print(
    //           value,
    //         ),
    //       },
    //     );

    func_get_device_token();
    func_get_full_data_of_notification();
    func_click_on_notification();
    //
    // PRINT FULL NOTIFICATION DATA
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

        // push to audio
        if (message.notification!.body == 'Incoming audio call') {
        } else {}

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
    //
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      //
      if (t.tick == 2) {
        t.cancel();
        func_push_to_next_screen();
      }
    });
  }

  func_get_device_token() async {
    //
    final token = await _firebaseMessaging.getToken();

    //
    //
    if (kDebugMode) {
      print('=============> HERE IS MY DEVICE TOKEN <=============');
      print('======================================================');
      print(token);
      print('======================================================');
      print('======================================================');
    }
    // save token locally
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('deviceToken', token.toString());
    //
  }

  @override
  void dispose() {
    super.dispose();

    if (timer != null) {
      timer!.cancel();
    }
  }

// get notification in foreground
  func_get_full_data_of_notification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('=====> GOT NOTIFICATION IN FOREGROUND <=====');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        setState(() {
          notifTitle = message.notification!.title;
          notifBody = message.notification!.body;
        });
      }
    });
  }

  func_click_on_notification() {
// FirebaseMessaging.configure

    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      if (kDebugMode) {
        print('=====> CLICK NOTIFICATIONs <=====');
        print(remoteMessage.data);
      }

      if (remoteMessage.data['type'].toString() == 'audioCall') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AudioCallScreen(
              str_start_pick_end_call: 'get_a_call',
              str_friend_image: remoteMessage.data['image'].toString(),
              str_friend_name: remoteMessage.data['name'].toString(),
              str_device_token: '',
              str_channel_name: remoteMessage.data['channel'].toString(),
              str_get_device_name: remoteMessage.data['device'].toString(),
            ),
          ),
        );
      } else if (remoteMessage.data['type'].toString() == 'videoCall') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoCallScreen(
              str_from_notification: 'yes',
              str_channel_name: remoteMessage.data['channel'].toString(),
              str_friend_device_token: '',
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          // margin: const EdgeInsets.all(10.0),
          // color: Colors.amber[600],
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/splash_back.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          // width: 48.0,
          // height: 48.0,
          child: Align(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/logo.png",
              height: 340,
            ),
          ),
        ),
      ),
      /*,*/
    );
  }

// add comment
// add me
  func_push_to_next_screen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LanguageSelectScreen(
          str_from: 'no',
        ),
      ),
    );
  }
}
