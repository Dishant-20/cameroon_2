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
      body: ListView(
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
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  onPressed: _isJoined ? null : () => {join()},
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
      ),
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
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          setState(() {
            _remoteUid = null;
          });
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
          'Receiver_deviceToken':
              // widget.get_receiver_data['deviceToken'].toString(),
              'ffKEmMiYQcejA8XFNKAePh:APA91bEtVZU-4tHltFsmA3dz8zUP8Sv1BB14UH0cZVaNAWLiHyEULkTw7I1JbfS-DEMfrRpN5sZVd62ANRXdOaUI3QfYrqRKNVkAZoA6oZosHYhLMSh5Hi_1YXcx1W7DED-f_FdsZcoy',
          'message': 'Video calling...',
          'channel': widget.str_channel_name.toString(),
          'name': prefs.getString('fullName').toString(),
          'image': prefs.getString('image').toString(),
          'deviceToken': 'my_token',
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
      print('something went wrong');
    }
  }
}
