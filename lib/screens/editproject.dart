import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/fastter/fastter_action.dart';
import 'package:fastter_dart/models/project.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/store/state.dart';

import '../components/colorpicker.dart';
import '../components/hexcolor.dart';
import '../helpers/navigator.dart';

class EditProjectScreen extends StatelessWidget {
  const EditProjectScreen({
    @required this.project,
  });

  final Project project;
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _EditProjectScreen(
            project: project,
            onEditProject: (updatedproject) =>
                store.dispatch(UpdateItem<Project>(project.id, updatedproject)),
            deleteProject: () {
              store.dispatch(DeleteItem<Project>(project.id));
              store.dispatch(StartSync<Todo>());
            }),
      );
}

class _EditProjectScreen extends StatefulWidget {
  const _EditProjectScreen({
    @required this.project,
    @required this.onEditProject,
    @required this.deleteProject,
    Key key,
  }) : super(key: key);

  final Project project;
  final void Function(Project) onEditProject;
  final VoidCallback deleteProject;

  @override
  _EditProjectScreenState createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<_EditProjectScreen> {
  TextEditingController titleController;
  FocusNode titleFocusNode = FocusNode();

  Color _currentColor;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.project.title);
    _currentColor = HexColor(widget.project.color);
    super.initState();
  }

  void _onSave() {
    widget.onEditProject(
      Project(
        id: widget.project.id,
        title: titleController.text,
        color: _currentColor.value.toRadixString(16),
      ),
    );
    Navigator.of(context).pop();
  }

  void _pickColor(Color color) {
    setState(() {
      _currentColor = color;
    });
  }

  Future<void> _deleteProject() async {
    final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Delete ${widget.project.title}?'),
              content: const Text('All tasks will move to inbox'),
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
      widget.deleteProject();
      history.add(RouteInfo('/'));
      await navigatorKey.currentState
          .pushNamedAndRemoveUntil('/', (route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Edit Project'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _onSave,
            )
          ],
        ),
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                focusNode: titleFocusNode,
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
            ),
            ColorPicker(
              currentValue: _currentColor,
              onChange: _pickColor,
            ),
            FlatButton(
              child: const Text('Delete Project'),
              onPressed: _deleteProject,
            )
          ],
        ),
      );
}
