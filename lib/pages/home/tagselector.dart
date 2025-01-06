import 'package:flutter/material.dart';

import 'tagselectordialog.dart';
import 'tagslist.dart';

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
        leading: _buildIcon(context),
        title: const Text('Label'),
        subtitle: TagsList(tags: selectedTags ?? []),
        onTap: () => _showMenu(context),
      );
    }
    return IconButton(
      key: _menuKey,
      icon: _buildIcon(context),
      onPressed: () => _showMenu(context),
      tooltip: 'Labels',
    );
  }
}
