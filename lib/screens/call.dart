// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:call/utils/settings.dart';
// import 'package:flutter/material.dart';

// class CallPage extends StatefulWidget {
//   final String channelName;
//   final ClientRoleType role;

//   const CallPage({
//     super.key,
//     required this.channelName,
//     required this.role,
//   });

//   @override
//   State<CallPage> createState() => _CallPageState();
// }

// class _CallPageState extends State<CallPage> {
//   final _users = <int>[];
//   final _infoStrings = <String>[];
//   bool muted = false;
//   bool viewPanel = false;
//   late RtcEngine _engine;

//   @override
//   void initState() {
//     super.initState();
//     initialize();
//   }

//   @override
//   void dispose() {
//     _users.clear();
//     _engine.leaveChannel();
//     _engine.release();
//     super.dispose();
//   }

//   Future<void> initialize() async {
//     try {
//       await _engine.leaveChannel();
      
//       _engine = createAgoraRtcEngine();
//       await _engine.initialize(const RtcEngineContext(
//         appId: appId,
//         channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//       ));

//       await _engine.enableVideo();
//       await _engine.setClientRole(role: widget.role);
//       _addAgoraEventHandlers();

//       await _engine.setVideoEncoderConfiguration(
//         const VideoEncoderConfiguration(
//           dimensions: VideoDimensions(width: 1920, height: 1080),
//         ),
//       );

//       await _engine.joinChannel(
//         token: token,
//         channelId: widget.channelName,
//         uid: 0,
//         options: ChannelMediaOptions(
//           clientRoleType: widget.role,
//           channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
//         ),
//       );
//     } catch (e) {
//       _infoStrings.add('Error initializing: ${e.toString()}');
//       rethrow;
//     }
//   }

//   void _addAgoraEventHandlers() {
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onError: (err, msg) {
//           setState(() {
//             final info = "error:$msg";
//             _infoStrings.add(info);
//           });
//         },
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           setState(() {
//             _infoStrings.add('Join Channel Success');
//           });
//         },
//         onLeaveChannel: (connection, stats) {
//           setState(() {
//             _infoStrings.add('Leave channel:${connection.channelId}');
//             _users.clear();
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           setState(() {
//             _users.add(remoteUid);
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
//           setState(() {
//             _users.remove(remoteUid);
//           });
//         },
//         onFirstRemoteVideoFrame: (connection, uid, width, height, elapsed) {
//           setState(() {
//             final info = "first remote video frame $uid  $width*$height";
//             _infoStrings.add(info);
//           });
//         },
//       ),
//     );
//   }

//   Widget _viewRows() {
//     final List<StatefulWidget> lists = [];
    
//     if (widget.role == ClientRoleType.clientRoleBroadcaster) {
//       lists.add(AgoraVideoView(
//         controller: VideoViewController(
//           rtcEngine: _engine,
//           canvas: const VideoCanvas(uid: 0),
//         ),
//       ));
//     }
    
//     for (var uid in _users) {
//       lists.add(AgoraVideoView(
//         controller: VideoViewController(
//           rtcEngine: _engine,
//           canvas: VideoCanvas(uid: uid),
//         ),
//       ));
//     }
    
//     final views = lists;
//     return Column(
//       children: List.generate(
//         views.length,
//         (index) => Expanded(child: views[index]),
//       ),
//     );
//   }

//   Widget _toolbar() {
//     if (widget.role == ClientRoleType.clientRoleAudience) {
//       return const SizedBox();
//     }
//     return Container(
//         alignment: Alignment.bottomCenter,
//         padding: const EdgeInsets.symmetric(vertical: 48),
//         child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//           RawMaterialButton(
//             onPressed: () {
//               setState(() {
//                 muted = !muted;
//               });
//               _engine.muteLocalAudioStream(muted);
//             },
//             shape: const CircleBorder(),
//             elevation: 2.0,
//             fillColor: muted ? Colors.red : Colors.white,
//             padding: const EdgeInsets.all(12),
//             child: Icon(
//               muted ? Icons.mic_off : Icons.mic,
//               color: muted ? Colors.white : Colors.red,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 16),
//           RawMaterialButton(
//             onPressed: () => Navigator.pop(context),
//             shape: const CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.red,
//             padding: const EdgeInsets.all(15),
//             child: const Icon(
//               Icons.call_end,
//               color: Colors.white,
//               size: 35,
//             ),
//           ),
//           RawMaterialButton(
//             onPressed: () {
//               setState(() {
//                 _engine.switchCamera();
//               });
//             },
//             shape: const CircleBorder(),
//             elevation: 2.0,
//             fillColor: Colors.white,
//             padding: const EdgeInsets.all(12),
//             child: const Icon(
//               Icons.switch_camera,
//               color: Colors.black,
//               size: 20,
//             ),
//           )
//         ]));
//   }

//   Widget _panel() {
//     return Visibility(
//         visible: viewPanel,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 48),
//           alignment: Alignment.bottomCenter,
//           child: FractionallySizedBox(
//               heightFactor: .5,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 48),
//                 child: ListView.builder(
//                     reverse: true,
//                     itemCount: _infoStrings.length,
//                     itemBuilder: (context, index) {
//                       if (_infoStrings.isEmpty) {
//                         return const Text("null");
//                       }
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 3,
//                           horizontal: 10,
//                         ),
//                         child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: <Widget>[
//                               Flexible(
//                                   child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                     vertical: 2, horizontal: 5),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey[300],
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Text(
//                                   _infoStrings[index],
//                                   style: const TextStyle(
//                                       fontSize: 15, color: Colors.white),
//                                 ),
//                               ))
//                             ]),
//                       );
//                     }),
//               )),
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Call Page'),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 setState(() {
//                   viewPanel = !viewPanel;
//                 });
//               },
//               icon: const Icon(Icons.info_outline))
//         ],
//       ),
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Stack(children: [_viewRows(), _panel(), _toolbar()]),
//       ),
//     );
//   }
// }
