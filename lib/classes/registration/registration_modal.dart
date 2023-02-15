// ignore_for_file: non_constant_identifier_names, camel_case_types

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:cameroon_2/classes/header/utils/Utils.dart';

class Album {
  final String userId;
  final String name;
  // final String ;

  const Album({required this.userId, required this.name});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['status'],
      name: json['msg'],
    );
  }
}

/*
action:editprofile
userId:
image
gender:
height:
dob:  YYYY-mm-dd
address:
zipCode:
interent_in:  //1=Male,2=Female,3=Other,4=Both        
religion:
education:
zone:
regionId:
latitude:
longitude:
*/
class RegistrationModel {
  Future<Album> create_user(
    String full_name,
    String email_address,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse(
        application_base_url,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'registration',
          'fullName': full_name,
          'email': email_address,
          'contactNumber': '',
          'password': password,
          'role': 'Member',
          'latitude': '20',
          'longitude': '30',
        },
      ),
    );
    // print();

    if (response.statusCode == 201) {
      print('=========> 201');
      print(response.body);
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 200) {
      print('==========> 200');
      print(response.body);

      Map<String, dynamic> success_status = jsonDecode(response.body);
      // print(" User name ${success_status['status']}");
      // convert success to lower case
      var success_text = success_status['status'].toString().toLowerCase();

      // after SUCCESS
      if (success_text == "success") {
        print('=========> USER SUCCESSFULLY REGISTERED <===========');

        // convert data to dict
        Map<String, dynamic> get_data = jsonDecode(response.body);

        // get data from server key : if any
        // Map<String, dynamic> user = get_data['data'];
        // print(user);

        return Album(userId: get_data['status'], name: get_data['msg']);
      } else {
        print('========> SUCCESS WORD FROM SERVER IS WRONG <=========');
        return Album(
          userId: success_text,
          name: success_status['msg'].toString(),
        );
      }
      // throw Exception('SOMETHING WENT WRONG. PLEASE CHECK');
    } else {
      print("============> ERROR");
      print(response.body);
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      // throw Exception('Failed to create album.');
      return Album(
        userId: 'Fail',
        name: 'Server Issue. Please contact admin.'.toString(),
      );
    }
  }
}
