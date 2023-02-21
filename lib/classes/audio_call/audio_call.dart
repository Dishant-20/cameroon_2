// ignore_for_file: unused_field, prefer_final_fields, non_constant_identifier_names
/*
import 'dart:async';

import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen(
      {super.key,
      required this.str,
      required this.str_friend_name,
      required this.str_channel_name});

  final String str;
  final String str_friend_name;
  final String str_channel_name;

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  String token = "";

  int uid = 0; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance
  //
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>(); // Global key to access the scaffold

  //
  String appId = "bbe938fe04a746fd9019971106fa51ff";
  //
  var str_start_timer = 'calling...';
  //
  // showMessage(String message) {
  //   scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
  //     content: Text(message),
  //   ));
  // }

  //
  // late Timer _timer;
  // int _start = 10;
  //
  String time = "";
  //
  var str_end_call_button_status = '0';
  //
  @override
  void initState() {
    super.initState();
    // if (mounted) {
    setupVoiceSDKEngine();
    // }
    //

    // Timer scheduleTimeout([int milliseconds = 4]) =>
    // Timer(Duration(seconds: milliseconds), handleTimeout);
  }

  // void handleTimeout() {
  //   // callback function
  //   // Do some work.
  //   print('timer');
  // }

  // Clean up the resources when you leave
  /*@override
  void dispose() {
    /*await agoraEngine.leaveChannel().then((value) => {
          Navigator.pop(context),
        });*/
    // await agoraEngine.leaveChannel();

    dispose();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          //
          'Audio Call',
          //
          style: TextStyle(
            fontFamily: font_family_name,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            if (kDebugMode) {
              print('');
            }
            Navigator.of(context).pop();
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
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: 40,
            child: Center(
              child: // Text('dishu'),
                  _status(),
            ),
          ),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                const SizedBox(
                  height: 75,
                ), // This container is needed only to set the overall stack height
                // for Text to be a bit below Circleavatar
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ),
                  height: 160.0,
                  width: 160.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      80,
                    ),
                    color: Colors.greenAccent,
                    border: Border.all(
                      width: 4,
                      color: Colors.white,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      //
                      func_get_initials(
                        widget.str_friend_name.toString(),
                      ),
                      //
                      style: TextStyle(
                        fontFamily: font_family_name,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        //
                        widget.str_friend_name.toString(),
                        //
                        style: TextStyle(
                          fontFamily: font_family_name,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: 60,
              ),
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(
                  40,
                ),
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        leave();
                      },
                      child: Container(
                        height: 50,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'end call',
                            style: TextStyle(
                              fontFamily: font_family_name,
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      /*
                      (str_end_call_button_status == '0')
                          ? Container(
                              height: 50,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(
                                  16.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'call',
                                  style: TextStyle(
                                    fontFamily: font_family_name,
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 50,
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(
                                  16.0,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'end call',
                                  style: TextStyle(
                                    fontFamily: font_family_name,
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),*/
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Container(
                      height: 40,
                      width: 120,
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          // 'calling...',
                          //
                          // str_start_timer,
                          '',
                          // time,
                          //
                          //
                          style: TextStyle(
                            fontFamily: font_family_name,
                            fontSize: 22.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  // Expanded(
                  //   child: Container(
                  //     height: 40,
                  //     width: 120,
                  //     color: Colors.blueGrey,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // for status
  Widget _status() {
    var statusText;

    if (kDebugMode) {
      print('=====> dishant rajput <=====');
    }
    if (kDebugMode) {
      print(statusText);
    }

    if (!_isJoined) {
      //
      statusText = 'call ended';
      //
    } else if (_remoteUid == null) {
      // statusText = 'Waiting for a remote user to join...';
      //
      str_start_timer = '${widget.str.toUpperCase()} disconnect the call';
      //
      statusText =
          'calling...'; //'${widget.str.toUpperCase()} disconnect the call';
    } else {
      statusText = '${widget.str.toUpperCase()} on call';
    }
    //
    str_start_timer = 'Joined';
    //
    // func_call_timer();

    return Text(
      statusText,
    );
  }

  // audio engine engine
  Future<void> setupVoiceSDKEngine() async {
    // retrieve or request microphone permission
    await [Permission.microphone].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(RtcEngineContext(appId: appId));

    Timer(Duration(seconds: 3), () {
      //checkFirstSeen(); your logic
      print('5 seconds done');
      join();
    });

    // Register the event handler
    agoraEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          // showMessage(
          //     "Local user uid:${connection.localUid} joined the channel");
          // "Dishu Join",
          // );
          if (kDebugMode) {
            print('JOINED');
          }
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          if (kDebugMode) {
            print('======> IS USER JOINED ?');
          }
          // showMessage("Remote user uid:$remoteUid joined the channel");
          if (kDebugMode) {
            print("Remote user uid:$remoteUid joined the channel");
          }
          setState(() {
            // str_start_timer = '1';
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
            _remoteUid = null;
          });
        },
      ),
    );
  }

  // join
  void join() {
    if (kDebugMode) {
      print('=====> IS USER JOIN ? ');
    }
    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    agoraEngine.joinChannel(
      token: token,
      // channelId: widget.str_channel_name.toString(),
      channelId: 'dishu_1234'.toString(),
      options: options,
      uid: uid,
    );
  }

// leave
  void leave() {
    // if (mounted) {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
    /*.then((value) => {
          Navigator.pop(context),
        });*/
    // }
  }

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
}
*/

import 'dart:async';
// import 'dart:html';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen(
      {super.key,
      required this.str_start_pick_end_call,
      required this.str_friend_image,
      required this.str_friend_name});

  final String str_friend_name;
  final String str_start_pick_end_call;
  final String str_friend_image;

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

    print("Friend's Image ========> ${widget.str_friend_image}");
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
}
