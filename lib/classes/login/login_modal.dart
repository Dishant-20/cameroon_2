// ignore_for_file: unused_local_variable, non_constant_identifier_names, prefer_const_constructors, camel_case_types

import 'dart:convert';

import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:triple_r_custom/Utils.dart';

class Album_Login {
  final String success_status;
  final String message;
  // final String ;

  const Album_Login({required this.success_status, required this.message});

  factory Album_Login.fromJson(Map<String, dynamic> json) {
    return Album_Login(
      success_status: json['status'],
      message: json['msg'],
    );
  }
}

class LoginModal {
  sign_in_user(
    String email_address,
    String password,
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
          'action': 'login',
          'email': email_address,
          'password': password,
        },
      ),
    );
    // print();

    if (response.statusCode == 201) {
      print('=========> 201');
      print(response.body);
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Album_Login.fromJson(jsonDecode(response.body));
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

        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.clear();

        // save login data locally
        Map<String, dynamic> get_data = jsonDecode(response.body);
        Map<String, dynamic> user = get_data['data'];
        await prefs.setInt('userId', user['userId']);
        await prefs.setString('fullName', user['fullName']);
        await prefs.setString('email', user['email']);
        await prefs.setString('role', user['role']);
        await prefs.setString('address', user['address']);
        await prefs.setString('contactNumber', user['contactNumber']);

        await prefs.setString('gender', user['gender']);
        await prefs.setString('dob', user['dob']);
        await prefs.setString('interent_in', user['interent_in'].toString());
        await prefs.setString('religion', user['religion']);
        await prefs.setString('height', user['height']);
        await prefs.setString('education', user['education']);
        await prefs.setString('zone', user['zone']);

        await prefs.setString('subscribeId', user['subscribeId']);
        await prefs.setString('subscriptionDate', user['subscriptionDate']);

        // await prefs.setString('gender', user['gender']);
        //
        return Album_Login(
          success_status: success_text,
          message: success_status['msg'].toString(),
        );
      } else {
        print('========> SUCCESS WORD FROM SERVER IS WRONG <=========');
        return Album_Login(
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


/*
class LoginApiModal {
  Future<LoginApiResponse> sign_in_user(
    String email_address,
    String password,
    String device_token,
  ) async {
    final login_response = await http.post(
      Uri.parse(
        application_base_url,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'login',
          'email': email_address,
          'password': password,
        },
      ),
    );

    if (login_response.statusCode == 200) {
      // convert data to dict
      Map<String, dynamic> get_data = jsonDecode(login_response.body);

      // get data from server key : if any
      Map<String, dynamic> user = get_data['data'];
      // print(user);

      // SharedPreferences preferences = await SharedPreferences.getInstance();
      // await preferences.clear();

// Obtain shared preferences.
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      ///
      await prefs.setInt('userId', user['userId']);
      await prefs.setString('fullName', user['fullName']);
      // await prefs.setString('lastName', user['lastName']);
      // await prefs.setString('middleName', user['middleName']);
      await prefs.setString('email', user['email']);
      // await prefs.setString('gender', user['gender']);
      // await prefs.setString('role', user['role']);
      // await prefs.setString('dob', user['dob']);
      // await prefs.setString('address', user['address']);
      // await prefs.setString('city', user['city']);
      // await prefs.setString('zipCode', user['zipCode']);
      // await prefs.setString('stateId', user['usestateIdrId']);
      // await prefs.setString('countryId', user['countryId']);
      // await prefs.setString('contactNumber', user['contactNumber']);
      // await prefs.setString('image', user['image']);
      // await prefs.setString('device', user['device']);
      // await prefs.setString('deviceToken', user['deviceToken']);

      // print(login_response.body);
      return LoginApiResponse(
          userId: user['userId'],
          fullName: user['fullName'],
          lastName: user['lastName'],
          middleName: user['middleName'],
          email: user['email'],
          gender: user['gender'],
          role: user['role'],
          dob: user['dob'],
          address: user['address'],
          city: user['city'],
          zipCode: user['zipCode'],
          stateId: user['stateId'],
          countryId: user['countryId'],
          contactNumber: user['contactNumber'],
          image: user['image'],
          device: user['device'],
          deviceToken: user['deviceToken']);
    } else {
      print('WEBSERVICE NOT WORKING. Please contact Admin.');
      throw Exception('Failed to create album.');
    }
  }
}

// ios_dgsqxfb_tester@tfbnw.net
// IosTester2022@
class LoginApiResponse {
  final int? userId;
  final String? fullName;
  final String? lastName;
  final String? middleName;
  final String? email;
  final String? gender;
  final String? role;
  final String? dob;
  final String? address;
  final String? city;
  final String? zipCode;
  final String? stateId;
  final String? countryId;
  final String? contactNumber;
  final String? image;
  final String? device;
  final String? deviceToken;

  const LoginApiResponse(
      {required this.userId,
      required this.fullName,
      required this.lastName,
      required this.middleName,
      required this.email,
      required this.gender,
      required this.role,
      required this.dob,
      required this.address,
      required this.city,
      required this.zipCode,
      required this.stateId,
      required this.countryId,
      required this.contactNumber,
      required this.image,
      required this.device,
      required this.deviceToken});

  factory LoginApiResponse.fromJson(Map<String, dynamic> json) {
    return LoginApiResponse(
      userId: json['userId'],
      fullName: json['fullName'],
      lastName: json['lastName'],
      middleName: json['middleName'],
      email: json['email'],
      gender: json['gender'],
      role: json['role'],
      dob: json['dob'],
      address: json['address'],
      city: json['city'],
      zipCode: json['zipCode'],
      stateId: json['stateId'],
      countryId: json['countryId'],
      contactNumber: json['contactNumber'],
      image: json['image'],
      device: json['device'],
      deviceToken: json['deviceToken'],
    );
  }
}
*/