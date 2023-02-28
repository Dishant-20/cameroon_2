// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cameroon_2/classes/header/utils/Utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String appId = "bbe938fe04a746fd9019971106fa51ff";

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen(
      {super.key,
      required this.str_from_notification,
      required this.str_channel_name,
      required this.str_friend_device_token});

  final String str_from_notification;
  final String str_channel_name;
  final String str_friend_device_token;
  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  //
  // var str_which_profile = '';
  // String channelName = "dishu_1234";
  String token = "";

  int uid = 0; // uid of the local user

  int? _remoteUid; // uid of the remote user
  bool _isJoined = false; // Indicates if the local user has joined the channel
  late RtcEngine agoraEngine; // Agora engine instance
  //
  var str_click_call_button_status = '0';
  //
  var str_mute_unmute_audio = '0';
  var str_hide_unhide_local_video = '0';
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
  void initState() {
    super.initState();
    // Set up an instance of Agora engine
    if (mounted) {
      setupVideoSDKEngine();
    }
  }

// Clean up the resources when you leave
  @override
  void dispose() async {
    // if (mounted)
    await agoraEngine.leaveChannel();
    //
    agoraEngine.release();
    //
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          //
          'Video Call',
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
            //
            agoraEngine.release();
            //
            Navigator.pop(context);
            //
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
        children: [
          Container(
            // margin: const EdgeInsets.all(10.0),
            color: const Color.fromARGB(255, 220, 219, 219),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: _remoteVideo(), // receiver screen
            ),
          ),
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(
                    14,
                  ),
                ),
                child: Center(
                  child: _localPreview(), // my camera
                ),
              ),
            ],
          ),
          //
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 40,
                left: 20,
                right: 20,
              ),
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  14,
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
              //
              // str_click_call_button_status
              //
              child: Row(
                children: [
                  InkWell(
                    onTap: (_isJoined == false)
                        ? () {
                            if (kDebugMode) {
                              print('call hit');
                              print(_isJoined);
                            }
                            //
                            join();
                            //
                            // agoraEngine.switchCamera();
                            //
                            send_notification();
                            //
                            //
                          }
                        : () {
                            if (kDebugMode) {
                              print('end call hit');
                              print(_isJoined);
                            }
                            //
                            leave();
                            //
                          },
                    child: (_isJoined == false)
                        ? Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            width: 120,
                            height: 48.0,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(
                                24,
                              ),
                            ),
                            child: Align(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: (widget.str_from_notification == 'yes')
                                    ? text_with_bold_style(
                                        'Accept',
                                      )
                                    : text_with_bold_style(
                                        'Call',
                                      ),
                              ),
                            ),
                          )
                        : Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            width: 120,
                            height: 48.0,
                            decoration: (_isJoined == false)
                                ? BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(
                                      24,
                                    ),
                                  )
                                : BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(
                                      24,
                                    ),
                                  ),
                            child: Align(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: (widget.str_from_notification == 'yes')
                                    ? text_with_bold_style(
                                        'Accept',
                                      )
                                    : text_with_bold_style(
                                        'End call',
                                      ),
                              ),
                            ),
                          ),
                  ),
                  // SWITCH CAMERA
                  Container(
                    margin: const EdgeInsets.only(left: 20.0),
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        22,
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
                    child: IconButton(
                      onPressed: () {
                        if (kDebugMode) {
                          print('camera switch hit');
                        }
                        //
                        agoraEngine.switchCamera();
                        //
                      },
                      icon: const Icon(
                        Icons.flip_camera_ios_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  //
                  // MUTE / UNMUTE
                  InkWell(
                    onTap: () {
                      if (kDebugMode) {
                        print('object');
                      }
                      //
                      (str_mute_unmute_audio == '0')
                          ? func_mute_unmute_local_user_audio(
                              true) // mute audio
                          : func_mute_unmute_local_user_audio(
                              false); // unmute audio
                      //
                      setState(() {
                        if (kDebugMode) {
                          print(str_mute_unmute_audio);
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          22,
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
                      child: (str_mute_unmute_audio == '0')
                          ? const Icon(
                              Icons.mic,
                              color: Colors.black,
                            )
                          : const Icon(
                              Icons.mic_off_rounded,
                              color: Colors.black,
                            ),
                    ),
                  ),
                  // HIDE / UNHIDE LOCAL CAMERA
                  InkWell(
                    onTap: () {
                      (str_hide_unhide_local_video == '0')
                          ? func_hide_unhide_local_user_camera(
                              true) // mute audio
                          : func_hide_unhide_local_user_camera(
                              false); // unmute audio
                      //
                      setState(() {
                        if (kDebugMode) {
                          print(str_hide_unhide_local_video);
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(
                          22,
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
                      child: (str_hide_unhide_local_video == '0')
                          ? const Icon(
                              Icons.camera_alt_sharp,
                              color: Colors.black,
                            )
                          : const Icon(
                              Icons.camera_alt_sharp,
                              color: Colors.red,
                            ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      /*ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        children: [
          // Container for the local video
          Container(
            height: 240,
            decoration: BoxDecoration(border: Border.all()),
            child: Center(child: _localPreview()),
          ),
          const SizedBox(height: 10),
          //Container for the Remote video
          Container(
            height: 240,
            decoration: BoxDecoration(border: Border.all()),
            child: Center(child: _remoteVideo()),
          ),
          // Button Row
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: _isJoined
                      ? null
                      : () => {
                            join(),
                            //
                            send_notification(),
                            //
                          },
                  child: (widget.str_from_notification == 'yes')
                      ? const Text(
                          "Accept",
                        )
                      : const Text(
                          "Call",
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isJoined ? () => {leave()} : null,
                  child: const Text(
                    "End call",
                  ),
                ),
              ),
            ],
          ),
          // Button Row ends
        ],
      ),*/
    );
  }

  // Display local video preview
  Widget _localPreview() {
    if (_isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: uid),
        ),
      );
    } else {
      return const Text(
        'Click call to connect',
        textAlign: TextAlign.center,
      );
    }
  }

// Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection:
              RtcConnection(channelId: widget.str_channel_name.toString()),
        ),
      );
    } else {
      String msg = '';
      if (_isJoined) msg = 'calling...';
      return Text(
        msg,
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> setupVideoSDKEngine() async {
    // retrieve or request camera and microphone permissions
    await [Permission.microphone, Permission.camera].request();

    //create an instance of the Agora engine
    agoraEngine = createAgoraRtcEngine();
    await agoraEngine.initialize(const RtcEngineContext(appId: appId));

    await agoraEngine.enableVideo();

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
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          // showMessage("Remote user uid:$remoteUid joined the channel");
          if (kDebugMode) {
            print("Remote user uid:$remoteUid joined the channel");
          }
          setState(() {
            _remoteUid = remoteUid;
            // _isJoined = true;
          });
          // leave();
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");

          if (kDebugMode) {
            print("Remote user uid:$remoteUid left the channel");
          }

          setState(() {
            _remoteUid = null;
          });
          //
          leave();
          // setState(() {
          // _isJoined = true;
          // });
          //
        },
      ),
    );
  }

  void join() async {
    await agoraEngine.startPreview();

    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );

    await agoraEngine.joinChannel(
      token: token,
      channelId: widget.str_channel_name.toString(),
      options: options,
      uid: uid,
    );
  }

  void leave() {
    setState(() {
      _isJoined = false;
      _remoteUid = null;
    });
    agoraEngine.leaveChannel();
    // agoraEngine.release();
  }

  //
  send_notification() async {
    if (kDebugMode) {
      print('=====> POST : MY PROFILE LIST');
    }

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
          'action': 'notitest',
          'Receiver_device':
              'iOS', //widget.get_receiver_data['device'].toString(),
          'Receiver_deviceToken': widget.str_friend_device_token.toString(),
          // 'ffKEmMiYQcejA8XFNKAePh:APA91bEtVZU-4tHltFsmA3dz8zUP8Sv1BB14UH0cZVaNAWLiHyEULkTw7I1JbfS-DEMfrRpN5sZVd62ANRXdOaUI3QfYrqRKNVkAZoA6oZosHYhLMSh5Hi_1YXcx1W7DED-f_FdsZcoy',
          'message': 'Video calling...',
          'channel': widget.str_channel_name.toString(),
          'name': prefs.getString('fullName').toString(),
          'image': prefs.getString('image').toString(),
          'deviceToken': 'my_token',
          'device': 'iOS',
          'type': 'videoCall',
        },
      ),
    );

    // convert data to dict
    var get_data = jsonDecode(resposne.body);
    if (kDebugMode) {
      print(get_data);
    }

    if (resposne.statusCode == 200) {
      if (get_data['status'].toString().toLowerCase() == 'success') {
        //

        //
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

  //
  func_mute_unmute_local_user_audio(bool audio_stream_status) {
    if (audio_stream_status == true) {
      str_mute_unmute_audio = '1';
    } else {
      str_mute_unmute_audio = '0';
    }

    agoraEngine.muteLocalAudioStream(audio_stream_status);
  }

  // hide unhide local video camera
  func_hide_unhide_local_user_camera(bool video_stream_status) {
    if (kDebugMode) {
      print('HIDE UNHIDE LOCAL VIDEO');
    }
    if (video_stream_status == true) {
      str_hide_unhide_local_video = '1';
    } else {
      str_hide_unhide_local_video = '0';
    }
    //
    agoraEngine.muteLocalVideoStream(video_stream_status);
    //
  }
}
