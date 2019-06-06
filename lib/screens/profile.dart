import 'package:fastter_todo/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fastter_dart/models/user.model.dart';
import 'package:fastter_dart/store/user.dart';

import '../components/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BlocBuilder<UserEvent, UserState>(
        bloc: fastterUser,
        builder: (context, userState) => _ProfileScreen(
            user: userState,
            deleteUser: () => fastterUser.dispatch(DeleteUserEvent()),
            updateUser: ({name, email, picture}) {
              final action =
                  UpdateUserEvent(name: name, email: email, picture: picture);
              fastterUser.dispatch(action);
              return action.completer.future;
            },
            updatePassword: (password) {
              final action = UpdateUserPasswordEvent(password);
              fastterUser.dispatch(action);
              return action.completer.future;
            }),
      );
}

class _ProfileScreen extends StatefulWidget {
  const _ProfileScreen({
    @required this.user,
    @required this.updateUser,
    @required this.updatePassword,
    @required this.deleteUser,
    Key key,
  }) : super(key: key);

  final Future<void> Function({String name, String email, String picture})
      updateUser;
  final Future<void> Function(String) updatePassword;
  final VoidCallback deleteUser;
  final UserState user;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<_ProfileScreen> {
  User get user => widget.user.user;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void _editPicture() {
    ImagePickerUploader(
      context: context,
      text: 'Upload Profile Picture',
      value: user.picture,
      storagePath: 'profilepictures/${user.id}.jpg',
      onChange: (value) {
        widget.updateUser(picture: value);
        scaffoldKey.currentState.showSnackBar(
          const SnackBar(
            content: Text('Picture Updated Succefully'),
          ),
        );
      },
      onError: (dynamic error) {},
    ).editPicture();
  }

  Future<void> _editName() async {
    final nameController = TextEditingController(text: user.name);
    final shouldUpdate = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Type your name'),
            content: TextFormField(
              controller: nameController,
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
      await widget.updateUser(name: nameController.text);
      scaffoldKey.currentState.showSnackBar(
        const SnackBar(
          content: Text('Name updated Succesfully'),
        ),
      );
    }
  }

  Future<void> _editEmail() async {
    final emailController = TextEditingController(text: user.email);
    final shouldUpdate = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Type your Email'),
            content: TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
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
      await widget.updateUser(email: emailController.text);
      scaffoldKey.currentState.showSnackBar(
        const SnackBar(
          content: Text('Email updated Succesfully'),
        ),
      );
    }
  }

  Future<void> _changePassword() async {
    final passwordController = TextEditingController();
    final shouldChangePassword = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Type your Password'),
            content: TextFormField(
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
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
                  // Save name
                  Navigator.of(context).pop(true);
                },
              )
            ],
          ),
    );
    if (shouldChangePassword == true) {
      await widget.updatePassword(passwordController.text);
      scaffoldKey.currentState.showSnackBar(
        const SnackBar(
          content: Text('Password Updated Succesfully'),
        ),
      );
    }
  }

  Future<void> _deleteAccount() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content:
                const Text('All the tasks and projects will also be deleted'),
            actions: <Widget>[
              FlatButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: const Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          ),
    );
    if (shouldDelete == true) {
      widget.deleteUser();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: const Text('Account'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              onTap: _editPicture,
              title: const Text('Avatar'),
              trailing: user.picture == null || user.picture.isEmpty
                  ? const Icon(
                      Icons.person,
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(user.picture),
                    ),
            ),
            ListTile(
              title: const Text('Name'),
              subtitle: Text(user.name),
              onTap: _editName,
            ),
            ListTile(
              title: const Text('Email'),
              subtitle: Text(user.email),
              onTap: _editEmail,
            ),
            ListTile(
              title: const Text('Password'),
              subtitle: const Text('Change your password'),
              onTap: _changePassword,
            ),
          ],
        ),
      );
}
