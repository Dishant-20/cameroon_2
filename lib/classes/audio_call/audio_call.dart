// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
// import 'dart:html';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen(
      {super.key,
      required this.str_start_pick_end_call,
      required this.str_friend_image,
      required this.str_friend_name,
      required this.str_device_token});

  final String str_friend_name;
  final String str_start_pick_end_call;
  final String str_friend_image;
  final String str_device_token;

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

const String appId = "bbe938fe04a746fd9019971106fa51ff";

class _AudioCallScreenState extends State<AudioCallScreen> {
  //
  Timer? countdownTimer;
  var str_show_calling_text = 'none';
  //
  @override
  void initState() {
    super.initState();
    // Set up an instance of Agora engine

    // print("Friend's Image ========> ${widget.str_friend_image}");
    // print(str_show_calling_text);
    if (mounted) {
      setupVoiceSDKEngine();
    }

    //
    // join();
  }

  String channelName = "dishu_1234";
  String token = "";

  int uid = 0; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance

  //
  var str_call_tags = 'start_call';
  //
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // if get_a_call
          const SizedBox(
            height: 60,
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: 48.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  (str_call_tags == 'end_call')
                      ? const SizedBox(
                          height: 0,
                        )
                      : IconButton(
                          onPressed: () {
                            if (kDebugMode) {
                              print('');
                            }
                            // countdownTimer!.cancel();
                            //
                            agoraEngine.release();
                            Navigator.pop(context);
                            //
                          },
                          icon: const Icon(
                            Icons.chevron_left,
                          ),
                        ),
                  //
                  Center(child: _status()),
                ],
              ),
              /*IconButton(
                      onPressed: () {
                        if (kDebugMode) {
                          // print(_status());
                          _status();
                        }
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.chevron_left,
                      ),
                    ),*/
            ),
          ),
          //
          // const Spacer(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              // height: 48.0,
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (widget.str_friend_image == '')
                          ? Container(
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(
                                  70,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  func_get_initials(
                                    widget.str_friend_name.toString(),
                                  ),
                                  style: TextStyle(
                                    fontFamily: font_family_name,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          : CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(
                                widget.str_friend_image.toString(),
                              ),
                            ),
                      //
                      const SizedBox(
                        height: 20,
                      ),
                      text_with_bold_style_black(
                        widget.str_friend_name.toString(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // _status(),
                      (str_show_calling_text == 'none')
                          ? Text(
                              '...',
                              style: TextStyle(
                                fontFamily: font_family_name,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            )
                          : (str_show_calling_text ==
                                  'remote_user_disconnected')
                              ? Text(
                                  'call ended',
                                  style: TextStyle(
                                    fontFamily: font_family_name,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                )
                              : (str_show_calling_text == 'remote_user_joined')
                                  ? Text(
                                      'JOINED',
                                      style: TextStyle(
                                        fontFamily: font_family_name,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    )
                                  : Text(
                                      'calling...',
                                      style: TextStyle(
                                        fontFamily: font_family_name,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //
          if (widget.str_start_pick_end_call == 'make_a_call') ...[
            Center(
              child: (str_call_tags == 'start_call')
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          str_call_tags = 'end_call';
                          str_show_calling_text = 'remote_user_disconnected';
                        });
                        //

                        join();
                        //
                        callOnFcmApiSendPushNotifications(
                          widget.str_device_token.toString(),
                        );
                        //
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10.0),

                        // width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Start Call',
                            style: TextStyle(
                              fontFamily: font_family_name,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        setState(() {
                          str_call_tags = 'start_call';
                          str_show_calling_text = 'none';
                        });
                        // countdownTimer!.cancel();
                        leave();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10.0),

                        // width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'End Call',
                            style: TextStyle(
                              fontFamily: font_family_name,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ] else ...[
            Center(
              child: (str_call_tags == 'start_call')
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          str_call_tags = 'end_call';
                          str_show_calling_text = 'remote_user_disconnected';
                        });
                        //

                        join();
                        //
                        // callOnFcmApiSendPushNotifications(
                        //   widget.str_device_token.toString(),
                        // );
                        //
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10.0),

                        // width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Accept',
                            style: TextStyle(
                              fontFamily: font_family_name,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        setState(() {
                          str_call_tags = 'start_call';
                          str_show_calling_text = 'none';
                        });
                        // countdownTimer!.cancel();
                        leave();
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10.0),

                        // width: MediaQuery.of(context).size.width,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'End Call',
                            style: TextStyle(
                              fontFamily: font_family_name,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
            /*Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      // str_start_pick_end_call
                      setState(() {
                        str_call_tags = 'end_call';
                        str_show_calling_text = 'remote_user_disconnected';
                      });
                      //

                      join();
                      // leave();
                      //
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10.0),

                      // width: 48.0,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(
                          14.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Accept',
                          style: TextStyle(
                            fontFamily: font_family_name,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                //
                /*Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        str_call_tags = 'start_call';
                        str_show_calling_text = 'none';
                      });
                      // countdownTimer!.cancel();
                      leave();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10.0),

                      // width: 48.0,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(
                          14.0,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Decline',
                          style: TextStyle(
                            fontFamily: font_family_name,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),*/
                //
              ],
            )*/
          ],
          /*Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  child: const Text("Join"),
                  onPressed: () => {
                    join(),
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  child: const Text("Leave"),
                  onPressed: () => {
                    leave(),
                  },
                ),
              ),
            ],
          ),*/
          //
          const SizedBox(
            height: 30,
          ),
          //
        ],
      ),
    );
  }

  //
  Widget _status() {
    String statusText;

    if (!_isJoined) {
      // statusText = 'click Start Call to start a call';
      //
      statusText = '';
      //
    } else if (_remoteUid == null) {
      //
      // statusText = 'calling...';
      statusText = '';
      // if (mounted) {
      //   setState(() {
      //     str_show_calling_text = '2';
      //   });
      // }
      //
    } else {
      // statusText = 'Connected to remote user, uid:$_remoteUid';
      statusText = '';
      if (kDebugMode) {
        print(
          'TIMER HAS BEEN STOPPED',
        );
      }
      // countdownTimer!.cancel();
    }

    return Text(
      statusText,
    );
  }

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        print('object');
        // randomNote = Random().nextInt(6);
        // randomType = Random().nextInt(6);
      });
    });
  }

//
  Future<void> setupVoiceSDKEngine() async {
    // retrieve or request microphone permission
    await [Permission.microphone].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

//
    // agoraEngine.setEnableSpeakerphone(false);
    // agoraEngine.muteLocalAudioStream(true);
    // agoraEngine.isSpeakerphoneEnabled();
//
    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          // showMessage(
          // "Local user uid:${connection.localUid} joined the channel");
          if (kDebugMode) {
            print("Local user uid:${connection.localUid} joined the channel");
          }
          setState(() {
            // str_show_calling_text = 'remote_user_joined';
            str_show_calling_text = 'you_calling';
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          // showMessage("Remote user uid:$remoteUid joined the channel");
          if (kDebugMode) {
            print("Remote user uid:$remoteUid joined the channel");
          }

          setState(() {
            str_show_calling_text = 'remote_user_joined';
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          // showMessage("Remote user uid:$remoteUid left the channel");
          if (kDebugMode) {
            print("Remote user uid:$remoteUid left the channel");
          }

          setState(() {
            str_show_calling_text = 'remote_user_disconnected';
            _remoteUid = null;
          });
        },
      ),
    );
  }

  //
  void join() async {
    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
  }

//
  void leave() {
    // countdownTimer!.cancel();
    if (mounted) {
      setState(() {
        _isJoined = false;
        _remoteUid = null;
      });
    }

    agoraEngine.leaveChannel();
    //
    // Navigator.pop(context);
  }

//
// Clean up the resources when you leave
  @override
  void dispose() async {
    // countdownTimer!.cancel();
    if (mounted) {
      // countdownTimer!.cancel();
      await agoraEngine.leaveChannel();
    }
    agoraEngine.release();
    super.dispose();
  }

  //
  func_get_initials(String str_name) {
    var initials_are = str_name.split(' ');

    var final_initial_name = '';
    // print(initials_are.length);
    if (initials_are.length == 1) {
      final_initial_name = initials_are[0][0].toString().toUpperCase();
    } else if (initials_are.length == 2) {
      final_initial_name =
          (initials_are[0][0] + initials_are[1][0]).toString().toUpperCase();
    } else {
      final_initial_name = initials_are[0][0].toString().toUpperCase();
    }
    return final_initial_name;
  }
  //

  Future<bool> callOnFcmApiSendPushNotifications(userToken) async {
    //
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //
    const postUrl = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "notification": {
        "body": "Incoming audio call",
        "title": prefs.getString('fullName').toString(),
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "caller_name": prefs.getString('fullName').toString(),
        "caller_image": prefs.getString('image').toString(),
      },
      "to": userToken.toString()
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization':
          'key=AAAAm1_Oyvs:APA91bGmD8w-C_3htA9YwjSm1Cwacf0TAMXBeb4ozIqraw3odUjHBfCag4NL9iMmOYHWMYiyxruGE7vYXMscRjzxXmNNlOZLJrgCKynQpWUM7dmf9Le_EJnbgrgQa5LhxwIjrVHgu7a1'
    };

    final response = await http.post(Uri.parse(postUrl),
        body: json.encode(data),
        encoding: Encoding.getByName('utf-8'),
        headers: headers);

    if (response.statusCode == 200) {
      // on success do sth
      print('test ok push CFM');
      return true;
    } else {
      print(' CFM error');
      // on failure do sth
      return false;
    }
  }
}
