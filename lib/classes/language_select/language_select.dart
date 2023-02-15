// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cameroon_2/classes/custom/drawer/drawer.dart';
import 'package:cameroon_2/classes/dashboard/dashboard2.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:cameroon_2/classes/login/login.dart';
import 'package:cameroon_2/classes/page_control/page_control.dart';
import 'package:cameroon_2/classes/registration/registration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectScreen extends StatefulWidget {
  const LanguageSelectScreen({super.key, required this.str_from});

  final String str_from;

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  //
  // var arr_prefered_language = [];
  var str_select_language = '0';
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Prefered Language',
          style: TextStyle(
            fontFamily: font_family_name,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(170, 0, 20, 1),
                Color.fromRGBO(180, 30, 20, 1),
                Color.fromRGBO(218, 115, 32, 1),
                Color.fromRGBO(227, 142, 36, 1),
                Color.fromRGBO(236, 170, 40, 1),
                Color.fromRGBO(248, 198, 40, 1),
                Color.fromRGBO(252, 209, 42, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      drawer: const navigationDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(170, 0, 20, 1),
              Color.fromRGBO(180, 30, 20, 1),
              Color.fromRGBO(218, 115, 32, 1),
              Color.fromRGBO(227, 142, 36, 1),
              Color.fromRGBO(236, 170, 40, 1),
              Color.fromRGBO(248, 198, 40, 1),
              Color.fromRGBO(252, 209, 42, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          // color: Colors.amber,
          // image: DecorationImage(
          //   image: AssetImage('assets/images/yellow_bg.png'),
          //   fit: BoxFit.contain,
          // ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Image.asset(
                'assets/images/logo.png',
              ),
            ),
            //
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // height: 300,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    RichText(
                      text: TextSpan(
                        children: [
                          // const WidgetSpan(
                          //   child: Icon(
                          //     Icons.edit,
                          //     size: 16.0,
                          //   ),
                          // ),
                          TextSpan(
                            text: '',
                            style: TextStyle(
                              fontFamily: font_family_name,
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '',
                      style: TextStyle(
                        fontFamily: font_family_name,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(200, 60, 26, 1),
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(
                                  23,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            text_with_bold_style(
                              'France',
                            ),
                            //
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                if (kDebugMode) {
                                  print('france');
                                }
                                //
                                str_select_language = '2';
                                func_prefered_language();
                                //
                              },
                              icon: (str_select_language == '2')
                                  ? const Icon(
                                      Icons.check_box_rounded,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.white,
                                    ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(200, 60, 26, 1),
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(
                                  23,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            text_with_bold_style(
                              'English',
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                if (kDebugMode) {
                                  print('english');
                                }
                                //
                                str_select_language = '1';
                                func_prefered_language();
                                //
                              },
                              icon: (str_select_language == '1')
                                  ? const Icon(
                                      Icons.check_box_rounded,
                                      color: Colors.green,
                                    )
                                  : const Icon(
                                      Icons.check_box_outline_blank,
                                      color: Colors.white,
                                    ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        func_user_select_which_language();

                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PageControlScreen(),
                          ),
                        );*/
                      },
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          // color: const
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(42, 200, 40, 1),
                              Color.fromRGBO(38, 192, 40, 1),
                              Color.fromRGBO(36, 186, 34, 1),
                              Color.fromRGBO(30, 174, 32, 1),
                              Color.fromRGBO(28, 160, 28, 1),
                              Color.fromRGBO(28, 150, 24, 1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(
                            30,
                          ),
                        ),
                        child: Align(
                          child: (widget.str_from == 'yes')
                              ? Text(
                                  //
                                  text_update,
                                  //
                                  style: TextStyle(
                                    fontFamily: font_family_name,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  //
                                  'Get Started Now'.tr,
                                  //
                                  style: TextStyle(
                                    fontFamily: font_family_name,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  func_prefered_language() {
    if (str_select_language == '1') {
      var locale = const Locale('en');
      Get.updateLocale(locale);
    } else if (str_select_language == '2') {
      var locale = const Locale('fr');
      Get.updateLocale(locale);
    }
    setState(() {
      // if (kDebugMode) {
      //   print('yes user update language');
      // }
    });
  }

  //
  func_user_select_which_language() async {
    if (kDebugMode) {
      print(str_select_language);
    }

    //
    /*SharedPreferences preferences = await SharedPreferences.getInstance();
    if (str_select_language == '1') {
      preferences.setString('language', 'fr');
    } else if (str_select_language == '2') {
      preferences.setString('language', 'en');
    }*/

    if (widget.str_from == 'yes') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard2Screen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PageControlScreen(),
        ),
      );
    }
  }
}
