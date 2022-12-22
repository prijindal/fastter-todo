import 'package:flutter/material.dart';

import '../fastter/fastter_bloc.dart';
import '../helpers/navigator.dart';
import '../models/label.model.dart';
import '../store/labels.dart';

class EditLabelScreen extends StatefulWidget {
  const EditLabelScreen({
    super.key,
    required this.label,
  });

  final Label label;

  @override
  _EditLabelScreenState createState() => _EditLabelScreenState();
}

class _EditLabelScreenState extends State<EditLabelScreen> {
  late final TextEditingController titleController;
  FocusNode titleFocusNode = FocusNode();

  @override
  void initState() {
    titleController = TextEditingController(text: widget.label.title);
    super.initState();
  }

  void _onSave() {
    fastterLabels.add(UpdateEvent<Label>(
      widget.label.id,
      Label(
        id: widget.label.id,
        title: titleController.text,
      ),
    ));
    Navigator.of(context).pop();
  }

  Future<void> _deleteLabel() async {
    final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Delete ${widget.label.title}?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop<bool>(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop<bool>(true),
                  child: const Text('Yes'),
                )
              ],
            ));
    if (shouldDelete != null && shouldDelete) {
      fastterLabels.add(DeleteEvent<Label>(
        widget.label.id,
      ));
      history.add(RouteInfo('/'));
      await Navigator.of(context)
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
            TextButton(
              child: const Text('Delete Label'),
              onPressed: _deleteLabel,
            )
          ],
        ),
      );
}
