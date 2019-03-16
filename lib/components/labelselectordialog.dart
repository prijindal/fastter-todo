import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/fastter/fastter_action.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/store/state.dart';

class LabelSelectorDialog extends StatelessWidget {
  const LabelSelectorDialog({
    @required this.selectedLabels,
  });

  final List<Label> selectedLabels;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _LabelSelectorDialog(
              labels: store.state.labels,
              selectedLabels: selectedLabels,
              createLabel: (label) => store.dispatch(AddItem<Label>(label)),
            ),
      );
}

class _LabelSelectorDialog extends StatefulWidget {
  const _LabelSelectorDialog({
    @required this.labels,
    @required this.selectedLabels,
    @required this.createLabel,
    Key key,
  }) : super(key: key);

  final ListState<Label> labels;
  final List<Label> selectedLabels;
  final void Function(Label) createLabel;

  @override
  _LabelSelectorDialogState createState() => _LabelSelectorDialogState();
}

class _LabelSelectorDialogState extends State<_LabelSelectorDialog> {
  List<Label> selectedLabels;

  @override
  void initState() {
    super.initState();
    selectedLabels = widget.selectedLabels;
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
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
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
                          if (isSelected) {
                            setState(() {
                              selectedLabels.add(label);
                            });
                          } else {
                            setState(() {
                              selectedLabels.removeWhere((selectedLabel) =>
                                  selectedLabel.id == label.id);
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
          FlatButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          FlatButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.of(context).pop(selectedLabels),
          ),
        ],
      );
}
