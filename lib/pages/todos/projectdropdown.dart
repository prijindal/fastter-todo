import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../models/core.dart';
import '../../models/local_db_state.dart';

class FormBuilderProjectSelector extends StatelessWidget {
  const FormBuilderProjectSelector({
    super.key,
    this.initialValue,
    this.validator,
    required this.name,
    this.expanded = false,
    this.decoration,
    this.onChanged,
    this.onOpening,
    this.enabled = true,
  });

  final String? initialValue;
  final String? Function(String?)? validator;
  final String name;
  final bool expanded;
  final bool enabled;
  final InputDecoration? decoration;
  final void Function(String?)? onChanged;
  final void Function()? onOpening;

  Widget _buildDropDown(BuildContext context, FormFieldState<String> field) {
    return ProjectDropdown(
      enabled: enabled,
      selectedProject: field.value == null
          ? null
          : Provider.of<LocalDbState>(context)
              .projects
              .where((a) => a.id == field.value)
              .firstOrNull,
      expanded: expanded,
      onOpening: onOpening,
      onSelected: (newEntry) {
        field.didChange(newEntry?.id);
        onChanged?.call(newEntry?.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      enabled: enabled,
      initialValue: initialValue,
      name: name,
      validator: validator,
      builder: (FormFieldState<String> field) {
        if (decoration == null) {
          return _buildDropDown(context, field);
        }
        return InputDecorator(
          decoration: decoration!,
          child: _buildDropDown(context, field),
        );
      },
    );
  }
}

class ProjectDropdown extends StatelessWidget {
  const ProjectDropdown({
    super.key,
    required this.onSelected,
    this.selectedProject,
    this.onOpening,
    this.expanded = false,
    this.enabled = false,
  });

  final bool expanded;
  final void Function(ProjectData?) onSelected;
  final ProjectData? selectedProject;
  final void Function()? onOpening;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Selector<LocalDbState, List<ProjectData>>(
      selector: (_, state) => state.projects,
      builder: (context, projects, _) => _ProjectDropdown(
        projects: projects,
        onSelected: onSelected,
        selectedProject: selectedProject,
        onOpening: onOpening,
        expanded: expanded,
        enabled: enabled,
      ),
    );
  }
}

class _ProjectDropdown extends StatelessWidget {
  _ProjectDropdown({
    required this.projects,
    required this.onSelected,
    this.selectedProject,
    this.onOpening,
    this.expanded = false,
    this.enabled = false,
  });

  final GlobalKey _menuKey = GlobalKey();
  final bool expanded;
  final List<ProjectData> projects;
  final void Function(ProjectData?) onSelected;
  final ProjectData? selectedProject;
  final void Function()? onOpening;
  final bool enabled;

  RelativeRect _getPosition(BuildContext context) {
    if (onOpening != null) {
      onOpening!();
    }
    final RenderBox? overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    final RenderBox? renderBox =
        _menuKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox != null && overlay != null
        ? RelativeRect.fromRect(
            Rect.fromPoints(
              renderBox.localToGlobal(Offset.zero, ancestor: overlay),
              renderBox.localToGlobal(renderBox.size.bottomRight(Offset.zero),
                  ancestor: overlay),
            ),
            Offset.zero & overlay.size,
          )
        : const RelativeRect.fromLTRB(0, 0, 0, 0);
  }

  void _showMenu(BuildContext context) {
    showMenu<ProjectData>(
      position: _getPosition(context),
      initialValue: selectedProject,
      context: context,
      items: projects
          .map((project) => PopupMenuItem<ProjectData>(
                value: project,
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelected(project);
                  },
                  leading: Icon(
                    Icons.group_work,
                    color: HexColor(project.color),
                  ),
                  title: Text(project.title),
                ),
              ))
          .toList()
        ..add(PopupMenuItem<ProjectData>(
          value: null,
          child: ListTile(
            onTap: () {
              Navigator.of(context).pop();
              onSelected(null);
            },
            leading: const Icon(
              Icons.group_work,
            ),
            title: const Text('Inbox'),
          ),
        )),
    );
  }

  Icon _buildIcon() => Icon(
        Icons.group_work,
        color:
            selectedProject == null ? null : HexColor(selectedProject!.color),
      );

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return ListTile(
        enabled: enabled,
        key: _menuKey,
        dense: true,
        leading: _buildIcon(),
        title: Text(selectedProject == null ? 'Inbox' : selectedProject!.title),
        onTap: enabled == false ? null : () => _showMenu(context),
      );
    }
    return IconButton(
      key: _menuKey,
      icon: _buildIcon(),
      onPressed: enabled == false ? null : () => _showMenu(context),
      tooltip: 'Project',
    );
  }
}
