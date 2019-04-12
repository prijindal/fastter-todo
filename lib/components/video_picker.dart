import 'dart:async';
import 'dart:io';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:chewie/chewie.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:file_chooser/file_chooser.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:fastter_dart/store/state.dart';
import 'package:fastter_dart/store/uploads.dart';

class VideoPickerUploader {
  VideoPickerUploader({
    @required this.context,
    @required this.value,
    @required this.storagePath,
    @required this.onChange,
    @required this.onError,
  });

  final BuildContext context;
  final String value; // Url of the image
  final String storagePath; // Firebase storage path
  final void Function(String) onChange;
  final void Function(dynamic) onError;

  void editVideo() {
    showDialog<void>(
      context: context,
      builder: (context) => _VideoPickerUploaderWidget(
            context: context,
            value: value,
            storagePath: storagePath,
            onChange: onChange,
            onError: onError,
          ),
    );
  }
}

class VideoPickerUploaderWidget extends StatelessWidget {
  const VideoPickerUploaderWidget({
    @required this.context,
    @required this.value,
    @required this.storagePath,
    @required this.onChange,
    @required this.onError,
  });

  final BuildContext context;
  final String value; // Url of the image
  final String storagePath; // Firebase storage path
  final void Function(String) onChange;
  final void Function(dynamic) onError;
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _VideoPickerUploaderWidget(
              context: context,
              value: value,
              storagePath: storagePath,
              onChange: onChange,
              onError: onError,
              upload: (file, fileName) {
                final action = UploadStart(file, fileName);
                store.dispatch(action);
                return action.completer.future.then((data) => data.url);
              },
            ),
      );
}

class _VideoPickerUploaderWidget extends StatelessWidget {
  _VideoPickerUploaderWidget({
    @required this.context,
    @required this.value,
    @required this.storagePath,
    @required this.onChange,
    @required this.onError,
    @required this.upload,
  });

  final BuildContext context;
  final String value; // Url of the image
  final String storagePath; // Firebase storage path
  final void Function(String) onChange;
  final void Function(dynamic) onError;
  final Future<String> Function(File, String) upload;

  File _image;

  Future _takeProfileVideo() async {
    if (Platform.isAndroid || Platform.isIOS) {
      _image = await ImagePicker.pickVideo(source: ImageSource.camera);
    } else {}
  }

  Future _selectProfileVideo() async {
    if (Platform.isAndroid || Platform.isIOS) {
      _image = await ImagePicker.pickVideo(source: ImageSource.gallery);
    } else {
      final completer = Completer<void>();
      showOpenPanel(
        (FileChooserResult fileChooserResult, filepaths) {
          if (filepaths.isNotEmpty) {
            _image = File(filepaths[0]);
            completer.complete();
          }
        },
        allowedFileTypes: ['jpg', 'png'],
        allowsMultipleSelection: false,
        canSelectDirectories: false,
      );
      return completer.future;
    }
  }

  Future<void> _uploadProfileVideo() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final ref = FirebaseStorage.instance.ref().child(storagePath);
        final uploadTask = ref.putFile(_image);
        final String downloadUrl =
            await (await uploadTask.onComplete).ref.getDownloadURL();

        onChange(downloadUrl);
      } else {
        final url = await upload(_image, storagePath);
        onChange(url);
        // TODO(prijindal): Implement firebase storage upload rest api
      }
    } catch (error) {
      onError(error);
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

  Future<void> _urlSelectVideo() async {
    final urlController = TextEditingController(
      text: value,
    );
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
      onChange(urlController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Change Profile Video'),
      children: (Platform.isAndroid || Platform.isIOS)
          ? <Widget>[
              value == null || value.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 200,
                    )
                  : Chewie(
                      controller: ChewieController(
                        videoPlayerController: VideoPlayerController.network(
                          value,
                        ),
                        aspectRatio: 3 / 2,
                      ),
                    ),
              ListTile(
                title: const Text('Take a picture'),
                onTap: () {
                  Navigator.of(context).pop();
                  _takeAndUploadVideo();
                },
              ),
              ListTile(
                title: const Text('Select a picture'),
                onTap: () {
                  Navigator.of(context).pop();
                  _selectAndUploadVideo();
                },
              ),
              ListTile(
                title: const Text('Input a url'),
                onTap: () {
                  Navigator.of(context).pop();
                  _urlSelectVideo();
                },
              ),
              ListTile(
                title: const Text('Remove picture'),
                onTap: () {
                  onChange(null);
                },
              ),
            ]
          : [
              value == null || value.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 200,
                    )
                  : Chewie(
                      controller: ChewieController(
                        videoPlayerController: VideoPlayerController.network(
                          value,
                        ),
                        aspectRatio: 3 / 2,
                      ),
                    ),
              ListTile(
                title: const Text('Input a url'),
                onTap: () {
                  Navigator.of(context).pop();
                  _urlSelectVideo();
                },
              ),
              ListTile(
                title: const Text('Remove picture'),
                onTap: () {
                  onChange(null);
                },
              ),
            ],
    );
  }
}
