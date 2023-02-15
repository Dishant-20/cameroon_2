import 'package:cameroon_2/classes/change_password_With_OTP/change_password_with_otp.dart';
import 'package:cameroon_2/classes/forgot_password/forgot_password_modal.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:triple_r_custom/Utils.dart';
// import 'package:triple_r_custom/classes/change_pass_with_otp/change_password_with_otp.dart';
// import 'package:triple_r_custom/classes/forgot_password/forgot_password_modal.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();

  // forgot_password_WB(String text) {}
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //
  var loader_indicator = '0';
  //
  // email
  TextEditingController cont_txt_email_address = TextEditingController();
  //
  //
  final forgot_password_s = ForgotPasswordModal();
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          //
          text_forgot_password,
          //
          style: TextStyle(
            fontFamily: font_family_name,
          ),
        ),
        backgroundColor: bg_color,
        leading: IconButton(
          onPressed: () {
            if (kDebugMode) {
              print('');
            }
            Navigator.pop(context);
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
              height: 320,
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
              height: 280,
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
                        text_forgot_password,
                        //
                        style: TextStyle(
                          fontFamily: font_family_name,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.transparent,
                      width: MediaQuery.of(context).size.width,
                      // height: 70,
                      child: Center(
                        child: Text(
                          //
                          text_forgot_password_message,
                          //
                          style: const TextStyle(
                            fontFamily: 'Avenir Next',
                            fontSize: 16.0,
                          ),
                        ),
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
                      controller: cont_txt_email_address,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        suffixIcon: const Icon(
                          Icons.email,
                          color: Colors.grey,
                        ),
                        border: const UnderlineInputBorder(),
                        labelText: text_email_address,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      validation_before_forgot();
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
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                  ),
                  /*InkWell(
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
                      child: const Center(
                        child: Text(
                          'forgot password',
                          style: TextStyle(
                            fontFamily: 'Avenir Next',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
            /*Container(
              margin: const EdgeInsets.only(
                top: 710.0,
                left: 20.0,
                right: 20.0,
              ),
              width: MediaQuery.of(context).size.width,
              height: 30,
              color: Colors.transparent,
              child: Center(
                child: const Text(
                  '''Don't have an account - Sign Up''',
                  style: TextStyle(
                    fontFamily: 'Avenir Next',
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),*/
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

  validation_before_forgot() {
    if (cont_txt_email_address.text == '') {
      _showMyDialog('Email should not be empty.');
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      setState(() {
        loader_indicator = '1';
      });
      forgot_password_s
          .forgot_password_WB(
        cont_txt_email_address.text,
      )
          .then(
        (value) {
          // Album_Login(
          //   success_status: 'success_status',
          //   message: 'message',
          // );

          print(value);
          if (kDebugMode) {
            print(value.success_status);
            print('Dishant rajput');
          }
          if (value.success_status == 'fails') {
            setState(() {
              loader_indicator = '0';
            });
            _showMyDialog(
              value.message.toString(),
            );
          } else if (value.success_status == 'Server Issue') {
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
            var snackBar = SnackBar(
              content: Text(value.message),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //
            // Navigator.pop(context);
            //
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePasswordWithOTP(
                  str_email: cont_txt_email_address.text.toString(),
                ),
              ),
            );
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
}
