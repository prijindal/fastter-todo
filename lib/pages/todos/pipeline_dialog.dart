import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'tagslist.dart';

Future<String?> showPipelineDialog(
        BuildContext context, List<String> pipelines) =>
    showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select pipeline'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: pipelines
              .map(
                (pipeline) => ListTile(
                  title: Text(pipeline),
                  onTap: () => Navigator.of(context).pop(pipeline),
                ),
              )
              .toList(),
        ),
      ),
    );

// A form builder widget which will create a dialog where you can input several pipelines in a list
// To select list of pending pipelines for a project
class FormBuilderPipelinesSelector extends StatelessWidget {
  const FormBuilderPipelinesSelector({
    super.key,
    this.initialValue,
    this.validator,
    required this.name,
    this.expanded = false,
    this.decoration = const InputDecoration(),
    this.onChanged,
  });

  final List<String>? initialValue;
  final String? Function(List<String>?)? validator;
  final String name;
  final bool expanded;
  final InputDecoration decoration;
  final void Function(List<String>)? onChanged;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<String>>(
      initialValue: initialValue,
      name: name,
      validator: validator,
      builder: (FormFieldState<List<String>> field) {
        return InputDecorator(
          decoration: decoration,
          child: PipelinesSelector(
            selectedPipelines: field.value,
            expanded: expanded,
            onSelected: (newEntries) {
              field.didChange(newEntries);
              onChanged?.call(newEntries);
            },
          ),
        );
      },
    );
  }
}

class PipelinesSelector extends StatelessWidget {
  PipelinesSelector({
    super.key,
    required this.onSelected,
    this.expanded = false,
    this.selectedPipelines,
  });

  final GlobalKey _menuKey = GlobalKey();
  final void Function(List<String>) onSelected;
  final bool expanded;
  final List<String>? selectedPipelines;

  Future<void> _showMenu(BuildContext context) async {
    final newSelectedPipelines = await showDialog<List<String>>(
      context: context,
      builder: (context) => PipelinesInputDialog(
        selectedPipelines: selectedPipelines,
      ),
    );
    if (newSelectedPipelines != null) {
      onSelected(newSelectedPipelines);
    }
  }

  Icon _buildIcon(BuildContext context) => Icon(
        Icons.label,
      );

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return ListTile(
        key: _menuKey,
        dense: true,
        title: TagsList(tags: selectedPipelines ?? []),
        onTap: () => _showMenu(context),
      );
    }
    return IconButton(
      key: _menuKey,
      icon: _buildIcon(context),
      onPressed: () => _showMenu(context),
      tooltip: 'Pipelines',
    );
  }
}

class PipelinesInputDialog extends StatefulWidget {
  const PipelinesInputDialog({
    super.key,
    List<String>? selectedPipelines = const <String>[],
  }) : selectedPipelines = selectedPipelines ?? const <String>[];

  final List<String> selectedPipelines;

  @override
  State<PipelinesInputDialog> createState() => _PipelinesInputState();
}

class _PipelinesInputState extends State<PipelinesInputDialog> {
  late List<String> _selectedPipelines = widget.selectedPipelines;
  final TextEditingController _textEditingController = TextEditingController();

  void _removePipeline(String pipeline) {
    setState(() {
      _selectedPipelines = (_selectedPipelines.toList()..remove(pipeline));
    });
  }

  void _addNewPipeline() {
    setState(() {
      _selectedPipelines =
          (_selectedPipelines.toList()..add(_textEditingController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400.0,
          maxHeight: 400.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 24.0, 22.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Add pipeline",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _addNewPipeline,
                    icon: Icon(Icons.add),
                  )
                ],
              ),
            ),
            Divider(),
            if (_selectedPipelines.isEmpty)
              Center(
                child: Text("No pipelines available, please add one"),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedPipelines.length,
                itemBuilder: (context, index) {
                  final pipeline = _selectedPipelines[index];
                  return ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removePipeline(pipeline),
                    ),
                    title: Text(pipeline),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pop<List<String>>(_selectedPipelines);
                    },
                    child: Text("Confirm"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
