// ignore_for_file: non_constant_identifier_names

import 'dart:async';

// import 'package:cameroon_2/classes/dashboard/dashboard.dart';
// import 'package:cameroon_2/classes/get_started_now/get_started_now.dart';
// import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:cameroon_2/classes/language_select/language_select.dart';
import 'package:cameroon_2/classes/page_control/page_control.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      // print('TImer active');
      // print(t.isActive);
      // print(t.tick);

      if (t.tick == 2) {
        t.cancel();
        func_push_to_next_screen();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    if (timer != null) {
      timer!.cancel();
    }
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
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PageControlScreen(),
      ),
    );*/
  }
}
