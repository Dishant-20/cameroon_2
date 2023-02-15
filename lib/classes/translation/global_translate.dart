// ignore_for_file: camel_case_types, non_constant_identifier_names

import 'dart:ui';

import 'package:get/get.dart';

class translate_language {
  func_prefered_language(str_language_type) {
    if (str_language_type == '1') {
      var locale = const Locale('en');
      Get.updateLocale(locale);
    } else if (str_language_type == '2') {
      var locale = const Locale('fr');
      Get.updateLocale(locale);
    }
  }
}

func_prefered_language(str_language_type) {
  if (str_language_type == 'en') {
    var locale = const Locale('en');
    Get.updateLocale(locale);
  } else if (str_language_type == 'fr') {
    var locale = const Locale('fr');
    Get.updateLocale(locale);
  }
}
