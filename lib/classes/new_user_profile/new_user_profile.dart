import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class NewUserProfile extends StatefulWidget {
  const NewUserProfile({super.key});

  @override
  State<NewUserProfile> createState() => _NewUserProfileState();
}

class _NewUserProfileState extends State<NewUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'User Profile',
          style: TextStyle(
            fontFamily: font_family_name,
          ),
        ),
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
      body: Container(
        height: 300,
        width: MediaQuery.of(context).size.width,
        color: Colors.pinkAccent,
        child: Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(10.0),
              color: Colors.amber[600],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: const Image(
                image: AssetImage(
                  'assets/images/back.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.all(10.0),
                color: Colors.amber[600],
                width: MediaQuery.of(context).size.width,
                height: 100,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 10,
                top: 110.0,
                right: 10,
              ),
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 30.0),
                    color: Colors.transparent,
                    width: 60,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          // margin: const EdgeInsets.all(10.0),

                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(34, 182, 34, 1),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: Align(
                            child: Text(
                              '123',
                              style: TextStyle(
                                fontFamily: font_family_name,
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        //
                        Text(
                          'Photos',
                          style: TextStyle(
                            fontFamily: font_family_name,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/id/237/200/300',
                    ),
                  ),
                  //
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 30.0),
                    color: Colors.transparent,
                    width: 60,
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          // margin: const EdgeInsets.all(10.0),

                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color.fromRGBO(170, 0, 20, 1),
                            borderRadius: BorderRadius.circular(
                              30,
                            ),
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                          ),
                          child: Align(
                            child: Text(
                              '123',
                              style: TextStyle(
                                fontFamily: font_family_name,
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        //
                        Text(
                          'Age',
                          style: TextStyle(
                            fontFamily: font_family_name,
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
