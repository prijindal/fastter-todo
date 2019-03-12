import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/user.model.dart';
import '../store/state.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _ProfileScreen(
              user: store.state.user,
            ),
      );
}

class _ProfileScreen extends StatefulWidget {
  const _ProfileScreen({
    @required this.user,
    Key key,
  }) : super(key: key);
  final UserState user;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<_ProfileScreen> {
  User get user => widget.user.user;

  void _editName() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Type your name'),
            content: TextFormField(
              initialValue: user.name,
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('Save'),
                onPressed: () {
                  // Save name
                },
              )
            ],
          ),
    );
  }

  void _editEmail() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Type your Email'),
            content: TextFormField(
              initialValue: user.email,
              keyboardType: TextInputType.emailAddress,
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('Save'),
                onPressed: () {
                  // Save name
                },
              )
            ],
          ),
    );
  }

  void _changePassword() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Type your Password'),
            content: TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('Save'),
                onPressed: () {
                  // Save name
                },
              )
            ],
          ),
    );
  }

  void _deleteAccount() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content:
                const Text('All the tasks and projects will also be deleted'),
            actions: <Widget>[
              FlatButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('Yes'),
                onPressed: () {
                  // Save name
                },
              )
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Avatar'),
              trailing: user.picture == null
                  ? const Icon(
                      Icons.person,
                      color: Colors.white,
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
            ListTile(
              title: const Text('Delete your account'),
              onTap: _deleteAccount,
            )
          ],
        ),
      );
}
