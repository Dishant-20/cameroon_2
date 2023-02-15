// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:triple_r_custom/Utils.dart';
// import 'package:triple_r_custom/custom_files/app_bar/appbar.dart';

class ChangePasswordWithOTP extends StatefulWidget {
  const ChangePasswordWithOTP({super.key, required this.str_email});

  final String str_email;

  @override
  State<ChangePasswordWithOTP> createState() => _ChangePasswordWithOTPState();
}

class _ChangePasswordWithOTPState extends State<ChangePasswordWithOTP> {
  //
  var loader_indicator = '0';
  //

  //
  // name
  TextEditingController cont_txt_OTP = TextEditingController();
  // email
  TextEditingController cont_txt_new_password = TextEditingController();
  // password
  TextEditingController cont_txt_confirm_password = TextEditingController();
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBarCustom(
          navigation_title: 'Change Password',
        ),
      ),*/
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Stack(
          children: <Widget>[
            Container(
              height: 500,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage(
                    // image name
                    'assets/images/login_back.png',
                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 20.0,
                left: 20.0,
                right: 20.0,
              ),
              height: 350,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.transparent,
                image: DecorationImage(
                  image: AssetImage(
                    // image name
                    'assets/images/logo.png',
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 360.0,
                left: 20.0,
                right: 20.0,
              ),
              height: 420,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    24,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                    ),
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Center(
                      child: Text(
                        //
                        '$text_create_new_password\n',
                        //
                        style: TextStyle(
                          fontFamily: font_family_name,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 10.0,
                      left: 20.0,
                      right: 20.0,
                    ),
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    // height: 40,
                    child: Center(
                      child: Text(
                        //
                        text_create_password_alert,
                        //
                        style: TextStyle(
                          fontFamily: font_family_name,
                          // fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   color: Colors.transparent,
                  //   width: MediaQuery.of(context).size.width,
                  //   height: 30,
                  //   child: const Center(
                  //     child: Text(
                  //       'Sign in to your account',
                  //       style: TextStyle(
                  //         fontFamily: 'Avenir Next',
                  //         fontSize: 16.0,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: TextFormField(
                      controller: cont_txt_OTP,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.password,
                          color: Colors.grey,
                        ),
                        border: const UnderlineInputBorder(),
                        labelText: text_enter_otp,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: TextFormField(
                      controller: cont_txt_new_password,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.password,
                          color: Colors.grey,
                        ),
                        border: const UnderlineInputBorder(),
                        labelText: text_new_password,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    child: TextFormField(
                      controller: cont_txt_confirm_password,
                      obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.lock_open_outlined,
                          color: Colors.grey,
                        ),
                        border: const UnderlineInputBorder(),
                        labelText: text_confirm_password,
                        prefixStyle: const TextStyle(
                          fontFamily: 'Avenir Next',
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        loader_indicator = '1';
                      });
                      update_password_WB();
                    },
                    child: (loader_indicator == '1')
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 1.5,
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(
                              left: 10.0,
                              right: 10.0,
                            ),
                            height: 54,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
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
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  20,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                text_update,
                                style: const TextStyle(
                                  fontFamily: 'Avenir Next',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                    /**/
                  ),
                ],
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.only(
            //     top: 710.0,
            //     left: 20.0,
            //     right: 20.0,
            //   ),
            //   width: MediaQuery.of(context).size.width,
            //   height: 30,
            //   color: Colors.transparent,
            //   child: Center(
            //     child: Text(
            //       '''Already have an account ? - Sign In''',
            //       style: TextStyle(
            //         fontFamily: font_family_name,
            //         fontSize: 16.0,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.only(
                top: 750.0,
                left: 20.0,
                right: 20.0,
              ),
              height: 50,
              color: Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  // get mission details
  update_password_WB() async {
    print('=====> POST : MISSION LIST');

    // setState(() {});

    // SharedPreferences prefs = await SharedPreferences.getInstance();

    final resposne = await http.post(
      Uri.parse(
        application_base_url,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'resetpassword',
          'email': widget.str_email.toString(),
          'OTP': cont_txt_OTP.text.toString(),
          'password': cont_txt_new_password.text.toString(),
        },
      ),
    );

    // convert data to dict
    var get_data = jsonDecode(resposne.body);
    // print(get_data);

    if (resposne.statusCode == 200) {
      if (get_data['status'].toString().toLowerCase() == 'success') {
        Navigator.of(context)
          ..pop()
          ..pop();
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
}
