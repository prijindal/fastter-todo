import 'package:flutter/material.dart';

import 'package:fastter_dart/models/label.model.dart';

import 'label.dart';
import 'labelselectordialog.dart';

class LabelSelector extends StatelessWidget {
  LabelSelector({
    @required this.onSelected,
    this.expanded = false,
    this.selectedLabels,
    Key key,
  }) : super(key: key);

  final GlobalKey _menuKey = GlobalKey();
  final void Function(List<Label>) onSelected;
  final bool expanded;
  final List<Label> selectedLabels;

  Future<void> _showMenu(BuildContext context) async {
    final newSelectedLabels = await showDialog<List<Label>>(
      context: context,
      builder: (context) => LabelSelectorDialog(
            selectedLabels: selectedLabels,
          ),
    );
    onSelected(newSelectedLabels);
  }

  Icon _buildIcon(BuildContext context) => Icon(
        Icons.label,
        color: selectedLabels == null ? null : Theme.of(context).accentColor,
      );

  @override
  Widget build(BuildContext context) {
    if (expanded) {
      return ListTile(
        key: _menuKey,
        leading: _buildIcon(context),
        title: const Text('Label'),
        subtitle: LabelsList(labels: selectedLabels),
        onTap: () => _showMenu(context),
      );
    }
    return IconButton(
      key: _menuKey,
      icon: _buildIcon(context),
      onPressed: () => _showMenu(context),
    );
  }
}
