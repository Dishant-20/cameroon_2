// ignore_for_file: camel_case_types, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cameroon_2/classes/change_password/change_password.dart';
import 'package:cameroon_2/classes/dashboard/dashboard.dart';
import 'package:cameroon_2/classes/dashboard/dashboard2.dart';
import 'package:cameroon_2/classes/edit_profile/edit_profile.dart';
import 'package:cameroon_2/classes/gallery/gallery.dart';
import 'package:cameroon_2/classes/get_started_now/get_started_now.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:cameroon_2/classes/help/help.dart';
import 'package:cameroon_2/classes/language_select/language_select.dart';
import 'package:cameroon_2/classes/login/login.dart';
import 'package:cameroon_2/classes/matched/matches.dart';
import 'package:cameroon_2/classes/notifications/notifications.dart';
import 'package:cameroon_2/classes/subscription/subscription.dart';
import 'package:cameroon_2/classes/translation/LocalString.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
/*import 'package:triple_r_custom/Utils.dart';
import 'package:triple_r_custom/classes/book_service/book_service.dart';
import 'package:triple_r_custom/classes/booking_history/booking_history.dart';
import 'package:triple_r_custom/classes/change_password/change_password.dart';
import 'package:triple_r_custom/classes/continue_as_a/continue_as_a.dart';
import 'package:triple_r_custom/classes/dashboard/dashboard.dart';
import 'package:triple_r_custom/classes/edit_profile/edit_profile.dart';
import 'package:triple_r_custom/classes/help/help.dart';
import 'package:triple_r_custom/classes/login/login.dart';
import 'package:triple_r_custom/classes/registration/registration.dart';*/

import 'package:shared_preferences/shared_preferences.dart';

class navigationDrawer extends StatefulWidget {
  const navigationDrawer({Key? key}) : super(key: key);

  @override
  State<navigationDrawer> createState() => _navigationDrawerState();
}

class _navigationDrawerState extends State<navigationDrawer> {
  //
  var str_login_username = '';
  var str_login_email = '';
  //

  @override
  void initState() {
    super.initState();
    stored_local_data();
  }

  stored_local_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    str_login_username = prefs.getString('fullName').toString();
    str_login_email = prefs.getString('email').toString();
    // print(str_login_username);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.amber[400],
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            color: Colors.amber,
            child: const Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                '',
              ),
            ),
          ),
          Container(
            height: 00,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      //
                      str_login_username.toString(),
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
                /*Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      //
                      str_login_email.toString(),
                      //
                      style: TextStyle(
                        fontFamily: font_family_name,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),*/
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: 200,
            // color: Colors.brown,
            decoration: const BoxDecoration(
              // color: bg_color,
              image: DecorationImage(
                image: AssetImage(
                  // image name
                  'assets/images/login_back.png',
                ),
                fit: BoxFit.fitHeight,
                opacity: .4,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  iconColor: Colors.white,
                  title: Text(
                    //
                    text_dashboard,
                    //
                    style: TextStyle(
                      fontFamily: font_family_name,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    print('SIDE MENU ==> DASHBOARD');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Dashboard2Screen(
                            // get_login_sender_chat_id: 'Dashboard',
                            ),
                      ),
                    );

                    // Update the state of the app
                    // ...
                    // Then close the drawrer
                    // Navigator.pop(context);
                  },
                ),
                //
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                //
                ListTile(
                  leading: const Icon(Icons.edit),
                  iconColor: Colors.white,
                  title: Text(
                    //
                    text_edit_profile,
                    //
                    style: TextStyle(
                      fontFamily: font_family_name,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );
                  },
                ),
                //
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                //
                ListTile(
                  leading: const Icon(Icons.calendar_month),
                  iconColor: Colors.white,
                  title: Text(
                    //
                    text_gallery,
                    //
                    style: TextStyle(
                      fontFamily: font_family_name,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GalleryScreen(),
                      ),
                    );

                    // ...
                    // Then close the drawer
                    // Navigator.pop(context);
                  },
                ),
                //
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                //
                ListTile(
                  leading: const Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  iconColor: Colors.white,
                  title: Text(
                    //
                    text_matches,
                    //
                    style: TextStyle(
                      fontFamily: font_family_name,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MatchesScreen(),
                      ),
                    );

                    // ...
                    // Then close the drawer
                    // Navigator.pop(context);
                  },
                ),
                //
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                //
                ListTile(
                  leading: const Icon(
                    Icons.monetization_on,
                    color: Colors.white,
                  ),
                  iconColor: Colors.white,
                  title: Text(
                    //
                    text_subscription,
                    //
                    style: TextStyle(
                      fontFamily: font_family_name,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SubscriptionScreen(),
                      ),
                    );

                    // ...
                    // Then close the drawer
                    // Navigator.pop(context);
                  },
                ),
                //
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                //
                ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  iconColor: Colors.white,
                  title: Text(
                    //
                    'Notifications',
                    //
                    style: TextStyle(
                      fontFamily: font_family_name,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    );

                    // ...
                    // Then close the drawer
                    // Navigator.pop(context);
                  },
                ),
                //
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                //
                ListTile(
                  leading: const Icon(
                    Icons.language,
                    color: Colors.white,
                  ),
                  iconColor: Colors.white,
                  title: Text(
                    //
                    text_change_language,
                    //
                    style: TextStyle(
                      fontFamily: font_family_name,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    // Update the state of the app

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LanguageSelectScreen(
                          str_from: 'yes',
                        ),
                      ),
                    );

                    // ...
                    // Then close the drawer
                    // Navigator.pop(context);
                  },
                ),
                //
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                //
                /*ListTile(
                  leading: const Icon(Icons.list),
                  iconColor: Colors.white,
                  title: Text(
                    'Booking History',
                    style: TextStyle(
                      fontFamily: font_family_name,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    print('Booking history');
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const BookingHistoryScreen(),
                    //   ),
                    // );
                    // Then close the drawer
                    // Navigator.pop(context);
                  },
                ),*/
                ListTile(
                  leading: const Icon(Icons.lock),
                  iconColor: Colors.white,
                  title: Text(
                    //
                    text_change_password,
                    //
                    style: TextStyle(
                      fontFamily: font_family_name,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
                //
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                //
                ListTile(
                  leading: const Icon(Icons.help),
                  iconColor: Colors.white,
                  title: Text(
                    //
                    text_help,
                    //
                    style: TextStyle(
                      fontFamily: font_family_name,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HelpScreen(),
                      ),
                    );
                  },
                ),
                //
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                //
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                  ),
                  iconColor: Colors.white,
                  title: Text(
                    //
                    text_logout,
                    //
                    style: TextStyle(
                      fontFamily: font_family_name,
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  onTap: () {
                    _showMyDialog();
                  },
                ),
                //
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  height: 1,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                ),
                //
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            //
            text_alert,
            //
            style: TextStyle(
              fontFamily: font_family_name,
              fontSize: 16.0,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  //
                  text_logout_alert,
                  //
                  style: TextStyle(
                    fontFamily: font_family_name,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                //
                text_logout,
                //
                style: TextStyle(
                  fontFamily: font_family_name,
                  fontSize: 16.0,
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                //
                Navigator.pop(context);
                //
                logout_WB();
                //
              },
            ),
            TextButton(
              child: Text(text_dismiss),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //
  logout_WB() async {
    if (kDebugMode) {
      print('=====> POST : logout');
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    final resposne = await http.post(
      Uri.parse(
        application_base_url,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'logout',
          'userId': prefs.getInt('userId').toString(),
        },
      ),
    );

    // convert data to dict
    var get_data = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(get_data);
    }

    if (resposne.statusCode == 200) {
      if (get_data['status'].toString().toLowerCase() == 'success') {
        //
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.clear().then((value) => {
              // print(preferences.getString('fullName')),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GetStartedNowScreen(),
                ),
              ),
            });
        //
      } else {
        print(
          '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
        );
      }
    } else {
      // return postList;
      if (kDebugMode) {
        print('something went wrong');
      }
    }
  }
  //
}
