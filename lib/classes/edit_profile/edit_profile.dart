// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:cameroon_2/classes/complete_profile/complete_profile.dart';
import 'package:cameroon_2/classes/custom/drawer/drawer.dart';
import 'package:cameroon_2/classes/edit_profile/edit_profile_modal.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  //
  //
  var loader_indicator = '0';
  // name
  TextEditingController cont_txt_name = TextEditingController();
  // email
  TextEditingController cont_txt_email = TextEditingController();
  // address
  TextEditingController cont_txt_address = TextEditingController();
  TextEditingController cont_txt_phone = TextEditingController();
  //
  //
  final edit_profile_api_modal_call = EditProfileModal();
  //
  var str_gender;
  var str_login_user_name;
  var str_login_user_email;
  var str_login_user_address;
  var str_contact_number;

  @override
  void initState() {
    super.initState();
    get_login_user_data();
  }

  get_login_user_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    str_login_user_name = prefs.getString('fullName').toString();
    str_login_user_email = prefs.getString('email').toString();
    str_login_user_address = prefs.getString('address').toString();
    str_contact_number = prefs.getString('contactNumber').toString();

    cont_txt_name = TextEditingController(text: str_login_user_name);
    cont_txt_email = TextEditingController(text: str_login_user_email);
    cont_txt_address = TextEditingController(text: str_login_user_address);
    cont_txt_phone = TextEditingController(text: str_contact_number);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit profile',
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
        backgroundColor: bg_color,
      ),
      // backgroundColor: Colors.amber,
      drawer: const navigationDrawer(),
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
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 10,
                right: 10,
              ),
              child: TextFormField(
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                controller: cont_txt_name,
                keyboardType: TextInputType.emailAddress,
                // initialValue: str_login_user_name.toString(),
                decoration: const InputDecoration(
                  suffixIcon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  border: UnderlineInputBorder(),
                  labelText: 'Name',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                controller: cont_txt_email,
                enabled: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  border: const UnderlineInputBorder(),
                  labelText: text_email_address,
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                controller: cont_txt_address,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.location_city,
                    color: Colors.white,
                  ),
                  border: const UnderlineInputBorder(),
                  labelText: text_address,
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
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
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                controller: cont_txt_phone,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  border: const UnderlineInputBorder(),
                  labelText: text_phone_number,
                  labelStyle: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {});
                loader_indicator = '1';
                update_profile_WB();
              },
              child: Container(
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
                            text_update,
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
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompleteProfileScreen(
                      str_from_edit: 'yes',
                    ),
                  ),
                );
              },
              child: Container(
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
                    text_edit_more_details,
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
    );
  }

  update_profile_WB() {
    edit_profile_api_modal_call
        .edit_profile_WB(
      cont_txt_name.text,
      cont_txt_email.text,
      cont_txt_address.text,
      cont_txt_phone.text,
    )
        .then(
      (value) {
        print(value.success_status);
        if (value.success_status == 'fails') {
          setState(() {
            loader_indicator = '0';
          });
          // _showMyDialog(
          //   value.message.toString(),
          // );
        } else {
          if (kDebugMode) {
            print('EDIT SUCCESS');
          }
          loader_indicator = '0';

          setState(() {});

          //
          //
          //
          //
          var snackBar = SnackBar(
            content: Text(value.message),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // SUCCESS
          //
          //
          //
          //
        }
      },
    );
  }
}
