import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../models/user.model.dart';
import '../store/state.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _ProfileScreen(
          user: store.state.user,
        );
      },
    );
  }
}

class _ProfileScreen extends StatefulWidget {
  final UserState user;

  _ProfileScreen({Key key, @required this.user}) : super(key: key);

  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<_ProfileScreen> {
  User get user => widget.user.user;

  void _editName() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Type your name"),
            content: TextFormField(
              initialValue: user.name,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Save"),
                onPressed: () {
                  // Save name
                },
              )
            ],
          ),
    );
  }

  void _editEmail() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Type your Email"),
            content: TextFormField(
              initialValue: user.email,
              keyboardType: TextInputType.emailAddress,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Save"),
                onPressed: () {
                  // Save name
                },
              )
            ],
          ),
    );
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Type your Password"),
            content: TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Save"),
                onPressed: () {
                  // Save name
                },
              )
            ],
          ),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Are you sure?"),
            content: Text("All the tasks and projects will also be deleted"),
            actions: <Widget>[
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  // Save name
                },
              )
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Avatar"),
            trailing: user.picture == null
                ? Icon(
                    Icons.person,
                    color: Colors.white,
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(user.picture),
                  ),
          ),
          ListTile(
            title: Text("Name"),
            subtitle: Text(user.name),
            onTap: _editName,
          ),
          ListTile(
            title: Text("Email"),
            subtitle: Text(user.email),
            onTap: _editEmail,
          ),
          ListTile(
            title: Text("Password"),
            subtitle: Text("Change your password"),
            onTap: _changePassword,
          ),
          ListTile(
            title: Text("Delete your account"),
            onTap: _deleteAccount,
          )
        ],
      ),
    );
  }
}
