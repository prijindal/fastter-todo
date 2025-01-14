import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ProjectForm extends StatefulWidget {
  const ProjectForm({
    super.key,
    required this.onSave,
    this.title,
    this.color,
  });

  final void Function({String? title, HexColor? color}) onSave;
  final String? title;
  final String? color;

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  late TextEditingController titleController =
      TextEditingController(text: widget.title);

  late HexColor _currentColor = HexColor(widget.color ?? "#FFFFFF");

  @override
  Widget build(BuildContext context) {
    return ListView(
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
        ),
        MaterialButton(
          onPressed: () => widget.onSave(
            color: _currentColor,
            title: titleController.text,
          ),
          child: Text("Save"),
        ),
      ],
    );
  }
}
