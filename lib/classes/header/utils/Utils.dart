// ignore_for_file: non_constant_identifier_names

import 'package:get/get.dart';

// import 'dart:ui';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'dart:ui';

var application_base_url =
    'https://demo4.evirtualservices.net/cameroon/services/index';

// var application_base_url =
// 'https://camerron.evirtualservices.co/services/index';

//

var font_family_name = 'Avenir Next';
// GoogleFonts.montserrat(fontSize: 16);
// font size
var font_size_small = 16.0;
var font_size_medium = 18.0;
var font_size_large = 20.0;

// BACKGROUND COLOR
var bg_color = const Color.fromRGBO(
  250,
  0,
  33,
  1,
);

/* ================================================================ */

// text with regular
Text text_with_regular_style(str) {
  return Text(
    str.toString(),
    style: GoogleFonts.montserrat(
      fontSize: 16.0,
    ),
  );
}

// text with bold
Text text_with_bold_style(str) {
  return Text(
    str.toString(),
    style: GoogleFonts.montserrat(
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
  );
}

// text with bold
Text text_with_bold_style_black(str) {
  return Text(
    str.toString(),
    style: GoogleFonts.montserrat(
      fontSize: 18.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
  );
}

/* ================================================================ */

// text
var text_login = 'text_login'.tr;
var text_sign_in = 'sign_in'.tr;
var text_sign_up = 'sign_up'.tr;
var text_create_an_account = 'create_an_account'.tr;
var text_forgot_password = 'forgot_password'.tr;
var text_hello = 'hello'.tr;
var text_sign_into_your_account = 'sign_into_your_account'.tr;
var text_email_address = 'email_address'.tr;
var text_password = 'password'.tr;
var text_dont_have_an_account = 'dont_have_an_account'.tr;
var text_submit = 'submit'.tr;
var text_full_name = 'full_name'.tr;
var text_already_have_an_accont = 'already_have_an_account'.tr;

// alertR
var alert_email_empty = 'email_empty'; //.tr;
var alert_password_empty = 'pass_empty'; //.tr;

// forgot password
var text_forgot_password_message = 'forgot_password_message'.tr;

// inside app
var text_female = 'text_female'.tr;
var text_male = 'text_male'.tr;
var text_years_old = 'years_old'.tr;

var text_photos = 'photos'.tr;
var text_age = 'age'.tr;

var text_location = 'location'.tr;
var text_interest_in = 'interest_in'.tr;
var text_height = 'height'.tr;
var text_education = 'education'.tr;
var text_religion = 'religion'.tr;
var text_contact_number = 'contact_number'.tr;

// side bar menu
var text_dashboard = 'dashboard'.tr;
var text_edit_profile = 'edit_profile'.tr;
var text_gallery = 'gallery'.tr;
var text_matches = 'matches'.tr;
var text_subscription = 'subscription'.tr;
var text_change_language = 'change_language'.tr;
var text_change_password = 'change_password'.tr;
var text_help = 'help'.tr;
var text_logout = 'logout'.tr;

// edit profile
var text_name = 'name'.tr;
var text_address = 'address'.tr;
var text_phone_number = 'phone_number'.tr;

var text_update = 'update'.tr;
var text_edit_more_details = 'edit_more_details'.tr;

var text_complete_profile = 'complete_profile'.tr;
var text_gender = 'gender'.tr;
var text_prefer_not_to_say = 'prefer_not_to_say'.tr;
var text_dismiss = 'dismiss'.tr;
var text_other = 'other'.tr;

var text_save_and_continue = 'save_and_continue'.tr;

// gallery
var text_delete = 'delete'.tr;
var text_photo = 'photo'.tr;
var text_delete_message = 'are_you_sure'.tr;

var text_user_profile = 'user_profile'.tr;

var text_search = 'search'.tr;

// change password
var text_old_password = 'old_password'.tr;
var text_new_password = 'new_password'.tr;
var text_confirm_password = 'confirm_password'.tr;

var text_passwordd_alert = 'password_alert'.tr;
var text_alert = 'alert'.tr;

var text_need_help = 'need_help'.tr;
var text_help_rights = 'rights_reserved'.tr;

var text_logout_alert = 'are_you_sure_logout'.tr;

var text_please_wait = 'please_wait'.tr;

// create new password
var text_create_new_password = 'create_new_password'.tr;
var text_create_password_alert = 'create_password_alert'.tr;
var text_enter_otp = 'enter_otp'.tr;

// religion
var text_christianity = 'christianity'.tr;
var text_protestants = 'protestants'.tr;
var text_mormons = 'mormons'.tr;
var text_chatholic = 'catholic'.tr;

// nearby friend
var text_nearby_friend = 'nearby_friend'.tr;

// notifications
var text_notification = 'notification'.tr;
