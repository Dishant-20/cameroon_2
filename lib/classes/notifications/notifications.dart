// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cameroon_2/classes/custom/drawer/drawer.dart';
import 'package:cameroon_2/classes/profile_details/profile_details.dart';
import 'package:http/http.dart' as http;

import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  //
  var arr_notification_list = [];
  //

  @override
  void initState() {
    super.initState();
    func_get_all_users_near_you();
  }

  func_get_all_users_near_you() async {
    // print('object');

    // setState(() {
    //   str_save_and_continue_loader = '0';
    // });

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
          'action': 'likelist',
          'userId': prefs.getInt('userId').toString(),
          // 'keyword': cont_search.text.toString(),
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
        arr_notification_list.clear();
        //
        // draggableItems.clear();
        // print('RAJPUTANA');
        // final data = Map<String, dynamic>.from(get_data);
        for (Map i in get_data['data']) {
          arr_notification_list.add(i);
        }

        if (arr_notification_list.isEmpty) {
          setState(() {
            // str_save_and_continue_loader = '2';
          });
        } else {
          setState(() {
            // str_save_and_continue_loader = '1';
          });
        }
      } else {
        print(
          '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
        );
      }
    } else {
      // return postList;
      print('something went wrong');
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontFamily: font_family_name,
          ),
        ),
        /*leading: IconButton(
          onPressed: () {
            if (kDebugMode) {
              print('');
            }
            Navigator.of(context).pop('');
          },
          icon: const Icon(
            Icons.chevron_left,
          ),
        ),*/
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
      body: Column(
        children: [
          for (int i = 0; i < arr_notification_list.length; i++) ...[
            InkWell(
              onTap: () {
                // push_to_add_sub_goal(context, i);
              },
              child: Container(
                margin: const EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    14.0,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.amber[800],
                        borderRadius: BorderRadius.circular(
                          40,
                        ),
                      ),
                      child: Container(
                        // height: 80,
                        // width: 80,
                        color: Colors.transparent,
                        child: (arr_notification_list[i]['image'].toString() ==
                                '')
                            ? Align(
                                child: Text(
                                  func_get_initials(
                                    arr_notification_list[i]['fullName']
                                        .toString(),
                                  ),
                                  style: TextStyle(
                                    fontFamily: font_family_name,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            : Image.network(
                                //
                                arr_notification_list[i]['image'].toString(),
                                //
                                fit: BoxFit.cover,
                                height: 80,
                                width: 80,
                              ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 10.0),
                        color: Colors.transparent,
                        child: Column(
                          children: <Widget>[
                            //
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  //
                                  arr_notification_list[i]['fullName']
                                      .toString(),
                                  //
                                  style: TextStyle(
                                    fontFamily: font_family_name,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                            //
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  //
                                  // 'ok ok',
                                  func_gender_reveal(
                                    arr_notification_list[i]['gender']
                                        .toString(),
                                  ),
                                  //
                                  style: TextStyle(
                                      fontFamily: font_family_name,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ),
                            ),
                            //
                            /*Expanded(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.pin_drop,
                                      size: 16,
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      //
                                      arr_notification_list[i]['address']
                                          .toString(),
                                      //
                                      style: TextStyle(
                                        fontFamily: font_family_name,
                                        fontSize: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),*/
                            //
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: InkWell(
                        onTap: () {
                          //
                          if (kDebugMode) {
                            print(arr_notification_list[i].toString());
                          }
                          //
                          if (kDebugMode) {
                            print('me');
                          }
                          //
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileDetailsScreen(
                                str_user_profile_id: arr_notification_list[i]
                                        ['userId']
                                    .toString(),
                                str_profile_notification: 'yes',
                              ),
                            ),
                          );
                          //
                          // push_to_chat(context, i);
                          //
                        },
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            // color: Colors.transparent,
                            borderRadius: BorderRadius.circular(
                              25,
                            ),
                            /*gradient: const LinearGradient(
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
                            ),*/
                          ),
                          width: 50,
                          height: 50,
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ],
      ),
    );
  }

  //
  //
  func_get_initials(String str_name) {
    var initials_are = str_name.split(' ');

    var final_initial_name = '';
    // print(initials_are.length);
    if (initials_are.length == 1) {
      final_initial_name = initials_are[0][0].toString().toUpperCase();
    } else if (initials_are.length == 2) {
      final_initial_name =
          (initials_are[0][0] + initials_are[1][0]).toString().toUpperCase();
    } else {
      final_initial_name = initials_are[0][0].toString().toUpperCase();
    }
    return final_initial_name;
  }

  //
  // gender
  func_gender_reveal(get_gender) {
    var set_gender;
    if (get_gender == '1') {
      set_gender = text_male;
    } else if (get_gender == '2') {
      set_gender = text_female;
    } else {
      set_gender = text_prefer_not_to_say;
    }

    return set_gender;
  }
}
