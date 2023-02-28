// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cameroon_2/classes/nearby_friends/nearby_friends.dart';
import 'package:cameroon_2/classes/new_user_profile/new_user_profile.dart';
import 'package:cameroon_2/classes/profile_details/profile_details.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cameroon_2/classes/custom/drawer/drawer.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

class Dashboard2Screen extends StatefulWidget {
  const Dashboard2Screen({super.key});

  @override
  State<Dashboard2Screen> createState() => _Dashboard2ScreenState();
}

class _Dashboard2ScreenState extends State<Dashboard2Screen> {
  //
  var str_right_indicator = '0';
  var str_left_indicator = '0';
  //

  int index = 0;
  var arr_swipe = [];

  var str_slider_count = '0';

  var str_save_and_continue_loader = '0';

  @override
  void initState() {
    super.initState();

    func_position();
  }

//
  func_position() async {
    print('===> GET USER LOCATION <====');
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude.toString());
    print(position.longitude.toString());
    // print(position.altitude);

    func_get_all_users_near_you(
      position.latitude.toString(),
      position.longitude.toString(),
    );
  }

  //
  func_get_all_users_near_you(
    String str_lat,
    String str_long,
  ) async {
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
          'action': 'finduser',
          'userId': prefs.getInt('userId').toString(),
          'latitude': str_lat,
          'longitude': str_long,
          'interent_in': prefs.getString('interent_in').toString(),
        },
      ),
    );

    // convert data to dict
    var get_data = jsonDecode(resposne.body);
    // print(get_data);

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
        profile_details_WB();
        //
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
  //
  profile_details_WB() async {
    print('=====> POST : MY PROFILE LIST');

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
          'action': 'profile',
          'ownId': prefs.getInt('userId').toString(),
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

        print('object object object object ');
        print(get_data['data']['deviceToken'].toString());

        if (get_data['data']['deviceToken'].toString() == '') {
          //
          ///
          ///
          ///
          ///
          ///
          FirebaseMessaging.instance.getToken().then(
                (value) => {
                  // print("FCM Token Is: ============> newly"),
                  // print(
                  // value,
                  // ),
                  //
                  edit_profile_WB(
                    value,
                    prefs.getInt('userId').toString(),
                  ),
                  //
                },
              );

          ///
          ///
          ///
          ///
          ///
          ///
          ///
          //
        } else if (get_data['data']['deviceToken'].toString() == 'null') {
          //
          if (kDebugMode) {
            print('device token is null');
          }

          ///
          ///
          ///
          ///
          ///
          FirebaseMessaging.instance.getToken().then(
                (value) => {
                  // print("FCM Token Is: ============> newly"),
                  // print(
                  // value,
                  // ),
                  //
                  edit_profile_WB(
                    value,
                    prefs.getInt('userId').toString(),
                  ),
                  //
                },
              );

          ///
          ///
          ///
          ///
          ///
          ///
          ///

          //
        } else {
          if (arr_swipe.isEmpty) {
            setState(() {
              str_save_and_continue_loader = '2';
            });
          } else {
            setState(() {
              str_save_and_continue_loader = '1';
            });
          }
        }

        //
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
  //
  edit_profile_WB(device_token, user_id) async {
    //

    if (kDebugMode) {
      print('=====> POST : EDIT PROFILE');
      // print(prefs.getString('deviceToken'));
    }

    // var str_device_token = prefs.getString('deviceToken').toString();
    // print(str_device_token);

    // var str_d_t = '';
    // if (prefs.getString('deviceToken').toString() == 'null') {
    //   if (kDebugMode) {
    //     print('i am null');
    //   }
    // } else {
    //   if (kDebugMode) {
    //     print('i am null 2');
    //   }
    // }
    final resposne = await http.post(
      Uri.parse(
        application_base_url,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'editprofile',
          'userId': user_id,
          'deviceToken': device_token,
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
        if (kDebugMode) {
          // print(prefs.getString('deviceToken'));
        }
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

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          //
          text_matches,
          // locale: Locale.code,
          // print(window.locale.languageCode);
          // locale: Locale('fr'),
          //
          style: TextStyle(
            fontFamily: font_family_name,
          ),
        ),
        backgroundColor: bg_color,
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
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NearbyFriendsScreen(),
                ),
              );
              /*Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewUserProfile(),
                ),
              );*/
            },
            icon: const Icon(
              Icons.search,
            ),
          )
        ],
      ),
      drawer: const navigationDrawer(),
      body: (str_save_and_continue_loader == '0')
          ? const Align(
              child: CircularProgressIndicator(),
            )
          : (str_save_and_continue_loader == '2')
              ? Align(
                  child: Text(
                    'No data found',
                    style: TextStyle(
                      fontFamily: font_family_name,
                      fontSize: 16.0,
                    ),
                  ),
                )
              : Stack(
                  children: [
                    Container(
                      // height: 100,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        // color: Colors.transparent,
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
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/yellow_bg.png',
                          ),
                        ),
                      ),
                      child:
                          (arr_swipe[index]['profile_picture'].toString() == '')
                              ? Align(
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                  ),
                                )
                              : Center(
                                  child: Container(
                                    // margin: const EdgeInsets.all(10.0),
                                    color: Colors.amber[600],
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height,
                                    child: FadeInImage(
                                      image: NetworkImage(
                                        arr_swipe[index]['profile_picture']
                                            .toString(),
                                      ),
                                      fit: BoxFit.cover,
                                      placeholder: const AssetImage(
                                        'assets/images/image_loading.png',
                                      ),
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/images/avatar_1.png',
                                          fit: BoxFit.fitWidth,
                                        );
                                      },
                                    ),
                                    /*Image.network(
                                      arr_swipe[index]['profile_picture']
                                          .toString(),
                                      fit: BoxFit.fitHeight,
                                    ),*/
                                  ),
                                ),
                      /*FadeInImage(
                              image: NetworkImage(
                                arr_swipe[index]['profile_picture'].toString(),
                              ),
                              fit: BoxFit.fitHeight,
                              placeholder: const AssetImage(
                                  'assets/images/image_loading.png'),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/avatar_1.png',
                                  fit: BoxFit.fitWidth,
                                );
                              },
                            ),*/
                      /*Image.network(
                          //
                          arr_swipe[index]['profile_picture'].toString(),
                          //
                          fit: BoxFit.cover,
                        ),*/
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          // margin: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                'assets/images/black.png',
                              ),
                              fit: BoxFit.cover,
                              opacity: .6,
                            ),
                            color: Colors.transparent,
                            /*gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [
                      0.2,
                      0.4,
                      0.6,
                      0.8,
                    ],
                    colors: [
                      Color.fromARGB(255, 63, 57, 57),
                      Color.fromARGB(255, 63, 57, 57),
                      Color.fromARGB(255, 63, 57, 57),
                      Color.fromARGB(255, 63, 57, 57),
                      /*Color.fromARGB(26, 190, 182, 182),
                      Color.fromARGB(135, 200, 198, 198),
                      Color.fromARGB(187, 151, 149, 149),
                      Color.fromARGB(187, 127, 119, 119),
                      Color.fromARGB(187, 96, 90, 90),
                      Color.fromARGB(187, 75, 69, 69),
                      Color.fromARGB(187, 53, 46, 46),*/
                    ],
                  ),*/
                          ),
                          width: MediaQuery.of(context).size.width,
                          // height: 200,
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  top: 10,
                                ),
                                child: Text(
                                  //
                                  arr_swipe[index]['fullName'].toString(),
                                  // arr_swipe[index][_activePage]['gender'].toString(),
                                  //
                                  style: TextStyle(
                                    fontFamily: font_family_name,
                                    fontSize: 40,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              //

                              if (arr_swipe[index]['gender'].toString() == '1')
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 10,
                                  ),
                                  child: Text(
                                    '$text_male - ${userAge(
                                      DateTime.now(),
                                      DateTime(
                                        int.parse(arr_swipe[index]['dob']
                                            .toString()
                                            .split('-')[0]
                                            .toString()),
                                        int.parse(arr_swipe[index]['dob']
                                            .toString()
                                            .split('-')[1]
                                            .toString()),
                                        int.parse(arr_swipe[index]['dob']
                                            .toString()
                                            .split('-')[2]
                                            .toString()),
                                      ),
                                    )} $text_years_old',
                                    style: TextStyle(
                                      fontFamily: font_family_name,
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                )
                              else if (arr_swipe[index]['gender'].toString() ==
                                  '2')
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 10,
                                  ),
                                  child: Text(
                                    '$text_female - ${userAge(
                                      DateTime.now(),
                                      DateTime(
                                        int.parse(arr_swipe[index]['dob']
                                            .toString()
                                            .split('-')[0]
                                            .toString()),
                                        int.parse(arr_swipe[index]['dob']
                                            .toString()
                                            .split('-')[1]
                                            .toString()),
                                        int.parse(arr_swipe[index]['dob']
                                            .toString()
                                            .split('-')[2]
                                            .toString()),
                                      ),
                                    )} $text_years_old',
                                    style: TextStyle(
                                      fontFamily: font_family_name,
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                    top: 10,
                                  ),
                                  child: Text(
                                    'Prefer not to say - ${userAge(
                                      DateTime.now(),
                                      DateTime(
                                        int.parse(arr_swipe[index]['dob']
                                            .toString()
                                            .split('-')[0]
                                            .toString()),
                                        int.parse(arr_swipe[index]['dob']
                                            .toString()
                                            .split('-')[1]
                                            .toString()),
                                        int.parse(arr_swipe[index]['dob']
                                            .toString()
                                            .split('-')[2]
                                            .toString()),
                                      ),
                                    )} $text_years_old',
                                    style: TextStyle(
                                      fontFamily: font_family_name,
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              InkWell(
                                onTap: () {
                                  func_like_user_WB('2');
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(10.0),
                                  color: Colors.transparent,
                                  // width: 300,
                                  // height: 100 - 20,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        (str_left_indicator == '1')
                                            ? Container(
                                                margin:
                                                    const EdgeInsets.all(10.0),
                                                color: Colors.transparent,
                                                width: 80,
                                                height: 80,
                                                child:
                                                    const CircularProgressIndicator(
                                                  backgroundColor: Colors.pink,
                                                ),
                                              )
                                            : Container(
                                                margin:
                                                    const EdgeInsets.all(10.0),
                                                color: Colors.transparent,
                                                width: 80,
                                                height: 80,
                                                child: Image.asset(
                                                  'assets/images/left.png',
                                                ),
                                              ),
                                        Container(
                                          margin: const EdgeInsets.all(10.0),
                                          color: Colors.transparent,
                                          width: 70,
                                          height: 70,
                                          child: IconButton(
                                            onPressed: () {
                                              // print(arr_swipe);
                                              // print(index);
                                              // print(arr_swipe[index]);
                                              print(arr_swipe[index]['id']
                                                  .toString());
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ProfileDetailsScreen(
                                                    str_user_profile_id:
                                                        arr_swipe[index]['id']
                                                            .toString(),
                                                    str_profile_notification:
                                                        'no',
                                                    str_friend_device_token: '',
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.info,
                                              size: 50,
                                              color: Color.fromRGBO(
                                                230,
                                                230,
                                                230,
                                                1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            func_like_user_WB('1');

                                            /**/
                                          },
                                          child: (str_right_indicator == '1')
                                              ? Container(
                                                  margin: const EdgeInsets.all(
                                                      10.0),
                                                  color: Colors.transparent,
                                                  width: 80,
                                                  height: 80,
                                                  child:
                                                      const CircularProgressIndicator(
                                                    backgroundColor:
                                                        Colors.pink,
                                                  ),
                                                )
                                              : Container(
                                                  margin: const EdgeInsets.all(
                                                      10.0),
                                                  color: Colors.transparent,
                                                  width: 80,
                                                  height: 80,
                                                  child: Image.asset(
                                                    'assets/images/right.png',
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }

  //
  userAge(DateTime curruntDate, DateTime UsersBirthDate) {
    Duration parse = curruntDate.difference(UsersBirthDate).abs();
    return "${parse.inDays ~/ 360}"; // Years";
    // ${((parse.inDays % 360) ~/ 30)} Month ${(parse.inDays % 360) % 30} Days"
  }

  //
  /*action:like
  userId:
  likeId:
  status:  1/2 1=LIKE 2= DISLIKE*/
  //
  func_like_user_WB(
    String status,
  ) async {
    setState(() {
      if (status == '1') {
        str_right_indicator = '1';
      } else {
        str_left_indicator = '1';
      }
    });

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
          'action': 'like',
          'userId': prefs.getInt('userId').toString(),
          'likeId': arr_swipe[index]['id'].toString(),
          'status': status.toString(),
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
        func_move_to_next_partner();
        //
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

// right
  func_move_to_next_partner() {
    setState(() {
      str_right_indicator = '0';
      str_left_indicator = '0';
    });
    //
    if ((index + 1).toString() == arr_swipe.length.toString()) {
      print('equal');
    } else {
      setState(() {
        index += 1;
      });
    }
  }
}
