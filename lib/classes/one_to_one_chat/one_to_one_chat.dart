// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:convert';

import 'dart:io';
import 'dart:math';

import 'package:cameroon_2/classes/audio_call/audio_call.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_lorem/flutter_lorem.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class OneToOneChatScreen extends StatefulWidget {
  const OneToOneChatScreen(
      {super.key,
      required this.str_get_login_user_id,
      required this.str_get_friend_id,
      required this.str_get_friend_name,
      required this.str_get_friend_image,
      required this.str_get_friend_device_token,
      this.get_full_data});

  final get_full_data;
  final String str_get_login_user_id;
  final String str_get_friend_id;
  final String str_get_friend_name;
  final String str_get_friend_image;
  final String str_get_friend_device_token;

  @override
  State<OneToOneChatScreen> createState() => _OneToOneChatScreenState();
}

class _OneToOneChatScreenState extends State<OneToOneChatScreen> {
  //
  TextEditingController cont_txt_send_message = TextEditingController();
  //
  bool _needsScroll = false;
  final ScrollController _scrollController = ScrollController();
  //
  var room_id = '';
  var reverse_room_id = '';
  //
  var str_image_processing = '0';
  File? imageFile;

  //
  FirebaseStorage storage = FirebaseStorage.instance;
  //
  var str_last_message = '';
  //
  @override
  void initState() {
    super.initState();
    //
    if (kDebugMode) {
      print('<====== dishant rajput =======>');
      print(widget.get_full_data);
    }
    func_create_room_id();
    //
  }

  @override
  void dispose() {
    /*await agoraEngine.leaveChannel().then((value) => {
          Navigator.pop(context),
        });*/
    // await agoraEngine.leaveChannel();

    dispose();
    super.dispose();
  }

// create room
  func_create_room_id() {
    room_id = '${widget.str_get_friend_id}+${widget.str_get_login_user_id}';

    reverse_room_id =
        '${widget.str_get_login_user_id}+${widget.str_get_friend_id}';

    // print(room_id);
    // print(reverse_room_id);

    setState(() {
      func_scroll_to_bottom();
    });
  }

  _scrollToEnd() async {
    if (_needsScroll) {
      _needsScroll = false;
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }
  }

  // scroll to bottom
  func_scroll_to_bottom() {
    _needsScroll = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());

    if (mounted) {
      func_save_last_message();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Chat',
          style: TextStyle(
            fontFamily: font_family_name,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            if (kDebugMode) {
              print('');
            }
            Navigator.of(context).pop('');
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                if (kDebugMode) {
                  print('click on audio call');
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioCallScreen(
                      get_receiver_data: widget.get_full_data,
                      str_start_pick_end_call: 'make_a_call',
                      str_friend_image: widget.str_get_friend_image.toString(),
                      str_friend_name: widget.str_get_friend_name.toString(),
                      str_device_token:
                          widget.str_get_friend_device_token.toString(),
                    ),
                  ),
                );
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioCallScreen(
                      str: widget.str_get_friend_name.toString(),
                      str_friend_name: widget.str_get_friend_name.toString(),
                      str_channel_name: room_id.toString(),
                    ),
                  ),
                );*/
              },
              icon: const Icon(
                Icons.call,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          //1
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection(
                  'message/evs_cameroon_chat/one_to_one_chat',
                )
                .orderBy('time_stamp', descending: true)
                // .limit(20)
                .where(
              'room_id',
              whereIn: [
                room_id,
                reverse_room_id,
              ],
            ).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //
                func_scroll_to_bottom();
                //
                var save_snapshot_value = snapshot.data!.docs.reversed.toList();
                return Container(
                  margin: const EdgeInsets.only(bottom: 80),
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          for (int i = 0;
                              i < save_snapshot_value.length;
                              i++) ...[
                            (save_snapshot_value[i]['sender_id'].toString() ==
                                    widget.str_get_login_user_id.toString())
                                ? right_side_UI(save_snapshot_value, i)
                                : left_side_chat_UI(save_snapshot_value, i),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                if (kDebugMode) {
                  print(snapshot.error);
                }
                return Center(
                  child: Text(
                    'Index Issue. Please contact admin.',
                    style: TextStyle(
                      fontFamily: font_family_name,
                      fontSize: 16.0,
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: Text('no chat found'),
                );
              }
            },
          ),
          (str_image_processing == '0')
              ? const SizedBox(
                  height: 0,
                )
              : Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.all(10.0),
                    // color: const Color.fromARGB(255, 232, 137, 202),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 232, 137, 202),
                      borderRadius: BorderRadius.circular(
                        14.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(
                            0,
                            3,
                          ), // changes position of shadow
                        ),
                      ],
                    ),
                    // width: 120, // MediaQuery.of(context).size.width,
                    height: 60.0,
                    child: Row(
                      children: const <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Align(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'processing...',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          // send message
          send_message_UI(),
          //
        ],
      ),
    );
  }

  Align right_side_UI(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> save_snapshot_value,
      int i) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(right: 10, left: 40, bottom: 10),
        decoration: const BoxDecoration(
          // 216 , 200 , 256
          color: Color.fromARGB(255, 238, 113, 196),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
            bottomLeft: Radius.circular(40),
          ),
        ),
        child: (save_snapshot_value[i]['type'].toString() == 'image')
            ? Container(
                margin: const EdgeInsets.all(8),
                width: 260,
                height: 260,
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
                  // color: Colors.amber[600],
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      40.0,
                    ),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: Image.network(
                    //
                    save_snapshot_value[i]['attachment_path'].toString(),
                    //
                    width: 110.0,
                    height: 110.0,
                    fit: BoxFit.fill,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(
                  16.0,
                ),
                child: Text(
                  //
                  save_snapshot_value[i]['message'].toString(),
                  //
                  style: TextStyle(
                    fontFamily: font_family_name,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }

  Align send_message_UI() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 20,
          left: 10,
          right: 10,
        ),
        child: Container(
          padding: const EdgeInsets.only(
            left: 10,
            bottom: 0,
            top: 0,
            right: 10,
          ),
          // height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(
              30,
            ),
          ),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  print('gesture deducted');
                  _showActionSheet_for_camera_gallery(context);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: TextField(
                  controller: cont_txt_send_message,
                  minLines: 1,
                  maxLines: 5,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    hintText: "Write message...",
                    hintStyle: TextStyle(
                      color: Colors.black54,
                      fontFamily: font_family_name,
                      fontSize: 16.0,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              FloatingActionButton(
                onPressed: () {
                  print('send button');
                  func_send_message(cont_txt_send_message.text.toString());
                  cont_txt_send_message.text = '';
                },
                child: Icon(
                  Icons.send,
                  color: Colors.black,
                  size: 18,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Align left_side_chat_UI(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> save_snapshot_value,
      int i) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 40, bottom: 10),
        // height: 40,
        // width: MediaQuery.of(context).size.width,

        decoration: const BoxDecoration(
          color: Color.fromRGBO(230, 230, 230, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: (save_snapshot_value[i]['type'].toString() == 'image')
            ? Container(
                margin: const EdgeInsets.all(8),
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.amber[600],
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      40.0,
                    ),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40.0),
                  child: Image.network(
                    //
                    save_snapshot_value[i]['attachment_path'].toString(),
                    //
                    width: 110.0,
                    height: 110.0,
                    fit: BoxFit.fill,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(
                  16.0,
                ),
                child: Text(
                  //
                  save_snapshot_value[i]['message'].toString(),
                  //
                  style: TextStyle(
                    fontFamily: font_family_name,
                    fontSize: 16.0,
                  ),
                ),
              ),
      ),
    );
  }

  // send message
  func_send_message(str_get_message) async {
    str_last_message = str_get_message.toString();
    // print(cont_txt_send_message.text);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CollectionReference users = FirebaseFirestore.instance.collection(
      'message/evs_cameroon_chat/one_to_one_chat',
    );

    users
        .add(
          {
            'sender_name': prefs.getString('fullName').toString(),
            'sender_image': '',
            'room_id': room_id.toString(),
            'sender_id': widget.str_get_login_user_id.toString(),
            'message': str_get_message.toString(),
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            'room': 'one_to_one',
            'type': 'text',
            'attachment_path': '',
            'users': [
              room_id,
              reverse_room_id,
            ],
          },
        )
        .then(
          (value) =>
              // print("Message send successfully. Message id is =====>${value.id}"));

              func_scroll_to_bottom(),
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }

  //
  void _showActionSheet_for_camera_gallery(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Camera option'),
        // message: const Text(''),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              // ignore: deprecated_member_use
              PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.camera,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              if (pickedFile != null) {
                setState(() {
                  print('camera');
                  imageFile = File(pickedFile.path);
                });
                //
                str_image_processing = '1';
                uploadImageToFirebase(context);
                //

                //
              }
            },
            child: Text(
              'Open Camera',
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);

              // ignore: deprecated_member_use
              PickedFile? pickedFile = await ImagePicker().getImage(
                source: ImageSource.gallery,
                maxWidth: 1800,
                maxHeight: 1800,
              );
              if (pickedFile != null) {
                setState(() {
                  print('gallery');
                  imageFile = File(pickedFile.path);
                });
                str_image_processing = '1';
                uploadImageToFirebase(context);
              }
            },
            child: Text(
              'Open Gallery',
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Dismiss',
              style: TextStyle(
                fontFamily: font_family_name,
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  func_add_image(str_attachment_path) async {
    // print(cont_txt_send_message.text);
    setState(() {
      str_image_processing = '0';
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    CollectionReference users = FirebaseFirestore.instance.collection(
      'message/evs_cameroon_chat/one_to_one_chat',
    );

    users
        .add(
          {
            'sender_name': prefs.getString('fullName').toString(),
            'sender_image': '',
            'room_id': room_id.toString(),
            'sender_id': widget.str_get_login_user_id.toString(),
            'message': '',
            'time_stamp': DateTime.now().millisecondsSinceEpoch,
            'room': 'one_to_one',
            'type': 'image',
            'attachment_path': str_attachment_path.toString(),
            'users': [
              room_id,
              reverse_room_id,
            ],
          },
        )
        .then(
          (value) =>
              // print("Message send successfully. Message id is =====>${value.id}"));
              func_scroll_to_bottom(),
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }

  // upload image via firebase
  Future uploadImageToFirebase(BuildContext context) async {
    if (kDebugMode) {
      print('dishu');
    }
    // String fileName = basename(imageFile_for_profile!.path);
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child(
          'upload',
        )
        .child(
          generateRandomString(10),
        );
    await storageRef.putFile(imageFile!);
    return await storageRef.getDownloadURL().then((value) => {
          // print(
          //   '======>$value',
          // )
          func_add_image(value)
        });
  }

  String generateRandomString(int lengthOfString) {
    final random = Random();
    const allChars =
        'AaBbCcDdlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1EeFfGgHhIiJjKkL234567890';
    // below statement will generate a random string of length using the characters
    // and length provided to it
    final randomString = List.generate(lengthOfString,
        (index) => allChars[random.nextInt(allChars.length)]).join();
    return randomString; // return the generated string
  }

  //
  func_save_last_message() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final resposne = await http.post(
      Uri.parse(
        application_base_url,
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'action': 'addchat',
          'userId': prefs.getInt('userId').toString(),
          'profileId': widget.str_get_friend_id.toString(),
          'message': str_last_message.toString(),
          // 'latitude': str_latitude.toString(),
          // 'longitude': str_longitude.toString(),
          // 'interent_in': prefs.getString('interent_in').toString(),
          // 'keyword': cont_search.text.toString(),
        },
      ),
    );

    // convert data to dict
    var get_data = jsonDecode(resposne.body);
    print(get_data);

    //

    //
    if (resposne.statusCode == 200) {
      if (get_data['status'].toString().toLowerCase() == 'success') {
      } else {
        print(
          '====> SOMETHING WENT WRONG IN "addcart" WEBSERVICE. PLEASE CONTACT ADMIN',
        );
      }
    } else {
      // return postList;
      print('something went wrong');
    }
  }
}
//
// send message

// 4000
// 1890
// 1890
// 2500
// 700
