import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/fastter/fastter_action.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/store/state.dart';

class AddLabelScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _AddLabelScreen(
              onAddLabel: (label) => store.dispatch(AddItem<Label>(label)),
            ),
      );
}

class _AddLabelScreen extends StatefulWidget {
  const _AddLabelScreen({
    @required this.onAddLabel,
    Key key,
  }) : super(key: key);

  final void Function(Label) onAddLabel;

  @override
  _AddLabelScreenState createState() => _AddLabelScreenState();
}

class _AddLabelScreenState extends State<_AddLabelScreen> {
  TextEditingController titleController = TextEditingController();
  FocusNode titleFocusNode = FocusNode();

  void _onSave() {
    widget.onAddLabel(
      Label(
        title: titleController.text,
      ),
    );
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
