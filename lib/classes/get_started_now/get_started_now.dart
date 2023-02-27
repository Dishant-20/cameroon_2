// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

// import 'package:cameroon_2/classes/dashboard/dashboard.dart';
import 'package:cameroon_2/classes/complete_profile/complete_profile.dart';
import 'package:cameroon_2/classes/dashboard/dashboard2.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:cameroon_2/classes/login/login.dart';
import 'package:cameroon_2/classes/registration/registration.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_beautiful_popup/templates/Gift.dart';
// import 'package:popup_card/popup_card.dart';

// import 'package:beautiful_popup/main.dart';

class GetStartedNowScreen extends StatefulWidget {
  const GetStartedNowScreen({super.key});

  @override
  State<GetStartedNowScreen> createState() => _GetStartedNowScreenState();
}

class _GetStartedNowScreenState extends State<GetStartedNowScreen> {
  //

  @override
  void initState() {
    super.initState();
    _handleLocationPermission();
    func_get_login_user_data();
  }

  func_get_login_user_data() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getInt('userId').toString() == 'null') {
      print('login');
    } else if (prefs.getInt('userId').toString() == '') {
      print('login');
    } else {
      if (prefs.getString('gender').toString() == '') {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const CompleteProfileScreen(
        //       str_from_edit: 'no',
        //     ),
        //   ),
        // );
      } else {
        if (kDebugMode) {
          print('ok ok ok ok ');
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard2Screen(),
          ),
        );
      }
    }
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        // theme: ThemeData(
        //   scaffoldBackgroundColor: Colors.transparent,
        // ),
        home: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Get Started Now'.tr,
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
              // color: Colors.amber,
              // image: DecorationImage(
              //   image: AssetImage('assets/images/yellow_bg.png'),
              //   fit: BoxFit.contain,
              // ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/images/logo.png',
                  ),
                ),
                //
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    // height: 300,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.transparent,
                    child: Column(
                      children: <Widget>[
                        Align(
                          child: Text(
                            'login_welcome_message'.tr,
                            style: TextStyle(
                              fontFamily: font_family_name,
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          /*RichText(
                            text: TextSpan(
                              children: [
                                // const WidgetSpan(
                                //   child: Icon(
                                //     Icons.edit,
                                //     size: 16.0,
                                //   ),
                                // ),
                                TextSpan(
                                  text: 'login_welcome_message'.tr,
                                  style: TextStyle(
                                    fontFamily: font_family_name,
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Get Started Now'.tr,
                          style: TextStyle(
                            fontFamily: font_family_name,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(200, 60, 26, 1),
                              borderRadius: BorderRadius.circular(
                                30,
                              ),
                            ),
                            child: Align(
                              child: Text(
                                //
                                text_sign_in,
                                //
                                style: TextStyle(
                                  fontFamily: font_family_name,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegistrationScreen(),
                              ),
                            );
                          },
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              // color: const
                              gradient: const LinearGradient(
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
                              borderRadius: BorderRadius.circular(
                                30,
                              ),
                            ),
                            child: Align(
                              child: Text(
                                //
                                text_create_an_account,
                                //
                                style: TextStyle(
                                  fontFamily: font_family_name,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
  //
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}
