// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';

// class IndexPage extends StatefulWidget {
//   const IndexPage({super.key});

//   @override
//   State<IndexPage> createState() => _IndexPageState();
// }

// class _IndexPageState extends State<IndexPage> {
//   final _channelController = TextEditingController();
//   bool _validateError = false;
//   ClientRoleType _role = ClientRoleType.clientRoleBroadcaster;

//   @override
//   void dispose() {
//     _channelController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Index Page'),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//             padding: const EdgeInsets.all(20),
//             child: Column(children: [
//               const SizedBox(
//                 height: 50,
//               ),
//               Image.network("https://tinyurl.com/2p889y4k"),
//               const SizedBox(
//                 height: 20,
//               ),
//               TextField(
//                 controller: _channelController,
//                 decoration: InputDecoration(
//                   labelText: 'Channel Name',
//                   border: const OutlineInputBorder(),
//                   errorText:
//                       _validateError ? 'Please enter a channel name' : null,
//                 ),
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               RadioListTile(
//                 title: const Text('Broadcaster'),
//                 value: ClientRoleType.clientRoleBroadcaster,
//                 groupValue: _role,
//                 onChanged: (ClientRoleType? value) {
//                   setState(() {
//                     _role = value!;
//                   });
//                 },
//               ),
//               RadioListTile(
//                 title: const Text('Audience'),
//                 value: ClientRoleType.clientRoleAudience,
//                 groupValue: _role,
//                 onChanged: (ClientRoleType? value) {
//                   setState(() {
//                     _role = value!;
//                   });
//                 },
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               ElevatedButton(
//                 onPressed: onJoin,
//                 child: const Text('Join Channel'),
//               ),
//             ])),
//       ),
//     );
//   }

//   Future<void> onJoin() async {
//     setState(() {
//       _channelController.text.isEmpty
//           ? _validateError = true
//           : _validateError = false;
//     });
//     if (_channelController.text.isNotEmpty) {
//       await _handleCameraAndMic(Permission.camera);
//       await _handleCameraAndMic(Permission.microphone);
//       await Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => CallPage(
//                     channelName: _channelController.text,
//                     role: _role,
//                   )));
//     }
//   }

//   Future<void> _handleCameraAndMic(Permission permission) async {
//     final status = await permission.request();
//     if (status.isDenied) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text('${permission.toString()} permission is required')),
//       );
//       throw Exception('Permissions not granted');
//     } else if (status.isPermanentlyDenied) {
//       openAppSettings();
//     }
//   }
// }
