import '../store/labels.dart';
import 'package:flutter/material.dart';

import '../fastter/fastter_bloc.dart';
import '../models/label.model.dart';

class AddLabelScreen extends StatefulWidget {
  const AddLabelScreen({
    super.key,
  });

  @override
  _AddLabelScreenState createState() => _AddLabelScreenState();
}

class _AddLabelScreenState extends State<AddLabelScreen> {
  TextEditingController titleController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();

  void _onSave() {
    fastterLabels.add(AddEvent<Label>(
      Label(
        title: titleController.text,
      ),
    ));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Add new label'),
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
          ],
        ),
      );
}
