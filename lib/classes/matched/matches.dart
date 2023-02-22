// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'package:cameroon_2/classes/custom/drawer/drawer.dart';
import 'package:cameroon_2/classes/one_to_one_chat/one_to_one_chat.dart';
import 'package:cameroon_2/classes/profile_details/profile_details.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  //
  //
  var str_gender = '';
  var arr_swipe = [];
  var str_save_and_continue_loader = '0';
  //
  TextEditingController cont_search = TextEditingController();
  //
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
          'action': 'matchlist',
          'userId': prefs.getInt('userId').toString(),
          'keyword': cont_search.text.toString(),
          /*'latitude': str_lat,
          'longitude': str_long,
          'interent_in': prefs.getString('interent_in').toString(),*/
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
        arr_swipe.clear();
        //
        // draggableItems.clear();
        // print('RAJPUTANA');
        // final data = Map<String, dynamic>.from(get_data);
        for (Map i in get_data['data']) {
          arr_swipe.add(i);
        }

        if (arr_swipe.isEmpty) {
          setState(() {
            str_save_and_continue_loader = '2';
          });
        } else {
          setState(() {
            str_save_and_continue_loader = '1';
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
  var scaffoldKey = GlobalKey<ScaffoldState>();
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 170,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => scaffoldKey.currentState?.openDrawer(),
                    // {
                    //   // Navigator.pop(context);
                    //   navigationDrawer();
                    // },
                    icon: const Icon(
                      Icons.menu,
                    ),
                  ),
                  //
                  Text(
                    //
                    text_matches,
                    //
                    style: TextStyle(
                      fontFamily: font_family_name,
                      fontSize: 18,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 58,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  14.0,
                ),
              ),
              child: TextField(
                controller: cont_search,
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  print("Go button is clicked");
                  //
                  setState(() {
                    str_save_and_continue_loader = '0';
                  });
                  func_get_all_users_near_you();
                  //
                },
                decoration: InputDecoration(
                  // labelText: "Search",
                  hintText: text_search,
                  prefixIcon: const Icon(Icons.search),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        /*Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Chats',
                    style: TextStyle(
                      fontFamily: font_family_name,
                      color: Colors.black,
                    ),
                  ),
                  TextField(
                    controller: cont_search,
                    decoration: InputDecoration(
                      labelText: "Search",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            25.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),*/
        /*Text(
          'User Profile'.toUpperCase(),
          style: TextStyle(
            fontFamily: font_family_name,
          ),
        ),*/
        /*leading: IconButton(
          onPressed: () {
            if (kDebugMode) {
              print('');
            }
            Navigator.pop(context);
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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: (str_save_and_continue_loader == '2')
            ? const Align(
                child: Text(
                  'No match yet. Swipe more to get matches.',
                ),
              )
            : Column(
                children: [
                  for (int i = 0; i < arr_swipe.length; i++) ...[
                    InkWell(
                      onTap: () {
                        push_to_add_sub_goal(context, i);
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
                                child: (arr_swipe[i]['image'].toString() == '')
                                    ? Align(
                                        child: Text(
                                          func_get_initials(
                                            arr_swipe[i]['fullName'].toString(),
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
                                        arr_swipe[i]['image'].toString(),
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
                                          arr_swipe[i]['fullName'].toString(),
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
                                          func_gender_reveal(
                                            arr_swipe[i]['gender'].toString(),
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
                                    Expanded(
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
                                              arr_swipe[i]['address']
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
                                    ),
                                    //
                                  ],
                                ),
                              ),
                            ),
                            Center(
                              child: InkWell(
                                onTap: () async {
                                  //
                                  if (kDebugMode) {
                                    print(arr_swipe[i].toString());
                                  }
                                  //
                                  push_to_chat(context, i);
                                  //
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    // color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                      25,
                                    ),
                                    gradient: const LinearGradient(
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
                                  width: 50,
                                  height: 50,
                                  child: const Icon(
                                    Icons.chat,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey,
                    ),
                  ]
                ],
              ),
      ),
    );
  }

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

  //
  Future<void> push_to_add_sub_goal(BuildContext context, i) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileDetailsScreen(
          str_user_profile_id: arr_swipe[i]['userId'].toString(),
          str_profile_notification: 'no',
          str_friend_device_token: '',
        ),
      ),
    );

    // ignore: prefer_interpolation_to_compose_strings
    print('result =====> ' + result);

// back_after_add_sub_goal

    if (!mounted) return;

    // if (result)
    setState(() {
      str_save_and_continue_loader = '0';
    });
    func_get_all_users_near_you();
  }

  //
  Future<void> push_to_chat(BuildContext context, i) async {
    //
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OneToOneChatScreen(
          str_get_friend_id: arr_swipe[i]['userId'].toString(),
          str_get_login_user_id: prefs.getInt('userId').toString(),
          str_get_friend_name: arr_swipe[i]['fullName'].toString(),
          str_get_friend_image: arr_swipe[i]['image'].toString(),
          str_get_friend_device_token: '',
        ),
      ),
    );

    if (kDebugMode) {
      print('$result');
    }

    if (!mounted) return;

    setState(() {
      str_save_and_continue_loader = '0';
    });
    func_get_all_users_near_you();
  }
}
