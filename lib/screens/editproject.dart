import 'package:fastter_dart/store/projects.dart';
import 'package:flutter/material.dart';

import 'package:fastter_dart/fastter/fastter_bloc.dart';
import 'package:fastter_dart/models/project.model.dart';

import '../components/colorpicker.dart';
import '../components/hexcolor.dart';
import '../helpers/navigator.dart';

class EditProjectScreen extends StatefulWidget {
  const EditProjectScreen({
    @required this.project,
    Key key,
  }) : super(key: key);

  final Project project;

  @override
  _EditProjectScreenState createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
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
    fastterProjects.dispatch(UpdateEvent<Project>(
      widget.project.id,
      Project(
        id: widget.project.id,
        title: titleController.text,
        color: _currentColor.value.toRadixString(16).substring(2),
      ),
    ));
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
      fastterProjects.dispatch(DeleteEvent<Project>(
        widget.project.id,
      ));
      history.add(RouteInfo('/'));
      await Navigator.of(context)
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
