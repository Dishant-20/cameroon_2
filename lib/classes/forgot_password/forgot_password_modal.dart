// ignore_for_file: unused_local_variable, non_constant_identifier_names, prefer_const_constructors, camel_case_types

import 'dart:convert';

import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:triple_r_custom/Utils.dart';

class Forgot_Password_Response {
  final String success_status;
  final String message;
  // final String ;

  const Forgot_Password_Response(
      {required this.success_status, required this.message});

  factory Forgot_Password_Response.fromJson(Map<String, dynamic> json) {
    return Forgot_Password_Response(
      success_status: json['status'],
      message: json['msg'],
    );
  }
}

class ForgotPasswordModal {
  forgot_password_WB(
    String email_address,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(
      Uri.parse(
        application_base_url,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'forgotpassword',
          'email': email_address,
        },
      ),
    );
    // print();

    if (response.statusCode == 201) {
      print('=========> 201');
      print(response.body);
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Forgot_Password_Response.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 200) {
      print('==========> 200');
      print(response.body);

      Map<String, dynamic> success_status = jsonDecode(response.body);
      // print(" User name ${success_status['status']}");
      // convert success to lower case
      var success_text = success_status['status'].toString().toLowerCase();

      // after SUCCESS
      if (success_text == "success") {
        print('=========> LOGIN SUCCESS <===========');

        return Forgot_Password_Response(
          success_status: success_text,
          message: success_status['msg'].toString(),
        );
      } else {
        print('========> SUCCESS WORD FROM SERVER IS WRONG <=========');
        return Forgot_Password_Response(
          success_status: success_text,
          message: success_status['msg'].toString(),
        );
      }
      // throw Exception('SOMERTHING WENT WRONG. PLEASE CHECK');
    } else {
      print("============> ERROR");
      return Forgot_Password_Response(
        success_status: 'Server Issue',
        message: 'Server Issue'.toString(),
      );
      /*print(response.body);
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');*/
    }
  }
}
