import 'dart:async';
import 'dart:io';
import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_chooser/file_chooser.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:fastter_dart/store/state.dart';
import 'package:fastter_dart/store/uploads.dart';

class ImagePickerUploader {
  ImagePickerUploader({
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

  void editPicture() {
    showDialog<void>(
      context: context,
      builder: (context) => _ImagePickerUploaderWidget(
            context: context,
            value: value,
            storagePath: storagePath,
            onChange: onChange,
            onError: onError,
          ),
    );
  }
}

class ImagePickerUploaderWidget extends StatelessWidget {
  const ImagePickerUploaderWidget({
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
        builder: (context, store) => _ImagePickerUploaderWidget(
              context: context,
              value: value,
              storagePath: storagePath,
              onChange: onChange,
              onError: onError,
              upload: (file, fileName) {
                print(fileName);
                final action = UploadStart(file, fileName);
                store.dispatch(action);
                return action.completer.future.then((data) => data.url);
              },
            ),
      );
}

class _ImagePickerUploaderWidget extends StatelessWidget {
  _ImagePickerUploaderWidget({
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

  Future _takeProfilePicture() async {
    if (Platform.isAndroid || Platform.isIOS) {
      _image = await ImagePicker.pickImage(source: ImageSource.camera);
    } else {}
  }

  Future _selectProfilePicture() async {
    if (Platform.isAndroid || Platform.isIOS) {
      _image = await ImagePicker.pickImage(source: ImageSource.gallery);
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

  Future<void> _uploadProfilePicture() async {
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
        print(_image);
      }
    } catch (error) {
      onError(error);
    }
  }

  Future<void> _selectAndUploadPicture() async {
    await _selectProfilePicture();
    await _uploadProfilePicture();
  }

  Future<void> _takeAndUploadPicture() async {
    await _takeProfilePicture();
    await _uploadProfilePicture();
  }

  Future<void> _urlSelectPicture() async {
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
      title: const Text('Change Profile Picture'),
      children: (Platform.isAndroid || Platform.isIOS)
          ? <Widget>[
              value == null || value.isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 200,
                    )
                  : Image.network(
                      value,
                      height: 200,
                      width: 200,
                    ),
              ListTile(
                title: const Text('Take a picture'),
                onTap: () {
                  Navigator.of(context).pop();
                  _takeAndUploadPicture();
                },
              ),
              ListTile(
                title: const Text('Select a picture'),
                onTap: () {
                  Navigator.of(context).pop();
                  _selectAndUploadPicture();
                },
              ),
              ListTile(
                title: const Text('Input a url'),
                onTap: () {
                  Navigator.of(context).pop();
                  _urlSelectPicture();
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
                  : Image.network(
                      value,
                      height: 200,
                      width: 200,
                    ),
              ListTile(
                title: const Text('Select a picture'),
                onTap: () {
                  Navigator.of(context).pop();
                  _selectAndUploadPicture();
                },
              ),
              ListTile(
                title: const Text('Input a url'),
                onTap: () {
                  Navigator.of(context).pop();
                  _urlSelectPicture();
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
