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
    this.decoration = const InputDecoration(),
    this.onChanged,
  });

  final List<String>? initialValue;
  final String? Function(List<String>?)? validator;
  final String name;
  final bool expanded;
  final InputDecoration decoration;
  final void Function(List<String>)? onChanged;

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<List<String>>(
      initialValue: initialValue,
      name: name,
      validator: validator,
      builder: (FormFieldState<List<String>> field) {
        return InputDecorator(
          decoration: decoration,
          child: TagSelector(
            selectedTags: field.value,
            expanded: expanded,
            onSelected: (newEntries) {
              field.didChange(newEntries);
              onChanged?.call(newEntries);
            },
          ),
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
    this.selectedTags,
  });

  final GlobalKey _menuKey = GlobalKey();
  final void Function(List<String>) onSelected;
  final bool expanded;
  final List<String>? selectedTags;

  Future<void> _showMenu(BuildContext context) async {
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
        key: _menuKey,
        dense: true,
        title: TagsList(tags: selectedTags ?? []),
        onTap: () => _showMenu(context),
      );
    }
    return IconButton(
      key: _menuKey,
      icon: _buildIcon(context),
      onPressed: () => _showMenu(context),
      tooltip: 'Tags',
    );
  }
}
