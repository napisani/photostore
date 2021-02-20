// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class PhotoBackupScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return _PhotoBackupScreen();
//   }
// }
//
// class _PhotoBackupScreen extends StatefulWidget {
//   _PhotoBackupScreen({Key key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _PhotoBackupScreenState();
// }
//
// class _PhotoBackupScreenState extends State<_PhotoBackupScreen> {
//   PhotoBackupBloc _backupBloc;
//   MobilePhotoPageBloc _mobileBloc;
//   bool preparingPhotoBackupQueue = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _backupBloc = BlocProvider.of<PhotoBackupBloc>(context);
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     // return Scaffold(
//     //     appBar: AppBar(
//     //       title: Text("Backup to Server"),
//     //     ),
//     //     // add this body tag with container and photoview widget
//     //     body: Text('test'));
//
//     return BlocBuilder<PhotoBackupBloc, PhotoBackupState>(
//         builder: (context, state) {
//       if (state is PhotoBackupStateInitial) {
//         _backupBloc.getInitialStats();
//         return Center(
//           child: RaisedButton(
//             child: Text(
//               "Load",
//             ),
//             onPressed: () {
//               _backupBloc.getInitialStats();
//             },
//           ),
//         );
//       } else if (state is PhotoBackupStateFailure) {
//         return Center(
//           child: Text("Error occurred: ${state.errorMessage}"),
//         );
//       } else if (state is PhotoBackupStateSuccess) {
//         if (state.queuedPhotos == null || state.queuedPhotos.length == 0) {
//           return Center(
//             child: RaisedButton(
//                 child: Text(preparingPhotoBackupQueue
//                     ? 'Preparing Backup'
//                     : 'Prepare Backup'),
//                 onPressed: () =>
//                     preparingPhotoBackupQueue ? null : _prepareBackup(state)),
//           );
//         } else {
//           return Center(
//             child: Text('loaded'),
//           );
//         }
//       } else {
//         throw Exception("invalid  PhotoBackupState type");
//       }
//     });
//   }
// }
