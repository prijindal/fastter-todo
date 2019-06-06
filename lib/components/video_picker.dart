import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../helpers/storage.dart';

class VideoPickerUploader {
  VideoPickerUploader({
    @required this.context,
    @required this.storagePath,
    @required this.onChange,
    @required this.onError,
  });

  final BuildContext context;
  final String storagePath; // Firebase storage path
  final void Function(String) onChange;
  final void Function(dynamic) onError;

  void editVideo() {
    showDialog<void>(
      context: context,
      builder: (context) => _VideoPickerUploaderWidget(
            context: context,
            storagePath: storagePath,
            onChange: onChange,
            onError: onError,
          ),
    );
  }
}

class _VideoPickerUploaderWidget extends StatefulWidget {
  const _VideoPickerUploaderWidget({
    @required this.context,
    @required this.storagePath,
    @required this.onChange,
    @required this.onError,
  });

  final BuildContext context;
  final String storagePath; // Firebase storage path
  final void Function(String) onChange;
  final void Function(dynamic) onError;

  @override
  _VideoPickerUploaderWidgetState createState() =>
      _VideoPickerUploaderWidgetState();
}

class _VideoPickerUploaderWidgetState
    extends State<_VideoPickerUploaderWidget> {
  File _image;
  StorageUploadTask _uploadTask;

  void _onChange(String url) {
    widget.onChange(url);
    Navigator.of(widget.context).pop();
  }

  Future _takeProfileVideo() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final image = await ImagePicker.pickVideo(source: ImageSource.camera);
      setState(() {
        _image = image;
      });
    } else {}
  }

  Future _selectProfileVideo() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final image = await ImagePicker.pickVideo(source: ImageSource.gallery);
      setState(() {
        _image = image;
      });
    } else {
      final completer = Completer<void>();
      // showOpenPanel(
      //   (fileChooserResult, filepaths) {
      //     if (filepaths.isNotEmpty) {
      //       setState(() {
      //         _image = File(filepaths[0]);
      //       });
      //       completer.complete();
      //     }
      //   },
      //   allowedFileTypes: ['mp4', 'avi'],
      //   allowsMultipleSelection: false,
      //   canSelectDirectories: false,
      // );
      return completer.future;
    }
  }

  Future<void> _uploadProfileVideo() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final ref = FirebaseStorage.instance.ref().child(widget.storagePath);
        setState(() {
          _uploadTask = ref.putFile(_image);
        });
        _uploadTask.events.listen((event) {
          setState(() {
            _uploadTask.lastSnapshot = event.snapshot;
          });
        });
        final String downloadUrl =
            await (await _uploadTask.onComplete).ref.getDownloadURL();

        _onChange(downloadUrl);
      } else {
        final url = await uploadFirebase(widget.storagePath, _image.path);
        _onChange(url);
      }
    } on Exception catch (error) {
      widget.onError(error);
    }
  }

  Future<void> _selectAndUploadVideo() async {
    await _selectProfileVideo();
    await _uploadProfileVideo();
  }

  Future<void> _takeAndUploadVideo() async {
    await _takeProfileVideo();
    await _uploadProfileVideo();
  }

  Future<void> _urlInputVideo() async {
    final urlController = TextEditingController(text: '');
    final shouldUpdate = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Type a url'),
            content: TextFormField(
              controller: urlController,
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: const Text('Save'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          ),
    );
    if (shouldUpdate) {
      _onChange(urlController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final widgets = <Widget>[];
    if (Platform.isAndroid || Platform.isIOS) {
      widgets.add(
        ListTile(
          title: const Text('Take a video'),
          onTap: _takeAndUploadVideo,
        ),
      );
    }
    if (_uploadTask != null &&
        _uploadTask.isInProgress &&
        _uploadTask.lastSnapshot != null) {
      final percentageUploaded = (_uploadTask.lastSnapshot.bytesTransferred /
              _uploadTask.lastSnapshot.totalByteCount) *
          100;
      widgets.add(
        ListTile(
          title: Text('Uploaded ${percentageUploaded.round()} %'),
        ),
      );
    }
    widgets.addAll(
      [
        ListTile(
          title: const Text('Select a video'),
          onTap: _selectAndUploadVideo,
        ),
        ListTile(
          title: const Text('Input a url'),
          onTap: _urlInputVideo,
        ),
      ],
    );

    return SimpleDialog(
      title: const Text('Upload Video'),
      children: widgets,
    );
  }
}
