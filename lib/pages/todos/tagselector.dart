import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'tagselectordialog.dart';
import 'tagslist.dart';

class FormBuilderTagSelector extends StatelessWidget {
  const FormBuilderTagSelector({
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

  final List<String>? initialValue;
  final String? Function(List<String>?)? validator;
  final String name;
  final bool expanded;
  final bool enabled;
  final InputDecoration? decoration;
  final void Function()? onOpening;
  final void Function(List<String>)? onChanged;

  Widget _buildDropDown(FormFieldState<List<String>> field) {
    return TagSelector(
      enabled: enabled,
      selectedTags: field.value,
      expanded: expanded,
      onOpening: onOpening,
      onSelected: (newEntries) {
        field.didChange(newEntries);
        onChanged?.call(newEntries);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<String>>(
      enabled: enabled,
      initialValue: initialValue,
      name: name,
      validator: validator,
      builder: (FormFieldState<List<String>> field) {
        if (decoration == null) {
          return _buildDropDown(field);
        }
        return InputDecorator(
          decoration: decoration!,
          child: _buildDropDown(field),
        );
      },
    );
  }
}

class TagSelector extends StatelessWidget {
  TagSelector({
    super.key,
    required this.onSelected,
    this.expanded = false,
    this.onOpening,
    this.selectedTags,
    this.enabled = true,
  });

  final GlobalKey _menuKey = GlobalKey();
  final void Function(List<String>) onSelected;
  final void Function()? onOpening;
  final bool expanded;
  final bool enabled;
  final List<String>? selectedTags;

  Future<void> _showMenu(BuildContext context) async {
    onOpening?.call();
    final newSelectedTags = await showDialog<List<String>>(
      context: context,
      builder: (context) => TagSelectorDialog(
        selectedTags: selectedTags,
      ),
    );
    if (newSelectedTags != null) {
      onSelected(newSelectedTags);
    }
  }

  Icon _buildIcon(BuildContext context) => Icon(
        Icons.label,
      );

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return ListTile(
        enabled: enabled,
        key: _menuKey,
        dense: true,
        title: TagsList(tags: selectedTags ?? []),
        onTap: enabled == false ? null : () => _showMenu(context),
      );
    }
    return IconButton(
      key: _menuKey,
      icon: _buildIcon(context),
      onPressed: enabled == false ? null : () => _showMenu(context),
      tooltip: 'Tags',
    );
  }
}
