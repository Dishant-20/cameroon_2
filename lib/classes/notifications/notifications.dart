// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cameroon_2/classes/custom/drawer/drawer.dart';
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
      // body: ,
    );
  }
}
