// ignore_for_file: non_constant_identifier_names

import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/material.dart';

class AppBarScreen extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String navigation_title_name;

  AppBarScreen({Key? key, required this.navigation_title_name})
      : preferredSize = const Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        navigation_title_name,
        style: TextStyle(
          fontFamily: font_family_name,
          fontSize: font_size_medium,
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.of(context).pop(),
      ),
      automaticallyImplyLeading: false,
    );
  }
}
