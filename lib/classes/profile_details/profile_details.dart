// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'dart:ui';
import 'dart:convert';
import 'package:cameroon_2/classes/custom/appbar/custom_pop_up/custom_loader.dart';
import 'package:cameroon_2/classes/one_to_one_chat/one_to_one_chat.dart';
import 'package:cameroon_2/classes/video_call/video_call.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/material.dart';

import '../gallery/enlarge_image/enlarge_image.dart';

class ProfileDetailsScreen extends StatefulWidget {
  const ProfileDetailsScreen(
      {super.key,
      required this.str_user_profile_id,
      required this.str_profile_notification,
      required this.str_friend_device_token});

  final String str_friend_device_token;
  final String str_profile_notification;
  final String str_user_profile_id;

  @override
  State<ProfileDetailsScreen> createState() => _ProfileDetailsScreenState();
}

class _ProfileDetailsScreenState extends State<ProfileDetailsScreen> {
  //
  var str_login_user_id = '';
  //

  var custom_arr = [];
  List<String> arr_scroll_multiple_images = [];
  //
  var str_already_like = '0';
  //
  var str_user_profile_loader = '0';
  //
  var str_show_ui = '0';
  //
  var str_image_not_added = '0';
  var arr_image_count = [];
  //
  var str_image = '';
  var str_both_profile_matched = 'Yes';
  var str_name = '';
  var str_address = '';
  var str_gender = '';
  var str_education = '';
  var str_age = '';
  var str_interested_in = '';

  var str_device_token = '';
  //
  // late Timer myTimer;
  // Duration myDuration = Duration();
  //
  @override
  void initState() {
    super.initState();
    //
    profile_details_WB();
    print(window.locale.languageCode);
    //
    // startTimer();
    //
  }

  @override
  void dispose() {
    /*await agoraEngine.leaveChannel().then((value) => {
          Navigator.pop(context),
        });*/
    // await agoraEngine.leaveChannel();
    if (mounted) {}
    dispose();
    super.dispose();
  }

  //
  profile_details_WB() async {
    print('=====> POST : MY PROFILE LIST');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    str_login_user_id = prefs.getInt('userId').toString();

    final resposne = await http.post(
      Uri.parse(
        application_base_url,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      /*
      'action': 'viewprofile',
          'userId': str_login_user_id.toString(),
          'profileId': widget.str_user_profile_id.toString(),
      */
      body: jsonEncode(
        <String, String>{
          'action': 'profile',
          'ownId': str_login_user_id.toString(),
          'userId': widget.str_user_profile_id.toString(),
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
        arr_image_count.clear();
        //
        for (Map i in get_data['data']['totalImage']) {
          arr_image_count.add(i);
        }

        // print('dishant rajput');
        // print(arr_image_count);
        // print('dishant rajput');
        if (arr_image_count.isEmpty) {
          str_image_not_added = '0';
        } else {
          str_image_not_added = '1';
        }

//
        for (int i = 0; i < arr_image_count.length; i++) {
          arr_scroll_multiple_images.add(arr_image_count[i]['image']);
        }
        //
        str_image = get_data['data']['image'].toString();
        str_name = get_data['data']['fullName'].toString();
        str_gender = get_data['data']['gender'].toString();
        str_education = get_data['data']['education'].toString();
        str_age = get_data['data']['dob'].toString();
        str_address = get_data['data']['address'].toString();
        str_both_profile_matched = get_data['data']['bothLiked'].toString();

        str_device_token = get_data['data']['deviceToken'].toString();

        if (prefs.getString('interent_in').toString() == '1') {
          str_interested_in = 'Male';
        } else if (prefs.getString('interent_in').toString() == '2') {
          str_interested_in = 'Female';
        } else if (prefs.getString('interent_in').toString() == '3') {
          str_interested_in = 'Other';
        }

        if (str_both_profile_matched == 'No') {
          custom_arr = [
            {
              'question': text_location,
              'answer': 'Delhi',
            },
            {
              'question': text_interest_in,
              'answer': str_interested_in.toString(),
            },
            {
              'question': text_height,
              'answer': get_data['data']['height'].toString(),
            },
            {
              'question': text_education,
              'answer': get_data['data']['education'].toString(),
            },
            {
              'question': text_religion,
              'answer': get_data['data']['religion'].toString(),
            },
          ];
        } else {
          custom_arr = [
            {
              'question': text_contact_number,
              'answer': get_data['data']['contactNumber'].toString(),
            },
            {
              'question': text_location,
              'answer': 'Delhi',
            },
            {
              'question': text_interest_in,
              'answer': str_interested_in.toString(),
            },
            {
              'question': text_height,
              'answer': get_data['data']['height'].toString(),
            },
            {
              'question': text_education,
              'answer': get_data['data']['education'].toString(),
            },
            {
              'question': text_religion,
              'answer': get_data['data']['religion'].toString(),
            },
          ];
        }

        //
        setState(() {
          // print('i am last');
          // print(str_both_profile_matched);
          str_user_profile_loader = '1';
        });

        //
        // Navigator.pop(context);
        //
      } else {
        if (kDebugMode) {
          print(
            '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
          );
        }
      }
    } else {
      // return postList;
      if (kDebugMode) {
        print('something went wrong');
      }
    }
  }

  //
  func_like_this_profile_WB() {
    if (kDebugMode) {
      print('like');
    }

    //
    func_like_user_WB('1');
    //
  }

  //
  func_like_user_WB(
    String status,
  ) async {
    //
    setState(() {
      // print('yes like clicked');
      str_user_profile_loader = '0';
    });
    //

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
          'likeId': widget.str_user_profile_id.toString(),
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
        /*setState(() {
          str_user_profile_loader = '0';
        });*/
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          //
          text_user_profile,
          //
          style: TextStyle(
            fontFamily: font_family_name,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            if (kDebugMode) {
              print('');
            }
            Navigator.of(context).pop('');
          },
          icon: const Icon(
            Icons.chevron_left,
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
        actions: [
          /*IconButton(
            onPressed: () {
              if (kDebugMode) {
                print('heart click');
              }
              //
              func_like_this_profile_WB();
              //
            },
            icon: const Icon(
              Icons.favorite_border,
            ),
          ),*/
          (widget.str_profile_notification == 'no')
              ? const SizedBox()
              : (str_both_profile_matched == 'Yes')
                  ? const SizedBox()
                  : IconButton(
                      onPressed: () {
                        if (kDebugMode) {
                          print('heart click');
                        }
                        //
                        func_like_this_profile_WB();
                        //
                      },
                      icon: const Icon(
                        Icons.favorite_border,
                      ),
                    ),
        ],
      ),
      // drawer: ProfileDetailsScreen,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: (str_user_profile_loader == '0')
            ? const CustomeLoaderPopUp(
                str_custom_loader: 'please wait...',
                str_status: '3',
              )
            : Column(
                children: [
                  Container(
                    height: 360,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.pinkAccent,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          // margin: const EdgeInsets.all(10.0),
                          color: Colors.amber[600],
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          child: const Image(
                            image: AssetImage(
                              'assets/images/back.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        //
                        //
                        Container(
                          margin: const EdgeInsets.only(
                            left: 60,
                            top: 110,
                            right: 60,
                          ),
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(
                              250,
                              210,
                              10,
                              1,
                            ),
                            borderRadius: BorderRadius.circular(
                              14,
                            ),
                          ),
                          child: Center(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: <Widget>[
                                Text(
                                  //
                                  str_education.toString(),
                                  //
                                  style: TextStyle(
                                    fontFamily: font_family_name,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: Row(
                            children: <Widget>[
                              // 28 204 216
                              (str_both_profile_matched == 'No')
                                  ? const SizedBox(
                                      height: 0,
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(
                                        left: 20,
                                        top: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            28, 204, 216, 1),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          if (kDebugMode) {
                                            print('');
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OneToOneChatScreen(
                                                str_get_friend_id: widget
                                                    .str_user_profile_id
                                                    .toString(),
                                                str_get_login_user_id:
                                                    str_login_user_id
                                                        .toString(),
                                                str_get_friend_name:
                                                    str_name.toString(),
                                                str_get_friend_image:
                                                    str_image.toString(),
                                                str_get_friend_device_token:
                                                    widget
                                                        .str_friend_device_token
                                                        .toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.chat,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                              //
                              Expanded(
                                child: Align(
                                  child: Text(
                                    //
                                    str_name.toString(),
                                    //
                                    style: TextStyle(
                                      fontFamily: font_family_name,
                                      fontSize: 26.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              //
                              (str_both_profile_matched == 'No')
                                  ? const SizedBox(
                                      height: 0,
                                    )
                                  : Container(
                                      margin: const EdgeInsets.only(
                                        right: 20,
                                        top: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            const Color.fromRGBO(236, 4, 66, 1),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          if (kDebugMode) {
                                            print('');
                                          }
                                          // 'ownId': str_login_user_id.toString(),
                                          // 'userId': widget.str_user_profile_id.toString(),
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  VideoCallScreen(
                                                str_from_notification: 'no',
                                                str_channel_name:
                                                    '$str_login_user_id+${widget.str_user_profile_id}',
                                                str_friend_device_token:
                                                    str_device_token.toString(),
                                                // str_friend_device_token
                                              ),
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.video_call,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        //
                        Container(
                          margin: const EdgeInsets.only(top: 60),
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: Center(
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: <Widget>[
                                const Icon(
                                  Icons.pin_drop,
                                  color: Colors.white,
                                ),
                                text_with_bold_style(
                                  str_address.toString(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //

                        // Container(
                        //   margin: EdgeInsets.only(top: ),
                        //   height: 60,
                        //   width: MediaQuery.of(context).size.width,
                        //   color: Colors.amber,
                        //   child: Row(
                        //     children: <Widget>[
                        //       IconButton(
                        //         onPressed: () {
                        //           if (kDebugMode) {
                        //             print('');
                        //           }
                        //         },
                        //         icon: const Icon(
                        //           Icons.chat,
                        //         ),
                        //       ),
                        //       //
                        //       Expanded(
                        //         child: Align(
                        //           child: Text(
                        //             'Dishant rajput',
                        //             style: TextStyle(
                        //               fontFamily: font_family_name,
                        //               fontSize: 18.0,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       //
                        //       IconButton(
                        //         onPressed: () {
                        //           print('');
                        //         },
                        //         icon: Icon(
                        //           Icons.chat,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        //
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            // margin: const EdgeInsets.all(10.0),
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                            top: 170,
                            right: 10,
                          ),
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          height: 140,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, top: 30.0),
                                color: Colors.transparent,
                                width: 60,
                                height: 100,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      // margin: const EdgeInsets.all(10.0),

                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(
                                            34, 182, 34, 1),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                      ),
                                      child: Align(
                                        child: Text(
                                          //
                                          arr_image_count.length.toString(),
                                          //
                                          style: TextStyle(
                                            fontFamily: font_family_name,
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    //
                                    Text(
                                      //
                                      text_photos,
                                      //
                                      style: TextStyle(
                                        fontFamily: font_family_name,
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    60,
                                  ),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 5,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(
                                    //
                                    str_image.toString(),
                                    //
                                  ),
                                ),
                              ),
                              //
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, top: 30.0),
                                color: Colors.transparent,
                                width: 60,
                                height: 100,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      // margin: const EdgeInsets.all(10.0),

                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color:
                                            const Color.fromRGBO(170, 0, 20, 1),
                                        borderRadius: BorderRadius.circular(
                                          30,
                                        ),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        ),
                                      ),
                                      child: Align(
                                        child: Text(
                                          userAge(
                                            DateTime.now(),
                                            DateTime(
                                              int.parse(str_age
                                                  .split('-')[0]
                                                  .toString()),
                                              int.parse(str_age
                                                  .split('-')[1]
                                                  .toString()),
                                              int.parse(str_age
                                                  .split('-')[2]
                                                  .toString()),
                                            ),
                                          ),
                                          style: TextStyle(
                                            fontFamily: font_family_name,
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    //
                                    Text(
                                      //
                                      text_age,
                                      //
                                      style: TextStyle(
                                        fontFamily: font_family_name,
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*Column(
                    children: [
                      // Center(
                      //   child: Container(
                      //     margin: const EdgeInsets.all(10.0),
                      //     color: Colors.amber[600],
                      //     width: 48.0,
                      //     height: 48.0,
                      //   ),
                      // ),
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                          image: DecorationImage(
                            image: ExactAssetImage('assets/images/back.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          // height: 160,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: [
                                  (str_both_profile_matched == 'No')
                                      ? const SizedBox(
                                          height: 0,
                                        )
                                      : Container(
                                          margin: const EdgeInsets.only(
                                              left: 20, top: 20),
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                  28, 205, 214, 1),
                                              borderRadius:
                                                  BorderRadius.circular(40)),
                                          child: IconButton(
                                            onPressed: () {
                                              print('click on chat');

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OneToOneChatScreen(
                                                    str_get_friend_id: widget
                                                        .str_user_profile_id
                                                        .toString(),
                                                    str_get_login_user_id:
                                                        str_login_user_id
                                                            .toString(),
                                                    str_get_friend_name:
                                                        str_name.toString(),
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.chat,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                  Expanded(
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      color: Colors.transparent,
                                      child: Align(
                                        child: Text(
                                          //
                                          str_name.toString(),
                                          //
                                          style: TextStyle(
                                            fontFamily: font_family_name,
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //
                                  (str_both_profile_matched == 'No')
                                      ? const SizedBox(
                                          height: 0,
                                        )
                                      : Container(
                                          height: 60,
                                          width: 60,
                                          margin: const EdgeInsets.only(
                                              right: 20, top: 20),
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                235, 6, 66, 1),
                                            borderRadius: BorderRadius.circular(
                                              40,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              print('click on video');
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const VideoCallScreen(),
                                                ),
                                              );
                                            },
                                            icon: const Icon(
                                              Icons.video_call,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  // height: 70,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.transparent,
                                  child: Container(
                                    color: Colors.transparent,
                                    width: MediaQuery.of(context).size.width,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child:
                                            //  (str_gender == 'Male')
                                            // ?
                                            Row(
                                          children: <Widget>[
                                            const Expanded(child: Text(' ')),
                                            const Icon(
                                              Icons.pin_drop,
                                              color: Colors.yellow,
                                            ),
                                            Text(
                                              //
                                              str_address.toString(),
                                              //
                                              style: TextStyle(
                                                fontFamily: font_family_name,
                                                fontSize: 16.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const Expanded(child: Text('')),
                                          ],
                                        )
                                        /*: Row(
                                            children: <Widget>[
                                              const Expanded(child: Text('')),
                                              const Icon(
                                                Icons.female,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                " Female",
                                                style: TextStyle(
                                                  fontFamily: font_family_name,
                                                  fontSize: 16.0,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const Expanded(child: Text('')),
                                            ],
                                          ),*/
                                        ),
                                  ),
                                ),
                              ),
                              Container(
                                // height: 70,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.transparent,
                                child: Align(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            // height: 40,
                                            // width: 120,

                                            decoration: BoxDecoration(
                                              color: Colors.amber,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                12.0,
                                              ),
                                            ),
                                            child: Align(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  //
                                                  str_education.toString(),
                                                  //
                                                  style: TextStyle(
                                                    fontFamily:
                                                        font_family_name,
                                                    fontSize: 16.0,
                                                    // fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  margin: const EdgeInsets.all(10.0),
                                  color: Colors.transparent,
                                  width: MediaQuery.of(context).size.width,
                                  height: 120,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 120,
                                            ), // This container is needed only to set the overall stack height
                                            // for Text to be a bit below Circleavatar
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              height: 70.0,
                                              width: 70.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                color: const Color.fromRGBO(
                                                    34, 182, 34, 1),
                                                border: Border.all(
                                                  width: 4,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  //
                                                  arr_image_count.length
                                                      .toString(),
                                                  //
                                                  style: TextStyle(
                                                    fontFamily:
                                                        font_family_name,
                                                    fontSize: 18.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: -10,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(0),
                                                  color: Colors.white,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    'Photos',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          font_family_name,
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          // margin: const EdgeInsets.all(10.0),
                                          color: Colors.transparent,
                                          // width: 48.0,
                                          // height: 48.0,
                                          child: Container(
                                            // height: 80,
                                            // width: 80,
                                            color: Colors.transparent,
                                            child: (str_image.toString() == '')
                                                ? Container(
                                                    // color: Colors.amber,
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        50,
                                                      ),
                                                    ),
                                                    child: Align(
                                                      child: Text(
                                                        func_get_initials(
                                                          str_name.toString(),
                                                        ),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              font_family_name,
                                                          fontSize: 40,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                      //
                                                      str_image.toString(),
                                                      //       //
                                                    ),
                                                    radius: 80,
                                                  ),
                                            // Padding(
                                            //     padding:
                                            //         const EdgeInsets.all(0),
                                            //     child: Image.network(
                                            //       //
                                            //       str_image.toString(),
                                            //       //
                                            //       fit: BoxFit.cover,
                                            //       height: 80,
                                            //       width: 80,
                                            //     ),
                                            //   ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 75,
                                            ), // This container is needed only to set the overall stack height
                                            // for Text to be a bit below Circleavatar
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                              ),
                                              height: 70.0,
                                              width: 70.0,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                color: const Color.fromRGBO(
                                                    170, 0, 20, 1),
                                                border: Border.all(
                                                  width: 4,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  userAge(
                                                    DateTime.now(),
                                                    DateTime(
                                                      int.parse(str_age
                                                          .split('-')[0]
                                                          .toString()),
                                                      int.parse(str_age
                                                          .split('-')[1]
                                                          .toString()),
                                                      int.parse(str_age
                                                          .split('-')[2]
                                                          .toString()),
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        font_family_name,
                                                    fontSize: 16.0,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(35),
                                                  color: Colors.white,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Text(
                                                    'Age',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          font_family_name,
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),*/
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                  ),
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                          onPressed: (() {
                            print('gallery click');
                            str_show_ui = '0';
                            setState(() {});
                          }),
                          icon: Icon(Icons.file_copy,
                              color: (str_show_ui == '1')
                                  ? Colors.black
                                  : Colors.purple),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: (() {
                            print('details click');
                            str_show_ui = '1';
                            setState(() {});
                          }),
                          icon: Icon(
                            Icons.photo_camera_back_rounded,
                            color: (str_show_ui == '0')
                                ? Colors.black
                                : Colors.purple,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                  ),
                  (str_show_ui == '1')
                      ? (str_image_not_added == '0')
                          ? Text(
                              'no image found',
                              style: TextStyle(
                                fontFamily: font_family_name,
                                fontSize: 16.0,
                              ),
                            )
                          : GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                                // mainAxisExtent: 200,
                                // childAspectRatio: 500,
                              ),
                              itemCount: arr_image_count.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  // var stringList = list.join("");
                                  child: InkWell(
                                    onTap: () {
                                      // print(custom_arr);

                                      CustomImageProvider customImageProvider =
                                          CustomImageProvider(
                                              imageUrls:
                                                  arr_scroll_multiple_images
                                                      .toList(),
                                              initialIndex: index);
                                      showImageViewerPager(
                                          context, customImageProvider,
                                          doubleTapZoomable: true,
                                          onPageChanged: (page) {
                                        // print("Page changed to $page");
                                      }, onViewerDismissed: (page) {
                                        // print("Dismissed while on page $page");
                                      });
                                    },
                                    child: Container(
                                      // height: MediaQuery.of(context).size.height,
                                      // height: 40,
                                      color: Colors.white,
                                      child: Image.network(
                                        arr_image_count[index]['image']
                                            .toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                      : details_UI(context),
                ],

                //
              ),
      ),
    );
  }

  SingleChildScrollView details_UI(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          for (int i = 0; i < custom_arr.length; i++) ...[
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: RichText(
                  text: TextSpan(
                    //
                    text: custom_arr[i]['question'].toString(),
                    //
                    style: TextStyle(
                      fontFamily: font_family_name,
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      const TextSpan(
                        text: '\n',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: //
                            custom_arr[i]['answer'].toString(),
                        //
                        style: TextStyle(
                          fontFamily: font_family_name,
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
            ),
          ],
        ],
      ),
    );
  }

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
  userAge(DateTime curruntDate, DateTime UsersBirthDate) {
    Duration parse = curruntDate.difference(UsersBirthDate).abs();
    return "${parse.inDays ~/ 360}"; // Years";
    // ${((parse.inDays % 360) ~/ 30)} Month ${(parse.inDays % 360) % 30} Days"
  }
  //
}
