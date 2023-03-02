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
      required this.str_device_token,
      this.get_receiver_data,
      required this.str_channel_name,
      required this.str_get_device_name});

  final get_receiver_data;
  final String str_friend_name;
  final String str_start_pick_end_call;
  final String str_friend_image;
  final String str_device_token;
  final String str_channel_name;
  final String str_get_device_name;

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

const String appId = "bbe938fe04a746fd9019971106fa51ff";

class _AudioCallScreenState extends State<AudioCallScreen> {
  //
  Timer? countdownTimer;
  var str_show_calling_text = 'none';
  //
  //for mute
  int volume = 50;
  bool _isMuted = false;
  //
  var str_volume = '0';
  //
  late Timer call_duration_timer;
  var str_save_timer = '00:00';
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

    print('======> rajputana');
    print(widget.str_device_token);

    if (kDebugMode) {
      print('rajputana');
      print(widget.get_receiver_data);
    }

    // onMuteChecked(bool value) {
    //   setState(() {
    //     _isMuted = value;
    //     agoraEngine.muteAllRemoteAudioStreams(_isMuted);
    //   });
    // }

    // onVolumeChanged(double newValue) {
    //   setState(() {
    //     volume = newValue.toInt();
    //     agoraEngine.adjustRecordingSignalVolume(volume);
    //   });
    // }

    //
    // join();
  }

  // String channelName = "dishu_1234";
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Checkbox(
              //   value: _isMuted,
              //   onChanged: (_isMuted) => {
              //     onMuteChecked(
              //       _isMuted!,
              //     ),
              //   },
              // ),
              // const Text("Mute"),
              // Expanded(
              //   child: Slider(
              //     min: 0,
              //     max: 100,
              //     value: volume.toDouble(),
              //     onChanged: (value) => {
              //       onVolumeChanged(
              //         value,
              //       ),
              //     },
              //   ),
              // ),
              //
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  color: Colors.transparent,
                  width: 120,
                  height: 48.0,
                  child: Center(
                    child: text_with_bold_style_black(
                      str_save_timer.toString(),
                    ),
                  ),
                ),
              ),
              (str_show_calling_text == 'remote_user_joined')
                  ? (str_volume == '0')
                      ? Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                str_volume = '1';
                                agoraEngine.adjustRecordingSignalVolume(100);
                              });
                            },
                            icon: const Icon(
                              Icons.volume_down_sharp,
                              // Icons.volume_off_rounded,
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                str_volume = '0';
                                agoraEngine.adjustRecordingSignalVolume(0);
                              });
                            },
                            icon: const Icon(
                              Icons.volume_off_rounded,
                            ),
                          ),
                        )
                  : const SizedBox(
                      height: 0,
                    ),

              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              //
            ],
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
                        // callOnFcmApiSendPushNotifications(
                        //   widget.str_device_token.toString(),
                        // );
                        send_notification();
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
    //
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
          //
          func_start_call_timer();
          //
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          // showMessage("Remote user uid:$remoteUid left the channel");
          if (kDebugMode) {
            print("Remote user uid:$remoteUid left the channel");
          }
          //
          call_duration_timer.cancel();
          //
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
      channelId: widget.str_channel_name.toString(),
      options: options,
      uid: uid,
    );
  }

//
  void leave() {
    call_duration_timer.cancel();

    // print(call_duration_timer);
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

  send_notification() async {
    if (kDebugMode) {
      print('=====> POST : SEND AUDIO CALL NOTIFICATION');

      print('DISHANT RAJPUT');
      print(widget.str_get_device_name);
      print(widget.str_device_token);
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
          'Receiver_device': widget.get_receiver_data['device'].toString(),
          'Receiver_deviceToken':
              widget.get_receiver_data['deviceToken'].toString(),
          'message': 'Audio calling...',
          'channel': widget.str_channel_name.toString(),
          'name': prefs.getString('fullName').toString(),
          'image': prefs.getString('image').toString(),
          'deviceToken': prefs.getString('deviceToken').toString(),
          'device': 'iOS',
          'type': 'audioCall',
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
      if (kDebugMode) {
        print('something went wrong');
      }
    }
  }

  //
  onMuteChecked(bool value) {
    setState(() {
      _isMuted = value;
      agoraEngine.muteAllRemoteAudioStreams(_isMuted);
    });
  }

  onVolumeChanged(double newValue) {
    setState(() {
      volume = newValue.toInt();
      agoraEngine.adjustRecordingSignalVolume(volume);
    });
  }

  //
  func_start_call_timer() {
    call_duration_timer =
        Timer.periodic(const Duration(seconds: 1), (call_duration_timer) {
      //
      // print(t.tick);
      // if (call_duration_timer.tick == 20) {

      // }

      int sec = call_duration_timer.tick % 60;
      if (kDebugMode) {
        // print(sec);
      }
      int min = (call_duration_timer.tick / 60).floor();
      if (kDebugMode) {
        // print(min);
      }
      //
      String minute = min.toString().length <= 1 ? "0$min" : "$min";
      String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
      if (kDebugMode) {
        print("$minute : $second");
      }
      //
      str_save_timer = "$minute : $second";
      setState(() {});
    });
  }
  //
}
