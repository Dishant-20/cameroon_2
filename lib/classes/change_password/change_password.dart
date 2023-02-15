// ignore_for_file: non_constant_identifier_names

import 'package:cameroon_2/classes/change_password/change_password_modal.dart';
import 'package:cameroon_2/classes/custom/drawer/drawer.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:triple_r_custom/Utils.dart';
// import 'package:triple_r_custom/classes/change_password/change_password_modal.dart';
// import 'package:triple_r_custom/custom_files/app_bar/appbar.dart';
// import 'package:triple_r_custom/custom_files/drawer/drawer.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  //
  var loader_indicator = '0';
  // name
  TextEditingController cont_txt_old_password = TextEditingController();
  // email
  TextEditingController cont_txt_new_password = TextEditingController();
  // password
  TextEditingController cont_txt_confirm_password = TextEditingController();
  //
  final change_password_service = ChangePasswordModal();
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text(
          //
          text_change_language,
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
      ),
      drawer: const navigationDrawer(),
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
                    'assets/images/password.png',
                  ),
                  // fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 360.0,
                left: 20.0,
                right: 20.0,
              ),
              height: 400 - 50,
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
                        text_change_language,
                        //
                        style: GoogleFonts.montserrat(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        // style: TextStyle(
                        //   fontFamily: font_family_name,
                        //   fontWeight: FontWeight.bold,
                        //   fontSize: 18.0,
                        // ),
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
                      obscureText: true,
                      controller: cont_txt_old_password,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.lock_open,
                          color: Colors.grey,
                        ),
                        border: const UnderlineInputBorder(),
                        labelText: text_old_password,
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
                          Icons.lock_open,
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
                          Icons.lock_open,
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

                      change_password_service
                          .update_password_WB(
                        cont_txt_old_password.text,
                        cont_txt_new_password.text,
                      )
                          .then(
                        (value) {
                          print('object');
                          print(value.success_status);
                          if (value.success_status == 'Fails'.toLowerCase()) {
                            setState(() {
                              loader_indicator = '0';
                            });
                            _showMyDialog(
                              value.message.toString(),
                            );
                          } else {
                            setState(() {
                              loader_indicator = '0';
                            });
                            const snackBar = SnackBar(
                              content: Text('Successfully updated.'),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            // Navigator.pop(context);
                            cont_txt_old_password.text = '';
                            cont_txt_new_password.text = '';
                            cont_txt_confirm_password.text = '';
                          }
                        },
                      );
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
                                text_submit,
                                //
                                style: const TextStyle(
                                  fontFamily: 'Avenir Next',
                                  fontSize: 20.0,
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

  //
  Future<void> _showMyDialog(
    String str_message,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            //
            text_alert,
            //
            style: TextStyle(
              fontFamily: font_family_name,
              fontSize: 16.0,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  //
                  text_passwordd_alert,
                  //str_message,
                  //
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
              child: Text(
                text_dismiss,
              ),
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
