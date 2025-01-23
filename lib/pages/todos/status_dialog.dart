import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'tagslist.dart';

Future<String?> showStatusDialog(BuildContext context, List<String> statuses) =>
    showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses
              .map(
                (status) => ListTile(
                  title: Text(status),
                  onTap: () => Navigator.of(context).pop(status),
                ),
              )
              .toList(),
        ),
      ),
    );

// A form builder widget which will create a dialog where you can input several statuses in a list
// To select list of pending statuses for a project
class FormBuilderStatusesSelector extends StatelessWidget {
  const FormBuilderStatusesSelector({
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
          child: StatusesSelector(
            selectedStatuses: field.value,
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

class StatusesSelector extends StatelessWidget {
  StatusesSelector({
    super.key,
    required this.onSelected,
    this.expanded = false,
    this.selectedStatuses,
  });

  final GlobalKey _menuKey = GlobalKey();
  final void Function(List<String>) onSelected;
  final bool expanded;
  final List<String>? selectedStatuses;

  Future<void> _showMenu(BuildContext context) async {
    final newSelectedStatuses = await showDialog<List<String>>(
      context: context,
      builder: (context) => StatusesInputDialog(
        selectedStatuses: selectedStatuses,
      ),
    );
    if (newSelectedStatuses != null) {
      onSelected(newSelectedStatuses);
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
        title: TagsList(tags: selectedStatuses ?? []),
        onTap: () => _showMenu(context),
      );
    }
    return IconButton(
      key: _menuKey,
      icon: _buildIcon(context),
      onPressed: () => _showMenu(context),
      tooltip: 'Statuses',
    );
  }
}

class StatusesInputDialog extends StatefulWidget {
  const StatusesInputDialog({
    super.key,
    List<String>? selectedStatuses = const <String>[],
  }) : selectedStatuses = selectedStatuses ?? const <String>[];

  final List<String> selectedStatuses;

  @override
  State<StatusesInputDialog> createState() => _StatusesInputState();
}

class _StatusesInputState extends State<StatusesInputDialog> {
  late List<String> _selectedStatuses = widget.selectedStatuses;
  final TextEditingController _textEditingController = TextEditingController();

  void _removeStatus(String status) {
    setState(() {
      _selectedStatuses = (_selectedStatuses.toList()..remove(status));
    });
  }

  void _addNewStatus() {
    setState(() {
      _selectedStatuses =
          (_selectedStatuses.toList()..add(_textEditingController.text));
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
                        hintText: "Add status",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _addNewStatus,
                    icon: Icon(Icons.add),
                  )
                ],
              ),
            ),
            Divider(),
            if (_selectedStatuses.isEmpty)
              Center(
                child: Text("No statuses available, please add one"),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _selectedStatuses.length,
                itemBuilder: (context, index) {
                  final status = _selectedStatuses[index];
                  return ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removeStatus(status),
                    ),
                    title: Text(status),
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
                          .pop<List<String>>(_selectedStatuses);
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
