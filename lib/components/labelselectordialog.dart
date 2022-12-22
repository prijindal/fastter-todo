import '../store/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fastter/fastter_bloc.dart';
import '../models/base.model.dart';
import '../models/label.model.dart';

class LabelSelectorDialog extends StatelessWidget {
  const LabelSelectorDialog({
    this.selectedLabels,
  });

  final List<Label>? selectedLabels;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterBloc<Label>, ListState<Label>>(
        bloc: fastterLabels,
        builder: (context, state) => _LabelSelectorDialog(
          labels: state,
          selectedLabels: selectedLabels,
          createLabel: (label) => fastterLabels.add(AddEvent<Label>(label)),
        ),
      );
}

class _LabelSelectorDialog extends StatefulWidget {
  const _LabelSelectorDialog({
    required this.labels,
    required this.selectedLabels,
    required this.createLabel,
  });

  final ListState<Label> labels;
  final List<Label>? selectedLabels;
  final void Function(Label) createLabel;

  @override
  _LabelSelectorDialogState createState() => _LabelSelectorDialogState();
}

class _LabelSelectorDialogState extends State<_LabelSelectorDialog> {
  late final List<Label> selectedLabels;

  @override
  void initState() {
    super.initState();
    selectedLabels = widget.selectedLabels ?? [];
  }

  void _addNewLabel() {
    final textController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Label'),
        content: TextField(
          controller: textController,
          decoration: InputDecoration(
            labelText: 'Add a label',
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Save'),
            onPressed: () {
              Navigator.of(context).pop();
              widget.createLabel(
                Label(title: textController.text),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Select Labels'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.labels.items
                .map<Widget>(
                  (label) => CheckboxListTile(
                    value: selectedLabels
                        .map((label) => label.id)
                        .contains(label.id),
                    onChanged: (isSelected) {
                      // new value
                      if (isSelected != null && isSelected) {
                        setState(() {
                          selectedLabels.add(label);
                        });
                      } else {
                        setState(() {
                          selectedLabels.removeWhere(
                              (selectedLabel) => selectedLabel.id == label.id);
                        });
                      }
                    },
                    title: Text(label.title),
                  ),
                )
                .toList()
              ..add(
                ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Add new label'),
                  onTap: _addNewLabel,
                ),
              ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(context).pop(selectedLabels),
          ),
        ],
      );
}
