// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
// import 'package:triple_r_custom/Utils.dart';

class Edit_profile_success {
  final String success_status;
  final String message;
  // final String ;

  const Edit_profile_success(
      {required this.success_status, required this.message});

  factory Edit_profile_success.fromJson(Map<String, dynamic> json) {
    return Edit_profile_success(
      success_status: json['status'],
      message: json['msg'],
    );
  }
}

class EditProfileModal {
  edit_profile_WB(
    String full_name,
    String email,
    String address,
    String contact_number,
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
          'action': 'editprofile',
          'userId': prefs.getInt('userId').toString(),
          'fullName': full_name,
          'email': email,
          'address': address,
          'contactNumber': contact_number,
        },
      ),
    );
    // print();

    if (response.statusCode == 201) {
      print('=========> 201');
      print(response.body);
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Edit_profile_success.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 200) {
      print('==========> 200');
      print(response.body);

      Map<String, dynamic> success_status = jsonDecode(response.body);
      // print(" User name ${success_status['status']}");
      // convert success to lower case
      var success_text = success_status['status'].toString().toLowerCase();

      // after SUCCESS
      if (success_text == "success") {
        print('=========> EDIT SUCCESS <===========');

        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();

        // save login data locally
        Map<String, dynamic> get_data = jsonDecode(response.body);
        Map<String, dynamic> user = get_data['data'];
        await prefs.setInt('userId', user['userId']);
        await prefs.setString('fullName', user['fullName']);
        await prefs.setString('email', user['email']);
        await prefs.setString('address', user['address']);
        await prefs.setString('contactNumber', user['contactNumber']);
        //
        // Map<String, dynamic> user = get_data['data'];
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
        await prefs.setString('zone', user['zone']);

        return Edit_profile_success(
          success_status: success_text,
          message: success_status['msg'].toString(),
        );
      } else {
        print('========> SUCCESS WORD FROM SERVER IS WRONG <=========');
        return Edit_profile_success(
          success_status: success_text,
          message: success_status['msg'].toString(),
        );
      }
      // throw Exception('SOMERTHING WENT WRONG. PLEASE CHECK');
    } else {
      print("============> ERROR");
      print(response.body);
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }
  }
}
