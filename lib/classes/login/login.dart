// ignore_for_file: non_constant_identifier_names, unused_local_variable, use_build_context_synchronously

import 'package:cameroon_2/classes/complete_profile/complete_profile.dart';
// import 'package:cameroon_2/classes/dashboard/dashboard.dart';
import 'package:cameroon_2/classes/dashboard/dashboard2.dart';
import 'package:cameroon_2/classes/forgot_password/forgot_password.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:cameroon_2/classes/login/login_modal.dart';
import 'package:cameroon_2/classes/registration/registration.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:triple_r_custom/Utils.dart';
// import 'package:triple_r_custom/classes/dashboard/dashboard.dart';
// import 'package:triple_r_custom/classes/forgot_password/forgot_password.dart';
// import 'package:triple_r_custom/classes/login/login_modal.dart';
// import 'package:triple_r_custom/classes/registration/registration.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  var loader_indicator = '0';
  //
  // email
  TextEditingController cont_txt_email_address = TextEditingController();
  // password
  TextEditingController cont_txt_password = TextEditingController();
  //
  final login_api_call = LoginModal();

//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          //
          text_login,
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
        // automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: 0,
          ),
          onPressed: () {
            // Navigator.pop(context, 'back');
          },
        ),
        backgroundColor: bg_color,
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
              height: 340,
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
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Center(
                      child: Text(
                        //
                        text_hello,
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
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Center(
                      child: Text(
                        //
                        text_sign_into_your_account,
                        //
                        style: const TextStyle(
                          fontFamily: 'Avenir Next',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                      right: 10,
                    ),
                    child: TextFormField(
                      controller: cont_txt_email_address,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.person_3_outlined,
                          color: Colors.grey,
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
                      right: 10,
                      bottom: 10,
                    ),
                    child: TextFormField(
                      controller: cont_txt_password,
                      obscureText: true,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.lock_open,
                          color: Colors.grey,
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
                      // setState(() {
                      //   loader_indicator = '1';
                      // });
                    },
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardScreen(
                          get_login_sender_chat_id: 'Dashboard',
                        ),
                      ),
                    ),*/
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
                                text_sign_in,
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
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: 10.0,
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          //
                          text_forgot_password,
                          //
                          style: const TextStyle(
                            fontFamily: 'Avenir Next',
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationScreen(),
                    ),
                  ),
                  child: Text(
                    //
                    text_dont_have_an_account,
                    //
                    style: const TextStyle(
                      fontFamily: 'Avenir Next',
                      fontSize: 16.0,
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
      login_api_call
          .sign_in_user(
        cont_txt_email_address.text,
        cont_txt_password.text,
      )
          .then(
        (value) {
          // Album_Login(
          //   success_status: 'success_status',
          //   message: 'message',
          // );

          print(value.success_status);
          if (value.success_status == 'fails') {
            setState(() {
              loader_indicator = '0';
            });
            _showMyDialog(
              value.message.toString(),
            );
          } else {
            func_check_before_enter();
          }
        },
      );
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

// CHECK BEFORE ENTERING THE APP
  func_check_before_enter() async {
    setState(() {
      loader_indicator = '0';
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('gender').toString() == '') {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => const DashboardScreen(),
      //   ),
      // );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const CompleteProfileScreen(str_from_edit: 'no'),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Dashboard2Screen(),
        ),
      );
    }
  }

  //
  /*func_firebase_login() async {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: cont_txt_email_address.text.toString(),
      password: cont_txt_password.text.toString(),
    );

    print(userCredential.user);

    //
    // setState(() {
    //   // firebase_error_status = '0';
    //   // str_save_and_continue_loader = '1';
    // });
    //
    /*try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: cont_txt_email_address.text.toString(),
        password: cont_txt_password.text.toString(),
      );
      if (kDebugMode) {
        print(userCredential.user);
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(
              // get_login_sender_chat_id: 'Dashboard',
              ),
        ),
      );
    } on FirebaseAuthException {
      setState(() {
        // firebase_error_status = '1';
        // str_save_and_continue_loader = '0';
        // firebase_error_status_text = e.code.toString();
      });
    } catch (e) {
      print(e);
    }*/
  }*/
}
