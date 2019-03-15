import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/fastter/fastter_action.dart';
import '../helpers/navigator.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/store/state.dart';

class EditLabelScreen extends StatelessWidget {
  const EditLabelScreen({
    @required this.label,
  });

  final Label label;
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _EditLabelScreen(
            label: label,
            onEditLabel: (updatedlabel) =>
                store.dispatch(UpdateItem<Label>(label.id, updatedlabel)),
            deleteLabel: () {
              store.dispatch(DeleteItem<Label>(label.id));
              store.dispatch(StartSync<Todo>());
            }),
      );
}

class _EditLabelScreen extends StatefulWidget {
  const _EditLabelScreen({
    @required this.label,
    @required this.onEditLabel,
    @required this.deleteLabel,
    Key key,
  }) : super(key: key);

  final Label label;
  final void Function(Label) onEditLabel;
  final VoidCallback deleteLabel;

  @override
  _EditLabelScreenState createState() => _EditLabelScreenState();
}

class _EditLabelScreenState extends State<_EditLabelScreen> {
  TextEditingController titleController;
  FocusNode titleFocusNode = FocusNode();

  @override
  void initState() {
    titleController = TextEditingController(text: widget.label.title);
    super.initState();
  }

  void _onSave() {
    widget.onEditLabel(
      Label(
        id: widget.label.id,
        title: titleController.text,
      ),
    );
    Navigator.of(context).pop();
  }

  Future<void> _deleteLabel() async {
    final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Delete ${widget.label.title}?'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.of(context).pop<bool>(false),
                  child: const Text('No'),
                ),
                FlatButton(
                  onPressed: () => Navigator.of(context).pop<bool>(true),
                  child: const Text('Yes'),
                )
              ],
            ));
    if (shouldDelete) {
      widget.deleteLabel();
      history.add(RouteInfo('/'));
      await navigatorKey.currentState
          .pushNamedAndRemoveUntil('/', (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Edit Label'),
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
            FlatButton(
              child: const Text('Delete Label'),
              onPressed: _deleteLabel,
            )
          ],
        ),
      );
}
