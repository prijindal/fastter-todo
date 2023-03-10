import '../store/projects.dart';
import '../store/todos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../fastter/fastter_bloc.dart';
import '../models/base.model.dart';
import '../models/project.model.dart';
import '../models/todo.model.dart';

import '../components/hexcolor.dart';
import '../helpers/theme.dart';
import 'addproject.dart';
import 'editproject.dart';

class ManageProjectsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterBloc<Project>, ListState<Project>>(
        bloc: fastterProjects,
        builder: (context, state) => _ManageProjectsScreen(
          projects: state,
          deleteProject: (project) {
            fastterProjects.add(DeleteEvent<Project>(project.id));
            // fastterTodos.add(SyncEvent<Todo>());
          },
          updateColor: (project, color) {
            fastterProjects.add(
              UpdateEvent<Project>(
                project.id,
                Project(
                  id: project.id,
                  title: project.title,
                  color: color.value.toRadixString(16),
                  createdAt: project.createdAt,
                  updatedAt: project.updatedAt,
                ),
              ),
            );
          },
        ),
      );
}

class _ManageProjectsScreen extends StatefulWidget {
  const _ManageProjectsScreen({
    required this.projects,
    required this.deleteProject,
    required this.updateColor,
  });

  final ListState<Project> projects;
  final void Function(Project) deleteProject;
  final void Function(Project, Color) updateColor;

  @override
  _ManageProjectsScreenState createState() => _ManageProjectsScreenState();
}

class _ManageProjectsScreenState extends State<_ManageProjectsScreen> {
  List<String> selectedProjects = <String>[];

  Future<bool?> _deleteProject(String title) async => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: const Text('All tasks will move to inbox'),
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
        ),
      );

  void _unSelectAll() {
    setState(() {
      selectedProjects = [];
    });
  }

  Widget _buildChangeColorButton() => IconButton(
        icon: const Icon(Icons.color_lens),
        onPressed: () async {
          Color _pickerColor = Colors.black;
          final selectedColor = await showDialog<Color>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Pick a color'),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: _pickerColor,
                  onColorChanged: (color) {
                    _pickerColor = color;
                  },
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(null);
                  },
                ),
                TextButton(
                  child: const Text('Got it'),
                  onPressed: () {
                    Navigator.of(context).pop(_pickerColor);
                  },
                ),
              ],
            ),
          );
          if (selectedColor != null) {
            final projects = widget.projects.items
                .where((project) => selectedProjects.contains(project.id))
                .toList();
            for (final project in projects) {
              widget.updateColor(project, selectedColor);
            }
          }
        },
      );

  Widget _buildDeleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          final shouldDelete =
              await _deleteProject('Delete ${_buildAppBarTitle()} ?');
          if (shouldDelete != null && shouldDelete) {
            final projects = widget.projects.items
                .where((project) => selectedProjects.contains(project.id))
                .toList();
            projects.forEach(widget.deleteProject);
          }
        },
      );

  Widget _buildEditButton() {
    if (selectedProjects.isNotEmpty && widget.projects.items.isNotEmpty) {
      final todoid = selectedProjects[0];
      final projects = widget.projects.items.where((item) => item.id == todoid);
      if (projects.isNotEmpty) {
        return IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (context) => EditProjectScreen(
                  project: projects.first,
                ),
              ),
            );
          },
        );
      }
    }
    return Container(child: null);
  }

  List<Widget> _buildButtons() {
    if (selectedProjects.isEmpty) {
      return [];
    }
    if (selectedProjects.length == 1) {
      return <Widget>[
        _buildEditButton(),
        _buildDeleteButton(),
        _buildChangeColorButton(),
      ];
    }
    return <Widget>[
      _buildDeleteButton(),
      _buildChangeColorButton(),
    ];
  }

  Widget _buildBottom() {
    final position = selectedProjects.isEmpty ? 48.0 : 0.0;
    return Positioned(
      bottom: position,
      right: position,
      child: selectedProjects.isEmpty
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (context) => const AddProjectScreen(),
                ),
              ),
            )
          : Material(
              elevation: 20,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: _buildButtons(),
                ),
              ),
            ),
    );
  }

  String _buildAppBarTitle() => '${selectedProjects.length.toString()} '
      'Project${selectedProjects.length > 1 ? 's' : ''}';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AnimatedTheme(
            data: selectedProjects.isNotEmpty ? whiteTheme : primaryTheme,
            child: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: selectedProjects.isNotEmpty
                    ? _unSelectAll
                    : () {
                        Navigator.of(context).pop();
                      },
              ),
              title: Text(selectedProjects.isNotEmpty
                  ? '${_buildAppBarTitle()} selected'
                  : 'Manage Projects'),
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: widget.projects.items.length,
              itemBuilder: (context, index) {
                final project = widget.projects.items[index];
                return ListTile(
                  onTap: () {
                    if (selectedProjects.contains(project.id)) {
                      setState(() {
                        selectedProjects.remove(project.id);
                      });
                    } else {
                      setState(() {
                        selectedProjects.add(project.id);
                      });
                    }
                  },
                  selected: selectedProjects.contains(project.id),
                  leading: Icon(
                    Icons.group_work,
                    color:
                        project.color == null ? null : HexColor(project.color),
                  ),
                  title: Text(project.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      final shouldDelete =
                          await _deleteProject('Delete ${project.title}?');
                      if (shouldDelete != null && shouldDelete) {
                        widget.deleteProject(project);
                      }
                    },
                  ),
                );
              },
            ),
            _buildBottom(),
          ],
        ),
      );
}
