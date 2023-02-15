// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cameroon_2/classes/custom/drawer/drawer.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/material.dart';
// import 'package:triple_r_custom/Utils.dart';
// import 'package:triple_r_custom/custom_files/app_bar/appbar.dart';
// import 'package:triple_r_custom/custom_files/drawer/drawer.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

// import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  //
  //

  var str_phone = text_please_wait;
  var str_email = text_please_wait;
  //
  //

  @override
  void initState() {
    super.initState();
    //
    get_help_WB();
    //
  }

  // get help
  get_help_WB() async {
    print('=====> GET CART');

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(prefs.getInt('userId').toString());
    final resposne = await http.post(
      Uri.parse(
        application_base_url,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'help',
        },
      ),
    );

// convert data to dict
    var get_data = jsonDecode(resposne.body);
    print(get_data);
    // print(get_data['data'][0]['id']);
    if (resposne.statusCode == 200) {
      ///
      ///
      if (get_data['status'].toString().toLowerCase() == 'success') {
        //
        str_email = get_data['data']['eamil'].toString();
        str_phone = get_data['data']['phone'].toString();
        //
        setState(() {});
      } else {
        print(
          '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
        );
      }
    } else {
      // return postList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(
          //
          text_help,
          //,
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.amber,
          image: DecorationImage(
            image: AssetImage(
              // image name
              'assets/images/login_back.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Container(
                  // height: 350,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: AssetImage(
                        // image name
                        'assets/images/logo.png',
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                  // height: 300,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      height: 160,
                      child: Column(
                        children: [
                          Text(
                            '$text_need_help :\n',
                            style: TextStyle(
                              fontFamily: font_family_name,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                          ),
                          //
                          InkWell(
                            onTap: () async {
                              FlutterPhoneDirectCaller.callNumber(
                                str_phone.toString(),
                              );
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: text_with_bold_style(
                                  str_phone.toString(),
                                ),
                              ),
                              //height: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              _sendingMails();
                            },
                            child: Container(
                              color: Colors.transparent,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: text_with_bold_style(
                                  '$str_email\n',
                                ),
                              ),
                              //height: 20,
                            ),
                          ),
                          //

                          //
                        ],
                      ),
                    ),
                  )),
            ),
            Expanded(
              child: Container(
                // height: 300,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Center(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      '@ 2023 Cameroon Singles.\n   $text_help_rights.',
                      style: TextStyle(
                        fontFamily: font_family_name,
                        fontSize: 16.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            /*Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(
                  12.0,
                ),
                child: Container(
                  // height: 100,
                  width: MediaQuery.of(context).size.width,

                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: AssetImage(
                        // image name
                        logo_name_image,
                      ),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                // height: 100,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                // height: 500,
                width: MediaQuery.of(context).size.width,
                color: Colors.amber,
                child: Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(
                            12.0,
                          ),
                          child: Text(
                            '@ 2022 Triple R Custom Detail.',
                            style: TextStyle(
                              fontFamily: 'Avenir Next',
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                            12.0,
                          ),
                          child: Text(
                            'All Rights Reserved',
                            style: TextStyle(
                              fontFamily: 'Avenir Next',
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                // height: 500,
                width: MediaQuery.of(context).size.width,
                color: Colors.amber,
                child: Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(
                            12.0,
                          ),
                          child: Text(
                            '@ 2022 Triple R Custom Detail.',
                            style: TextStyle(
                              fontFamily: 'Avenir Next',
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(
                            12.0,
                          ),
                          child: Text(
                            'All Rights Reserved',
                            style: TextStyle(
                              fontFamily: 'Avenir Next',
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )*/
          ],
        ),
      ),
    );
  }

  _sendingMails() async {
    var url = Uri.parse("mailto:$str_email");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
