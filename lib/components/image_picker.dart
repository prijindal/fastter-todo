import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

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

  File _image;

  Future _takeProfilePicture() async {
    _image = await ImagePicker.pickImage(source: ImageSource.camera);
  }

  Future _selectProfilePicture() async {
    _image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> _uploadProfilePicture() async {
    try {
      final StorageReference ref =
          FirebaseStorage.instance.ref().child(storagePath);
      final StorageUploadTask uploadTask = ref.putFile(_image);
      final String downloadUrl =
          await (await uploadTask.onComplete).ref.getDownloadURL();
      onChange(downloadUrl);
    } catch (error) {
      onError(error);
    }
  }

  void _selectAndUploadPicture() async {
    await _selectProfilePicture();
    await _uploadProfilePicture();
  }

  void _takeAndUploadPicture() async {
    await _takeProfilePicture();
    await _uploadProfilePicture();
  }

  void _urlSelectPicture() async {
    final TextEditingController urlController = TextEditingController(
      text: value,
    );
    final bool shouldUpdate = await showDialog<bool>(
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

  void editPicture() {
    showDialog<void>(
      context: context,
      builder: (context) => SimpleDialog(
            title: Text("Change Profile Picture"),
            children: (Platform.isAndroid || Platform.isIOS)
                ? <Widget>[
                    value == null || value.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 200,
                          )
                        : Image.network(
                            value,
                            height: 200.0,
                            width: 200.0,
                          ),
                    ListTile(
                      title: Text("Take a picture"),
                      onTap: () {
                        Navigator.of(context).pop();
                        _takeAndUploadPicture();
                      },
                    ),
                    ListTile(
                      title: Text("Select a picture"),
                      onTap: () {
                        Navigator.of(context).pop();
                        _selectAndUploadPicture();
                      },
                    ),
                    ListTile(
                      title: Text("Input a url"),
                      onTap: () {
                        Navigator.of(context).pop();
                        _urlSelectPicture();
                      },
                    ),
                    ListTile(
                      title: Text("Remove picture"),
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
                            height: 200.0,
                            width: 200.0,
                          ),
                    ListTile(
                      title: Text("Input a url"),
                      onTap: () {
                        Navigator.of(context).pop();
                        _urlSelectPicture();
                      },
                    ),
                    ListTile(
                      title: Text("Remove picture"),
                      onTap: () {
                        onChange(null);
                      },
                    ),
                  ],
          ),
    );
  }
}
