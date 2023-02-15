// ignore_for_file: non_constant_identifier_names

import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/material.dart';
// import 'package:journey_recorded/Utils.dart';

class CustomeLoaderPopUp extends StatefulWidget {
  const CustomeLoaderPopUp(
      {super.key, required this.str_custom_loader, required this.str_status});

  final String str_custom_loader;
  final String str_status;

  @override
  State<CustomeLoaderPopUp> createState() => _CustomeLoaderPopUpState();
}

class _CustomeLoaderPopUpState extends State<CustomeLoaderPopUp> {
  @override
  Widget build(BuildContext context) {
    if (widget.str_status == '0') {
      return Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Center(
          child: Container(
            height: 120,
            width: 120,
            color: Colors.white,
            child: Center(
              child: Column(
                children: <Widget>[
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      //
                      widget.str_custom_loader,
                      //
                      style: TextStyle(
                        fontFamily: font_family_name,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (widget.str_status == '3') {
      return Container(
        height: 100,
        color: Colors.white,
        child: Center(
          child: Container(
            height: 120,
            width: 120,
            color: Colors.white,
            child: Center(
              child: Column(
                children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      //
                      widget.str_custom_loader,
                      //
                      style: TextStyle(
                        fontFamily: font_family_name,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (widget.str_status == '4') {
      return Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: Align(
          child: Text(
            //
            widget.str_custom_loader,
            //
            style: TextStyle(
              fontFamily: font_family_name,
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
        ),

        /*Center(
          child: Container(
            height: 320,
            width: 160,
            color: Colors.white,
            child: Center(
              child: Column(
                children: <Widget>[
                  const Icon(
                    Icons.no_accounts,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      //
                      widget.str_custom_loader,
                      //
                      style: TextStyle(
                        fontFamily: font_style_name,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),*/
      );
    } else {
      return Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Center(
          child: Container(
            height: 120,
            width: 120,
            color: Colors.white,
            child: Center(
              child: Column(
                children: <Widget>[
                  const Icon(
                    Icons.no_accounts,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      //
                      widget.str_custom_loader,
                      //
                      style: TextStyle(
                        fontFamily: font_family_name,
                        color: Colors.black,
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
  }
}
