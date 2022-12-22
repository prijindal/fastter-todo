// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// // import 'package:file_chooser/file_chooser.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import '../helpers/storage.dart';

// class ImagePickerUploader {
//   ImagePickerUploader({
//     required this.context,
//     required this.value,
//     required this.storagePath,
//     required this.onChange,
//     required this.onError,
//     required this.text,
//     this.allowPreview = false,
//   });

//   final BuildContext context;
//   final String value; // Url of the image
//   final String storagePath; // Firebase storage path
//   final void Function(String) onChange;
//   final void Function(dynamic) onError;
//   final String text;
//   final bool allowPreview;

//   void editPicture() {
//     showDialog<void>(
//       context: context,
//       builder: (context) => _ImagePickerUploaderWidget(
//         context: context,
//         value: value,
//         storagePath: storagePath,
//         onChange: onChange,
//         onError: onError,
//         text: text,
//         allowPreview: allowPreview,
//       ),
//     );
//   }
// }

// class _ImagePickerUploaderWidget extends StatefulWidget {
//   const _ImagePickerUploaderWidget({
//     required this.context,
//     required this.value,
//     required this.storagePath,
//     required this.onChange,
//     required this.onError,
//     required this.text,
//     this.allowPreview,
//   });

//   final BuildContext context;
//   final String value; // Url of the image
//   final String storagePath; // Firebase storage path
//   final void Function(String) onChange;
//   final void Function(dynamic) onError;
//   final String text;
//   final bool allowPreview;

//   @override
//   _ImagePickerUploaderWidgetState createState() =>
//       _ImagePickerUploaderWidgetState();
// }

// class _ImagePickerUploaderWidgetState
//     extends State<_ImagePickerUploaderWidget> {
//   PickedFile _image;
//   StorageUploadTask _uploadTask;

//   void _onChange(String url) {
//     widget.onChange(url);
//     Navigator.of(widget.context).pop();
//   }

//   Future _takeProfilePicture() async {
//     if (Platform.isAndroid || Platform.isIOS) {
//       final _picker = ImagePicker();
//       final image = await _picker.getImage(source: ImageSource.camera);
//       setState(() {
//         _image = image;
//       });
//     } else {}
//   }

//   Future _selectProfilePicture() async {
//     if (Platform.isAndroid || Platform.isIOS) {
//       final _picker = ImagePicker();
//       final image = await _picker.getImage(source: ImageSource.camera);
//       setState(() {
//         _image = image;
//       });
//     } else {
//       final completer = Completer<void>();
//       // showOpenPanel(
//       //   (fileChooserResult, filepaths) {
//       //     if (filepaths.isNotEmpty) {
//       //       setState(() {
//       //         _image = File(filepaths[0]);
//       //       });
//       //       completer.complete();
//       //     }
//       //   },
//       //   allowedFileTypes: ['jpg', 'png'],
//       //   allowsMultipleSelection: false,
//       //   canSelectDirectories: false,
//       // );
//       return completer.future;
//     }
//   }

//   Future<void> _uploadProfilePicture() async {
//     try {
//       if (Platform.isAndroid || Platform.isIOS) {
//         final ref = FirebaseStorage.instance.ref().child(widget.storagePath);
//         final _bytes = await _image.readAsBytes();
//         setState(() {
//           _uploadTask = ref.putData(_bytes);
//         });
//         _uploadTask.events.listen((event) {
//           setState(() {
//             _uploadTask.lastSnapshot = event.snapshot;
//           });
//         });
//         final String downloadUrl =
//             await (await _uploadTask.onComplete).ref.getDownloadURL();

//         _onChange(downloadUrl);
//       } else {
//         final url = await uploadFirebase(widget.storagePath, _image.path);
//         _onChange(url);
//       }
//     } on Exception catch (error) {
//       widget.onError(error);
//     }
//   }

//   Future<void> _selectAndUploadPicture() async {
//     await _selectProfilePicture();
//     await _uploadProfilePicture();
//   }

//   Future<void> _takeAndUploadPicture() async {
//     await _takeProfilePicture();
//     await _uploadProfilePicture();
//   }

//   Future<void> _urlInputPicture() async {
//     final urlController = TextEditingController(
//       text: widget.value,
//     );
//     final shouldUpdate = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Type a url'),
//         content: TextFormField(
//           controller: urlController,
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('Cancel'),
//             onPressed: () {
//               Navigator.of(context).pop(false);
//             },
//           ),
//           TextButton(
//             child: const Text('Save'),
//             onPressed: () {
//               Navigator.of(context).pop(true);
//             },
//           )
//         ],
//       ),
//     );
//     if (shouldUpdate) {
//       _onChange(urlController.text);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final widgets = <Widget>[
//       if (widget.allowPreview)
//         if (widget.value == null || widget.value.isEmpty)
//           const Icon(
//             Icons.person,
//             size: 200,
//           )
//         else
//           Image.network(
//             widget.value,
//             height: 200,
//             width: 200,
//           ),
//     ];
//     if (Platform.isAndroid || Platform.isIOS) {
//       widgets.add(
//         ListTile(
//           title: const Text('Take a picture'),
//           onTap: _takeAndUploadPicture,
//         ),
//       );
//     }
//     if (_uploadTask != null &&
//         _uploadTask.isInProgress &&
//         _uploadTask.lastSnapshot != null) {
//       final percentageUploaded = (_uploadTask.lastSnapshot.bytesTransferred /
//               _uploadTask.lastSnapshot.totalByteCount) *
//           100;
//       widgets.add(
//         ListTile(
//           title: Text('Uploaded ${percentageUploaded.round()} %'),
//         ),
//       );
//     }
//     if (Platform.isAndroid || Platform.isIOS) {
//       widgets.add(
//         ListTile(
//           title: const Text('Select a picture'),
//           onTap: _selectAndUploadPicture,
//         ),
//       );
//     }
//     widgets.addAll(
//       [
//         ListTile(
//           title: const Text('Input a url'),
//           onTap: _urlInputPicture,
//         ),
//         if (widget.allowPreview)
//           ListTile(
//             title: const Text('Remove picture'),
//             onTap: () => _onChange(null),
//           ),
//       ],
//     );

//     return SimpleDialog(
//       title: Text(widget.text),
//       children: widgets,
//     );
//   }
// }
