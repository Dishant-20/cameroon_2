// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cameroon_2/classes/custom/drawer/drawer.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  //
  var str_subscription_loader = '0';
  var arr_subscription = [];
  var arr_subscription_status = [];
  //

  @override
  void initState() {
    super.initState();
    subscription_details_WB();
  }

  subscription_details_WB() async {
    print('=====> POST : MY SUBSCRIPTION LIST');

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
          'action': 'subscription',
          // 'userId': prefs.getInt('userId').toString(),
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
        // arr_guild_list.clear();
        arr_subscription.clear();
        //
        for (Map i in get_data['data']) {
          arr_subscription.add(i);
        }

        for (int i = 0; i < arr_subscription.length; i++) {
          var custom = {
            'id': arr_subscription[i]['id'].toString(),
            'title': arr_subscription[i]['title'].toString(),
            'price': arr_subscription[i]['price'].toString(),
            'validDay': arr_subscription[i]['validDay'].toString(),
            'status': 'no',
          };
          arr_subscription_status.add(custom);
        }
        if (kDebugMode) {
          print(arr_subscription_status);
        }
        //
        setState(() {
          str_subscription_loader = '1';
        });
      } else {
        if (kDebugMode) {
          print(
            '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
          );
        }
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
          'Membership', //.toUpperCase(),
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
          image: DecorationImage(
            image: AssetImage(
              'assets/images/yellow_bg.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: (str_subscription_loader == '0')
            ? const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.orange,
                ),
              )
            : Column(
                children: [
                  for (int i = 0; i < arr_subscription_status.length; i++)
                    Container(
                      margin: const EdgeInsets.all(10.0),
                      // color: Colors.amber[600],
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          14.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                              0,
                              3,
                            ), // changes position of shadow
                          ),
                        ],
                      ),
                      // height: 48.0,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    // margin: const EdgeInsets.all(10.0),
                                    color: Colors.transparent,
                                    // width: MediaQuery.of(context).size.width,
                                    height: 48.0,
                                    child: Align(
                                      child: Text(
                                        //
                                        arr_subscription_status[i]['title']
                                            .toString(),
                                        //
                                        style: TextStyle(
                                          fontFamily: font_family_name,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                // //
                                (arr_subscription_status[i]['status']
                                            .toString() ==
                                        'no')
                                    ? IconButton(
                                        onPressed: () {
                                          if (kDebugMode) {
                                            print('icon click');
                                          }
                                          //
                                          func_change_status(i);
                                          //
                                        },
                                        icon: const Icon(
                                          Icons.check_box_outline_blank_sharp,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          if (kDebugMode) {
                                            print('icon click');
                                          }
                                          //
                                          func_change_status(i);
                                          //
                                        },
                                        icon: const Icon(
                                          Icons.check_box_outlined,
                                        ),
                                      )
                              ],
                            ),
                          ),
                          //
                          Container(
                            height: 2,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.grey,
                          ),
                          //
                          for (int i = 0; i < arr_subscription.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    'Free Trial Membership',
                                    style: TextStyle(
                                      fontFamily: font_family_name,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  //
  func_change_status(indexx) {
    if (kDebugMode) {
      print(indexx);
    }

/*
var custom = {
            'id': arr_subscription[i]['id'].toString(),
            'title': arr_subscription[i]['title'].toString(),
            'price': arr_subscription[i]['price'].toString(),
            'validDay': arr_subscription[i]['validDay'].toString(),
            'status': 'no',
          };
          */
    var str_id = arr_subscription_status[indexx]['id'].toString();
  }
}
