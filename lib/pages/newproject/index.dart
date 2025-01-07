import 'package:auto_route/auto_route.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../models/drift.dart';

@RoutePage()
class NewProjectScreen extends StatefulWidget {
  const NewProjectScreen({super.key});

  @override
  State<NewProjectScreen> createState() => _NewProjectScreenState();
}

class _NewProjectScreenState extends State<NewProjectScreen> {
  TextEditingController titleController = TextEditingController();

  HexColor _currentColor = HexColor("#FFFFFF");

  void _onSave() async {
    await MyDatabase.instance.managers.project.create(
      (o) => o(
        color: _currentColor.hex,
        title: titleController.text,
      ),
    );
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
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
              autofocus: true,
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            ColorPicker(
              // Use the screenPickerColor as start and active color.
              color: _currentColor,
              // Update the screenPickerColor using the callback.
              onColorChanged: (Color color) => setState(
                () => _currentColor = HexColor(color.hex),
              ),
              width: 44,
              height: 44,
              borderRadius: 22,
              heading: Text(
                'Select color',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subheading: Text(
                'Select color shade',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            )
          ],
        ),
      );
}
