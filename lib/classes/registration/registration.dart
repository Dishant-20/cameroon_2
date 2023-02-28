// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cameroon_2/classes/complete_profile/complete_profile.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:cameroon_2/classes/registration/registration_modal.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
// import 'package:triple_r_custom/Utils.dart';
// import 'package:triple_r_custom/classes/registration/registration_modal.dart';

// import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //
  FirebaseAuth firebase_auth = FirebaseAuth.instance;
  //
  var loader_indicator = '0';
  //
  // name
  TextEditingController cont_txt_full_name = TextEditingController();
  // email
  TextEditingController cont_txt_email_address = TextEditingController();
  // password
  TextEditingController cont_txt_password = TextEditingController();
  //
  // Future<Registration_Modal>? _futureAlbum;
  Future<Album>? _futureAlbum;
  //

  final registration_service = RegistrationModel();
  //
  bool isLoading = false;
  //
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
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
        backgroundColor: const Color.fromRGBO(
          250,
          0,
          33,
          1,
        ),
      ),
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
              height: 300,
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
              height: 400,
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
                        text_create_an_account,
                        //
                        style: TextStyle(
                          fontFamily: font_family_name,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
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
                    // padding: const EdgeInsets.symmetric(
                    //   horizontal: 8,
                    //   vertical: 10,
                    // ),
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                      right: 10,
                    ),
                    child: TextFormField(
                      controller: cont_txt_full_name,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.person_2_outlined,
                          color: Colors.grey,
                          size: 26,
                        ),
                        border: const UnderlineInputBorder(),
                        labelText: text_full_name,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                      right: 10,
                    ),
                    /*padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),*/
                    child: TextFormField(
                      controller: cont_txt_email_address,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                          size: 26,
                        ),
                        border: const UnderlineInputBorder(),
                        labelText: text_email_address,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                      bottom: 10,
                      right: 10,
                    ),
                    /*padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 10),*/
                    child: TextFormField(
                      controller: cont_txt_password,
                      obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.lock_open,
                          color: Colors.grey,
                          size: 26,
                        ),
                        border: const UnderlineInputBorder(),
                        labelText: text_password,
                        prefixStyle: const TextStyle(
                          fontFamily: 'Avenir Next',
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      validation_before_login();
                      /*setState(
                        () {
                          isLoading = true;
                          registration_service
                              .create_user(
                                  cont_txt_full_name.text,
                                  cont_txt_email_address.text,
                                  cont_txt_password.text)
                              .then((value) {
                            print('dishant rajput fetched values');
                            print('Name : ${value.name}');
                            print(value.userId);
                            print("<==============================>");
                            print("<==============================>");

                            Navigator.pop(context);
                          });
                        },
                      );*/
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
                                //
                                text_sign_up,
                                //
                                style: const TextStyle(
                                  fontFamily: 'Avenir Next',
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
            Container(
              margin: const EdgeInsets.only(
                top: 710.0,
                left: 20.0,
                right: 20.0,
              ),
              width: MediaQuery.of(context).size.width,
              height: 30,
              color: Colors.transparent,
              child: Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    //
                    text_already_have_an_accont,
                    //
                    style: TextStyle(
                      fontFamily: font_family_name,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
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

  void showError(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error!"),
          content: Text(errorMessage),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // register here
  void doUserRegistration() async {
    //Sigup code here
    /*
    "action": 'cancelbooking',
          "userId": prefs.getInt('userId').toString(),
          "bookingId": '',
          */

    print('object');
    final response = await http.post(
        Uri.parse(
          application_base_url,
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: {
          // "flag": 1.toString(),
          /*
            action:registration
            fullName:
            email:
            contactNumber:
            password:
            role:Member
        */
          "fullname": cont_txt_full_name.text,
          "email": cont_txt_email_address.text,
          "contactNumber": '',
          "role": 'Member',
          "password": cont_txt_password.text,
          "fcm_token": "test_fcm_token"
        });

    final data = jsonDecode(response.body);
    print(data);
    // int value = data['value'];
    /*String message = data['message'];
    String emailAPI = data['email'];
    String nameAPI = data['name'];
    String id = data['id'];*/

    // if (value == 1) {
    //   setState(() {
    //     // _loginStatus = LoginStatus.signIn;
    //     // savePref(value, emailAPI, nameAPI, id);
    //   });
    //   print(message);
    //   // loginToast(message);
    // } else {
    //   print("fail");
    //   print(message);
    //   // loginToast(message);
    // }
  }

  validation_before_login() {
    if (cont_txt_email_address.text == '') {
      _showMyDialog('Email should not be empty.');
    } else if (cont_txt_password.text == '') {
      _showMyDialog('Password should not be empty.');
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        loader_indicator = '1';
      });
      registration_service
          .create_user(cont_txt_full_name.text, cont_txt_email_address.text,
              cont_txt_password.text)
          .then(
        (value) {
          // Album_Login(
          //   success_status: 'success_status',
          //   message: 'message',
          // );

          // print('SOMETHING WENT WRONG BUDDY');
          print(value.userId);
          if (value.userId == 'fails') {
            setState(() {
              loader_indicator = '0';
            });
            _showMyDialog(
              value.name.toString(),
            );
          } else {
            // func_validation();
            Navigator.pop(context);
            //
            /*Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>   CompleteProfileScreen(str_user_id: str_user_id),
              ),
            );*/
            //
          }
        },
      );
    }
  }

  func_validation() async {
    setState(() {
      // firebase_error_status = '0';
      // str_save_and_continue_loader = '1';
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: cont_txt_email_address.text.toString(),
              password: cont_txt_password.text.toString());
      if (kDebugMode) {
        print(userCredential.user);
      }

      await firebase_auth.currentUser!
          .updateDisplayName(
            cont_txt_full_name.text.toString(),
          )
          .then(
            (value) => {
              // print('success update name'),
              Navigator.pop(context),
            },
          );
    } on FirebaseAuthException catch (e) {
      /*if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {*/

      // setState(() {
      // firebase_error_status = '1';
      // str_save_and_continue_loader = '0';
      // firebase_error_status_text = e.code.toString();
      // });
      // }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _showMyDialog(
    String str_message,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Alert',
            style: TextStyle(
              fontFamily: font_family_name,
              fontSize: 16.0,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  str_message,
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
              child: const Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
