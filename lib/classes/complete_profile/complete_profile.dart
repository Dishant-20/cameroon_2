// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:cameroon_2/classes/dashboard/dashboard2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cameroon_2/classes/custom/appbar/custom_pop_up/custom_loader.dart';
import 'package:cameroon_2/classes/dashboard/dashboard.dart';

import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key, required this.str_from_edit});

  final String str_from_edit;

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  var str_login_user_id = '';
  var str_interest_in = '1';
  // IMAGE
  File? imageFile_for_profile;
  var str_set_image_URL = '';
  var str_user_select_image = '0';
  //
  var str_gender;
  var arr_region = [];
  var arr_region_zone = [];
  var str_region_id = '';
  var str_region_zone_id = '';
  //
  var str_latitude = '';
  var str_longitude = '';
  //
  var str_save_and_continue_loader = '0';
  //
  final _formKey = GlobalKey<FormState>();
  //
  late final TextEditingController cont_gender;
  late final TextEditingController cont_age;
  late final TextEditingController cont_interested_in;
  late final TextEditingController cont_height;
  late final TextEditingController cont_religion;
  late final TextEditingController cont_education;
  late final TextEditingController cont_region_zone;
  late final TextEditingController cont_region;
  //
  @override
  void initState() {
    super.initState();
    //

    //
    if (widget.str_from_edit == 'yes') {
      cont_gender = TextEditingController(text: text_please_wait);
      cont_age = TextEditingController(text: text_please_wait);
      cont_interested_in = TextEditingController(text: text_please_wait);
      cont_height = TextEditingController(text: text_please_wait);
      cont_religion = TextEditingController(text: text_please_wait);
      cont_education = TextEditingController(text: text_please_wait);
      cont_region_zone = TextEditingController(text: text_please_wait);
      cont_region = TextEditingController(text: text_please_wait);
    } else {
      cont_gender = TextEditingController();
      cont_age = TextEditingController();
      cont_interested_in = TextEditingController();
      cont_height = TextEditingController();
      cont_religion = TextEditingController();
      cont_education = TextEditingController();
      cont_region_zone = TextEditingController();
      cont_region = TextEditingController();
    }

    func_position();
    func_get_login_user_data();
  }

// fir location
  func_position() async {
    print('===> GET USER LOCATION <====');
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.latitude.toString());
    print(position.longitude.toString());
    // print(position.altitude);

    str_latitude = position.latitude.toString();
    str_longitude = position.longitude.toString();

    // func_get_all_users_near_you(
    //   position.latitude.toString(),
    //   position.longitude.toString(),
    // );
  }

  func_get_login_user_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    str_login_user_id = prefs.getInt('userId').toString();

    if (widget.str_from_edit == 'yes') {
      profile_details_WB();
    } else {
      func_get_region_data();
    }
  }

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
          'userId': prefs.getInt('userId').toString(),
          'ownId': prefs.getInt('userId').toString(),
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
        // cont_gender.text = get_data['data']['gender'].toString();
        cont_age.text = get_data['data']['dob'].toString();

        if (get_data['data']['gender'].toString() == '1') {
          str_gender = '1';
          cont_gender.text = 'Male';
        } else if (get_data['data']['gender'].toString() == '2') {
          str_gender = '2';
          cont_gender.text = 'Female';
          str_gender = '2';
        } else if (get_data['data']['gender'].toString() == '3') {
          str_gender = '3';
          cont_gender.text = 'Prefer not to say';
        }

        if (get_data['data']['interent_in'].toString() == '1') {
          cont_interested_in.text = 'Male';
        } else if (get_data['data']['interent_in'].toString() == '2') {
          cont_interested_in.text = 'Female';
        } else if (get_data['data']['interent_in'].toString() == '3') {
          cont_interested_in.text = 'Other';
        }

        cont_height.text = get_data['data']['height'].toString();
        cont_religion.text = get_data['data']['religion'].toString();
        cont_education.text = get_data['data']['education'].toString();
        cont_region_zone.text = text_please_wait;
        cont_region.text = text_please_wait;

        str_region_id = get_data['data']['regionId'].toString();
        str_region_zone_id = get_data['data']['zone'].toString();

        // print('========> get image');
        // print(get_data['data']['image'].toString());

        if (get_data['data']['image'].toString() != '') {
          setState(() {
            imageFile_for_profile =
                (File(get_data['data']['image'].toString()));
            str_set_image_URL = get_data['data']['image'].toString();
          });
        }
        //
        print(imageFile_for_profile);
        func_get_region_data();
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

  func_get_region_data() async {
    print('=====> POST : REGION LIST');

    final resposne = await http.post(
      Uri.parse(
        application_base_url,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'region',
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
        for (Map i in get_data['data']) {
          arr_region.add(i);
        }

        if (widget.str_from_edit == 'yes') {
          // print('hello');
          //
          for (int i = 0; i < arr_region.length; i++) {
            if (str_region_id == arr_region[i]['id'].toString()) {
              cont_region.text = arr_region[i]['name'].toString();
              //
              for (int j = 0; j < arr_region[i]['ZONE'].length; j++) {
                if ((arr_region[i]['ZONE'][j]['id'].toString()) ==
                    str_region_zone_id.toString()) {
                  cont_region_zone.text =
                      arr_region[i]['ZONE'][j]['name'].toString();
                }
              }
            }

            // print('object');
          }
          setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: (widget.str_from_edit == 'yes')
          ? AppBar(
              automaticallyImplyLeading: true,
              title: Text(
                //
                text_complete_profile,
                //
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
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.chevron_left,
                ),
              ),
            )
          : AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'Complete profile',
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
      // backgroundColor:
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
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Center(
                  child: InkWell(
                    onTap: () {
                      camera_gallery_for_profile(context);
                    },
                    child: imageFile_for_profile == null
                        ? Center(
                            child: Container(
                              margin: const EdgeInsets.all(10.0),
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  12.0,
                                ),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                        : (str_set_image_URL != '') // parse server URL
                            ? Center(
                                child: Container(
                                  margin: const EdgeInsets.all(10.0),
                                  color: Colors.amber[600],
                                  width: 120,
                                  height: 120,
                                  child: Image.network(
                                    str_set_image_URL.toString(),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.all(10.0),
                                color: Colors.amber[600],
                                width: 120,
                                height: 120,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.file(
                                    fit: BoxFit.cover,
                                    //
                                    imageFile_for_profile!,
                                    //
                                    height: 150.0,
                                    width: 100.0,
                                  ),
                                ),
                              ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(
                    10.0,
                  ),
                  child: TextFormField(
                    readOnly: true,
                    onTap: () {
                      if (kDebugMode) {
                        print('gender click');
                      }
                      open_gender_in(context);
                    },
                    controller: cont_gender,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      // labelText: 'Gender',
                      hintText: text_gender,
                      suffixIcon: const Icon(
                        Icons.arrow_drop_down,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Gender';
                      }
                      return null;
                    },
                  ),
                ),
                //
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: TextFormField(
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(), //get today's date
                          firstDate: DateTime(1960),
                          lastDate: DateTime(2101));

                      if (pickedDate != null) {
                        print(pickedDate);
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(formattedDate);

                        setState(() {
                          cont_age.text =
                              formattedDate; //set foratted date to TextField value.
                        });
                      } else {
                        print("Date is not selected");
                      }
                    },
                    controller: cont_age,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: Icon(
                        Icons.calendar_month,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      hintText: 'Age',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Age';
                      }
                      return null;
                    },
                  ),
                ),
                //
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                  ),
                  child: TextFormField(
                    readOnly: true,
                    onTap: () {
                      if (kDebugMode) {
                        print('intereset in click');
                      }
                      open_interest_in(context);
                    },
                    controller: cont_interested_in,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      hintText: 'Interest in',
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Interest In';
                      }
                      return null;
                    },
                  ),
                ),
                //
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                  ),
                  child: TextFormField(
                    readOnly: false,
                    onTap: () {
                      if (kDebugMode) {
                        print('height click');
                      }
                    },
                    controller: cont_height,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      hintText: 'Height',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Height';
                      }
                      return null;
                    },
                  ),
                ),
                //
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                  ),
                  child: TextFormField(
                    readOnly: false,
                    onTap: () {
                      if (kDebugMode) {
                        print('religion click');
                      }
                      open_religion(context);
                    },
                    controller: cont_religion,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      hintText: 'Religion',
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Religion';
                      }
                      return null;
                    },
                  ),
                ),
                //
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                  ),
                  child: TextFormField(
                    readOnly: false,
                    onTap: () {
                      if (kDebugMode) {
                        print('education click');
                      }
                    },
                    controller: cont_education,
                    decoration: const InputDecoration(
                      // disabledBorder: true,
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      // labelText: 'Education',
                      hintText: 'Education',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Education';
                      }
                      return null;
                    },
                  ),
                ),
                //
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                  ),
                  child: TextFormField(
                    readOnly: true,
                    onTap: () {
                      if (kDebugMode) {
                        print('region click');
                      }
                      open_region(context);
                    },
                    controller: cont_region,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      hintText: 'Region',
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Region';
                      }
                      return null;
                    },
                  ),
                ),
                //
                Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 8,
                  ),
                  child: TextFormField(
                    readOnly: true,
                    onTap: () {
                      if (kDebugMode) {
                        print('region zone click');
                      }
                      open_region_zone(context);
                    },
                    controller: cont_region_zone,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      hintText: 'Region zone',
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Region Zone';
                      }
                      return null;
                    },
                  ),
                ),
                //

                //
                (str_save_and_continue_loader == '1')
                    ? CustomeLoaderPopUp(
                        str_custom_loader: text_please_wait,
                        str_status: '3',
                      )
                    : InkWell(
                        onTap: () {
                          //
                          if (_formKey.currentState!.validate()) {
                            if (kDebugMode) {
                              print('value all fill now');
                            }
                            //
                            func_complete_all_profile();
                            //
                          }
                          //
                        },
                        child: Container(
                          margin: const EdgeInsets.all(
                            10.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              30.0,
                            ),
                            color: Colors.amber,
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
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              //
                              text_save_and_continue,
                              //
                              // 'Save and Continue',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
  // str_login_user_id
  func_complete_all_profile() async {
    // print('object');

    setState(() {
      str_save_and_continue_loader = '1';
    });

    // if (widget.str_from_edit == 'yes') {
    //   func_edit_complete_profile_data();
    // } else {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
          'action': 'editprofile',
          'userId': prefs.getInt('userId').toString(),
          'gender': str_gender.toString(),
          'height': cont_height.text.toString(),
          'dob': cont_age.text.toString(),
          // 'address': 'address',
          'zipCode': 'zipcode',
          'interent_in': str_interest_in.toString(),
          'religion': cont_religion.text.toString(),
          'education': cont_education.text.toString(),
          'zone': str_region_zone_id.toString(),
          'regionId': str_region_id.toString(),
          'latitude': str_latitude.toString(),
          'longitude': str_longitude.toString(),
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
        Map<String, dynamic> user = get_data['data'];
        await prefs.setInt('userId', user['userId']);
        await prefs.setString('fullName', user['fullName']);
        await prefs.setString('email', user['email']);
        await prefs.setString('role', user['role']);

        await prefs.setString('gender', user['gender']);
        await prefs.setString('dob', user['dob']);
        await prefs.setString('interent_in', user['interent_in'].toString());
        await prefs.setString('religion', user['religion']);
        await prefs.setString('height', user['height']);
        await prefs.setString('education', user['education']);
        await prefs.setString('zone', user['zone'].toString());
        await prefs.setString('regionId', user['regionId'].toString());
        if (str_user_select_image == '0') {
          if (widget.str_from_edit == 'yes') {
            Navigator.pop(context);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Dashboard2Screen(),
              ),
            );
          }
        } else {
          // upload image
          upload_image_to_server();
        }

        // Navigator.pop(context);
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
    // }
  }

  upload_image_to_server() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request =
        await http.MultipartRequest('POST', Uri.parse(application_base_url));

    request.fields['action'] = 'editprofile';
    request.fields['userId'] = prefs.getInt('userId').toString();

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile_for_profile!.path,
      ),
    );

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);
    // print(responsedData);

    if (responsedData['status'].toString().toLowerCase() == 'success') {
      //
      Map<String, dynamic> user = responsedData['data'];
      await prefs.setInt('userId', user['userId']);
      await prefs.setString('fullName', user['fullName']);
      await prefs.setString('email', user['email']);
      await prefs.setString('role', user['role']);

      await prefs.setString('gender', user['gender']);
      await prefs.setString('dob', user['dob']);
      await prefs.setString('interent_in', user['interent_in'].toString());
      await prefs.setString('religion', user['religion']);
      await prefs.setString('height', user['height']);
      await prefs.setString('education', user['education']);
      await prefs.setString('zone', user['zone'].toString());
      await prefs.setString('regionId', user['regionId'].toString());
      setState(() {
        str_save_and_continue_loader = '0';
      });
      //
      //
      if (widget.str_from_edit == 'yes') {
        Navigator.pop(context);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard2Screen(),
          ),
        );
      }
    }
  }

  void camera_gallery_for_profile(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Camera option'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              // ignore: deprecated_member_use
              PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.camera,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              if (pickedFile != null) {
                setState(() {
                  str_set_image_URL = '';
                  str_user_select_image = '1';
                  imageFile_for_profile = File(pickedFile.path);
                });
              }
            },
            child: Text(
              'Open Camera',
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              // ignore: deprecated_member_use
              PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.gallery,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              if (pickedFile != null) {
                print('==> RELOAD TO PARSE IMAGE <==');

                setState(() {
                  str_set_image_URL = '';
                  str_user_select_image = '1';
                  imageFile_for_profile = File(pickedFile.path);
                });
              }
            },
            child: Text(
              'Open Gallery',
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Dismiss',
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //
  void open_interest_in(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Camera option'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              str_interest_in = '1';
              cont_interested_in.text = 'Male';
            },
            child: Text(
              //
              text_male,
              //
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              str_interest_in = '2';
              cont_interested_in.text = 'Female';
              // ignore: deprecated_member_use
            },
            child: Text(
              //
              text_female,
              //
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
          //
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              str_interest_in = '3';
              cont_interested_in.text = 'Other';
            },
            child: Text(
              //
              text_other,
              //
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              //
              text_dismiss,
              //
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //
  //
  void open_gender_in(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          text_gender,
        ),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              str_gender = '1';
              cont_gender.text = 'Male';
            },
            child: Text(
              //
              text_male,
              //
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              str_gender = '2';
              cont_gender.text = 'Female';
              // ignore: deprecated_member_use
            },
            child: Text(
              //
              text_female,
              //
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
          //
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              str_gender = '3';
              cont_gender.text = 'Prefer not to say';
            },
            child: Text(
              //
              text_prefer_not_to_say,
              //
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              //
              text_dismiss,
              //
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //
  void open_religion(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          text_religion,
        ),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              cont_religion.text = 'Catholic';
            },
            child: Text(
              //
              text_chatholic,
              //
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              cont_religion.text = 'Christianity';
              // ignore: deprecated_member_use
            },
            child: Text(
              //
              text_christianity,
              //
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
          //
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              cont_religion.text = 'Protestants';
            },
            child: Text(
              //
              text_protestants,
              //
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              cont_religion.text = 'Mormons';
            },
            child: Text(
              //
              text_mormons,
              //
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              //
              text_dismiss,
              //
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //
  //
  void open_region_zone(BuildContext context) {
    // print(str_region_id);
    arr_region_zone.clear();
    for (int d = 0; d < arr_region.length; d++) {
      if (arr_region[d]['id'].toString() == str_region_id) {
        // print('yes');
        // print(arr_region[i]);
        // print(arr_region[i]);

        for (Map j in arr_region[d]['ZONE']) {
          // print(j);
          arr_region_zone.add(j);
        }

        // for (int i = 0; i < arr_region.length; i++) {
        //   arr_region_zone.add(arr_region[i]['ZONE']);
        // }
      }
    }
    print('object');
    print(arr_region_zone);

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Region Zone'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          for (int i = 0; i < arr_region_zone.length; i++) ...[
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);

                str_region_zone_id = arr_region_zone[i]['id'].toString();
                cont_region_zone.text = arr_region_zone[i]['name'].toString();
                setState(() {});
              },
              child: Text(
                //
                arr_region_zone[i]['name'].toString(),
                //
                style: TextStyle(
                  fontFamily: font_family_name,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Dismiss',
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //
  void open_region(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Region'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          for (int i = 0; i < arr_region.length; i++) ...[
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);

                setState(() {
                  str_region_id = arr_region[i]['id'].toString();
                  cont_region.text = arr_region[i]['name'].toString();
                  cont_region_zone.text = '';
                });
              },
              child: Text(
                //
                arr_region[i]['name'].toString(),
                //
                style: TextStyle(
                  fontFamily: font_family_name,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Dismiss',
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //
}
