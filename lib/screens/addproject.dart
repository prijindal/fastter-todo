import '../store/projects.dart';
import 'package:flutter/material.dart';
import '../fastter/fastter_bloc.dart';

import '../models/project.model.dart';

import '../components/colorpicker.dart';

class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({
    super.key,
  });

  @override
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  TextEditingController titleController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();

  Color _currentColor = const Color(0xff443a49);

  void _onSave() {
    fastterProjects.add(AddEvent<Project>(
      Project(
        title: titleController.text,
        color: _currentColor.value.toRadixString(16).substring(2),
      ),
    ));
    Navigator.of(context).pop();
  }

  void _pickColor(Color color) {
    setState(() {
      _currentColor = color;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
