import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_colorpicker/block_picker.dart';

import '../fastter/fastter_action.dart';
import '../helpers/navigator.dart';
import '../models/base.model.dart';
import '../models/project.model.dart';
import '../store/state.dart';
import '../components/hexcolor.dart';

class AddProjectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return _AddProjectScreen(
          onAddProject: (Project project) =>
              store.dispatch(AddItem<Project>(project)),
        );
      },
    );
  }
}

class _AddProjectScreen extends StatefulWidget {
  final void Function(Project) onAddProject;
  _AddProjectScreen({
    Key key,
    @required this.onAddProject,
  }) : super(key: key);

  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<_AddProjectScreen> {
  TextEditingController titleController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();

  Color _pickerColor = Color(0xff443a49);
  Color _currentColor = Color(0x443a49);

  void _onSave() {
    widget.onAddProject(
      Project(
        title: titleController.text,
        color: _currentColor.value.toRadixString(16),
      ),
    );
    Navigator.of(context).pop();
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text("Pick a color"),
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: _pickerColor,
                onColorChanged: (Color color) {
                  _pickerColor = color;
                },
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: const Text('Got it'),
                onPressed: () {
                  setState(() => _currentColor = _pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new project"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_right),
            onPressed: _onSave,
          )
        ],
      ),
      body: ListView(
        children: [
          TextField(
            focusNode: titleFocusNode,
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Title",
            ),
          ),
          ListTile(
            onTap: _pickColor,
            leading: Container(
              width: 32.0,
              height: 32.0,
              decoration: BoxDecoration(
                color: _currentColor,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            title: Text("Color"),
            subtitle: Text('#' + _currentColor.value.toRadixString(16)),
          )
        ],
      ),
    );
  }
}
