import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../models/core.dart';
import '../todos/pipeline_dialog.dart';

class ProjectForm extends StatefulWidget {
  const ProjectForm({
    super.key,
    required this.onSave,
    this.title,
    this.color,
    this.pipelines,
  });

  final void Function({
    String? title,
    Color? color,
    List<String>? pipelines,
  }) onSave;
  final String? title;
  final String? color;
  final List<String>? pipelines;

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  void _onSave() {
    if (_formKey.currentState?.saveAndValidate() == true) {
      final project = _formKey.currentState!.value;
      widget.onSave(
        title: project["title"] as String,
        color: project["color"] as Color?,
        pipelines: project["pipelines"] as List<String>?,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: ListView(
        children: [
          FormBuilderTextField(
            name: "title",
            initialValue: widget.title,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Title',
            ),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(3),
              FormBuilderValidators.maxLength(15),
            ]),
          ),
          FormBuilderPipelinesSelector(
            name: "pipelines",
            initialValue: widget.pipelines ?? [defaultPipeline],
            expanded: true,
            decoration: InputDecoration(
              labelText: 'Pipelines',
            ),
            validator: FormBuilderValidators.minLength(1),
          ),
          FormColorPicker(
            name: "color",
            initialValue: widget.color == null ? null : HexColor(widget.color!),
            decoration: InputDecoration(
              labelText: 'Color',
            ),
            validator: FormBuilderValidators.required(),
          ),
          ElevatedButton(
            onPressed: _onSave,
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}

class FormColorPicker extends StatelessWidget {
  const FormColorPicker({
    super.key,
    this.initialValue,
    this.validator,
    required this.name,
    this.expanded = false,
    this.decoration = const InputDecoration(),
    this.onChanged,
  });

  final Color? initialValue;
  final String? Function(Color?)? validator;
  final String name;
  final bool expanded;
  final InputDecoration decoration;
  final void Function(Color?)? onChanged;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FormBuilderField<Color>(
      initialValue: initialValue,
      name: name,
      validator: validator,
      builder: (FormFieldState<Color> field) {
        return InputDecorator(
          decoration: decoration,
          child: ColorPicker(
            // Use the screenPickerColor as start and active color.
            color: field.value ?? Colors.black,
            // Update the screenPickerColor using the callback.
            onColorChanged: (Color color) {
              field.didChange(color);
              onChanged?.call(color);
            },
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
        );
      },
    );
  }
}
