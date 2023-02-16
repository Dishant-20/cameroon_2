// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:cameroon_2/classes/custom/drawer/drawer.dart';
import 'package:cameroon_2/classes/profile_details/profile_details.dart';
import 'package:http/http.dart' as http;

import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NearbyFriendsScreen extends StatefulWidget {
  const NearbyFriendsScreen({super.key});

  @override
  State<NearbyFriendsScreen> createState() => _NearbyFriendsScreenState();
}

class _NearbyFriendsScreenState extends State<NearbyFriendsScreen> {
  //
  var str_gender = '';
  var arr_swipe = [];
  var str_save_and_continue_loader = '0';
  //
  TextEditingController cont_search = TextEditingController();
  //
  var str_latitude = '';
  var str_longitude = '';

  @override
  void initState() {
    super.initState();
    func_position();
  }

  func_position() async {
    print('===> GET USER LOCATION <====');
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude.toString());
    print(position.longitude.toString());
    // print(position.altitude);

    str_latitude = position.latitude.toString();
    str_longitude = position.longitude.toString();
    //
    func_get_all_users_near_you();
  }

  //
  func_get_all_users_near_you() async {
    // print('object');

    // setState(() {
    //   str_save_and_continue_loader = '0';
    // });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    /*print(prefs.getString('interent_in').toString());
    var str_interest_in;
    if (prefs.getString('interent_in').toString() == '1') {
      str_interest_in = 'Male';
    } else if (prefs.getString('interent_in').toString() == '2') {
      str_interest_in = 'Female';
    } else if (prefs.getString('interent_in').toString() == '3') {
      str_interest_in = 'Other';
    }*/

    final resposne = await http.post(
      Uri.parse(
        application_base_url,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'finduser',
          'userId': prefs.getInt('userId').toString(),
          'latitude': str_latitude.toString(),
          'longitude': str_longitude.toString(),
          'interent_in': prefs.getString('interent_in').toString(),
          'keyword': cont_search.text.toString(),
        },
      ),
    );

    // convert data to dict
    var get_data = jsonDecode(resposne.body);
    print(get_data);

    //
    arr_swipe.clear();
    //
    if (resposne.statusCode == 200) {
      if (get_data['status'].toString().toLowerCase() == 'success') {
        //
        // draggableItems.clear();
        // print('RAJPUTANA');
        // final data = Map<String, dynamic>.from(get_data);
        for (Map i in get_data['data']) {
          arr_swipe.add(i);
        }

        //
        // cont_search.text = '';
        //
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 170,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: (str_save_and_continue_loader == '0')
            ? const CircularProgressIndicator()
            : Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.chevron_left,
                          ),
                        ),
                        //
                        Text(
                          //
                          text_nearby_friend,
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
                        if (kDebugMode) {
                          print("Go button is clicked");
                        }
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
        child: Column(
          children: [
            for (int i = 0; i < arr_swipe.length; i++) ...[
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileDetailsScreen(
                        str_user_profile_id: arr_swipe[i]['id'].toString(),
                        str_profile_notification: 'no',
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width,
                  height: 90,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      14.0,
                    ),
                    /*boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(
                          0,
                          3,
                        ), // changes position of shadow
                      ),
                    ],*/
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
                          child: (arr_swipe[i]['profile_picture'].toString() ==
                                  '')
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
                              : CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(
                                    //
                                    arr_swipe[i]['profile_picture'].toString(),
                                    //
                                  ),
                                ),
                          /*CircleAvatar(
                                  radius: 40,
                                  child: Image.network(
                                    //
                                    arr_swipe[i]['profile_picture'].toString(),
                                    //
                                    fit: BoxFit.cover,
                                    // height: 80,
                                    // width: 80,
                                  ),
                                ),*/
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
                                        arr_swipe[i]['address'].toString(),
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
                      )
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

  //
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
