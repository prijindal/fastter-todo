import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../components/colorpicker.dart';
import '../fastter/fastter_action.dart';
import '../models/project.model.dart';
import '../store/state.dart';

class AddProjectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _AddProjectScreen(
              onAddProject: (project) =>
                  store.dispatch(AddItem<Project>(project)),
            ),
      );
}

class _AddProjectScreen extends StatefulWidget {
  const _AddProjectScreen({
    @required this.onAddProject,
    Key key,
  }) : super(key: key);

  final void Function(Project) onAddProject;

  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<_AddProjectScreen> {
  TextEditingController titleController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();

  Color _currentColor = const Color(0x443a49);

  void _onSave() {
    widget.onAddProject(
      Project(
        title: titleController.text,
        color: _currentColor.value.toRadixString(16),
      ),
    );
    Navigator.of(context).pop();
  }

  void _pickColor(Color color) {
    setState(() {
      _currentColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new project'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
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
              labelText: 'Title',
            ),
          ),
          ColorPicker(
            currentValue: _currentColor,
            onChange: _pickColor,
          ),
        ],
      ),
    );
  }
}
