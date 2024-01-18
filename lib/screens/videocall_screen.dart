import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chatify2/providers/auth.dart';
import 'package:chatify2/widgets/videocall/remote_videooff.dart';
import 'package:chatify2/widgets/videocall/toolbar_button.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

const appId="be2308d60e85411691e4198bb58003f0";
//temporary token

class VideoCallScreen extends StatefulWidget {
  VideoCallScreen(
    this.channel, {super.key}
  );
  var channel;
  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int? _remoteUid;
  bool? _localUserJoined=false;
  late RtcEngine _engine;
  var token;
  // var channel;
  bool isMicOn=true;
  bool isLocalVideoOn=true;
  bool isRemoteVideoOn=true;
  bool isFrontCam=true;
  bool isSpeakerOn=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initForAgora();
  }

  showMessage(text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void toggleAudio(){
    setState(() {
      isSpeakerOn=!isSpeakerOn;
    });

    _engine.muteAllRemoteAudioStreams(!isSpeakerOn);
  }

  void toggleMic(){
    setState(() {
      isMicOn=!isMicOn;
    });

    _engine.muteLocalAudioStream(!isMicOn);    
  }

  void toggleVideo(){
    setState(() {
      isLocalVideoOn=!isLocalVideoOn;
    });

    _engine.muteLocalVideoStream(!isLocalVideoOn);
  }

  void switchCam(){
    setState(() {
      isFrontCam=!isFrontCam;
    });
    
    _engine.switchCamera();                      
  }

  Future<String?> getToken({required String channelId}) async {
    try{
      final response=await http.get(Uri.parse("https://powerful-red-earthworm.cyclic.app/access_token?channelName=${widget.channel}"));
      final json=jsonDecode(response.body);
      return json["token"];
    }
    catch(err){
      debugPrint(err.toString());
      rethrow;
    }
  }

  Future<void> initForAgora() async {
    await [Permission.microphone,Permission.camera].request();
    token=await getToken(channelId: widget.channel);

    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined=true;
          });
          showMessage('Channel Joined');
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
          showMessage('Remote User Joined');
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
        onRemoteVideoStateChanged: (rtcConnection,remoteUid,videoState,reason,elapsed){
          if(videoState==RemoteVideoState.remoteVideoStateStopped){
            setState(() {
              isRemoteVideoOn=false;
            });
          }
          else if(videoState==RemoteVideoState.remoteVideoStateDecoding){
            setState(() {
              isRemoteVideoOn=true;
            });
          }
        }
      )
    );

    // String chatId=ModalRoute.of(context)!.settings.arguments.toString();
    // print(chatId);

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token, 
      channelId: widget.channel, 
      uid: 0, 
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication
      ),
    );
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<Auth>(context).userImageUrl);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: _renderRemoteVideo(),
          ),
          Align(
              alignment: const Alignment(0.9,0.6),
              child: _localUserJoined! ? 
                  _renderLocalPreview():
                  const CircularProgressIndicator(),
            ),
          Align(
            alignment: const Alignment(0,0.9),
            child: Container(
              height: 70,
              // width: MediaQuery.of(context).size.width*0.95,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 20,),
                  ToolbarButton(
                    iconOn: Icons.mic,
                    iconOff: Icons.mic_off,
                    isButtonOn: isMicOn,
                    onTapFunc: toggleMic,
                    ),  
                  const SizedBox(width: 15,),
                  ToolbarButton(
                    iconOn: Icons.flip_camera_ios,
                    iconOff: null,
                    isButtonOn: true,
                    onTapFunc: switchCam,
                    ),
                  const SizedBox(width: 15,),
                  GestureDetector(
                    onTap: (){
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.red,
                      ),
                      child: const Icon(
                        Icons.call_end,
                        size: 35,
                        color: Colors.white,
                        ),
                    ),
                  ),  
                  const SizedBox(width: 15,),
                  ToolbarButton(
                    iconOn: Icons.videocam,
                    iconOff: Icons.videocam_off,
                    isButtonOn: isLocalVideoOn,
                    onTapFunc: toggleVideo,
                    ),
                  const SizedBox(width: 15,),
                  ToolbarButton(
                    iconOn: Icons.volume_up_rounded,
                    iconOff: Icons.volume_off_rounded,
                    isButtonOn: isSpeakerOn,
                    onTapFunc: toggleAudio,
                    ),
                  const SizedBox(width: 20,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _renderRemoteVideo(){
    if (_remoteUid != null) {
      return isRemoteVideoOn ?
      AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channel),
        ),
      ):
      const RemoteVideoOff();
    } else {
      return const Center(
        child: Text(
          'Please wait for remote user to join',
          textAlign: TextAlign.center,
        ),
      );
    }
  }
  Widget _renderLocalPreview(){
   return Container(
     constraints: const BoxConstraints(
      minHeight: 150,
      maxHeight: 900,
      minWidth: 100,
      maxWidth: 600,
     ),
     height: 150,
     width: 100,
     decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(          
          blurRadius: 15,
          color: Colors.black.withOpacity(0.5),
          offset: const Offset(0, 0),
        ),
      ]
      // border: Border.all(
      //   color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      //   width: 2,
      // ),
     ),
     child: ClipRRect(
       borderRadius: BorderRadius.circular(18),
       child: isLocalVideoOn 
        ? AgoraVideoView(
          controller: VideoViewController(
            rtcEngine: _engine,
            canvas: const VideoCanvas(uid: 0),
            ),
          )
        : Image.network(
          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSN0Y47SWNtE4TRG2UhbZarFiP0gAXt_fivq9yp8muW18Uvy67eQQoi_bUEB6hq_Wti9Cs&usqp=CAU",
          fit: BoxFit.cover,
          ),
     ),
   );
  }
}

