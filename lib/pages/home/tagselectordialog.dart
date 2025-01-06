import 'package:flutter/material.dart';

import '../../models/drift.dart';

class TagSelectorDialog extends StatefulWidget {
  const TagSelectorDialog({
    super.key,
    List<String>? selectedTags = const <String>[],
  }) : this.selectedTags = selectedTags ?? const <String>[];

  final List<String> selectedTags;

  @override
  State<TagSelectorDialog> createState() => _TagSelectionState();
}

class _TagSelectionState extends State<TagSelectorDialog> {
  late List<String> _selectedTags = widget.selectedTags;
  List<String> _allTags = [];
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    _fetchTags();
    super.initState();
  }

  void _fetchTags() async {
    final todos = await MyDatabase.instance.managers.todo.get();
    final allTags = <String>[];
    for (var todo in todos) {
      final tags = todo.tags;
      for (var tag in tags) {
        if (!allTags.contains(tag)) {
          allTags.add(tag);
        }
      }
    }
    setState(() {
      _allTags = allTags;
    });
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags = (_selectedTags.toList()..remove(tag));
      } else {
        _selectedTags = (_selectedTags.toList()..add(tag));
      }
    });
  }

  void _addNewTag() {
    setState(() {
      _allTags = (_allTags.toList()..add(_textEditingController.text));
      _selectedTags =
          (_selectedTags.toList()..add(_textEditingController.text));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 400.0,
          maxHeight: 400.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18.0, 24.0, 22.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: "Add tag",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _addNewTag,
                    icon: Icon(Icons.add),
                  )
                ],
              ),
            ),
            Divider(),
            if (_allTags.isEmpty)
              Center(
                child: Text("No tags available, please add one"),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: _allTags.length,
                itemBuilder: (context, index) {
                  final tag = _allTags[index];
                  return CheckboxListTile(
                    value: _selectedTags.contains(tag),
                    onChanged: (newValue) {
                      _toggleTag(tag);
                    },
                    title: Text(tag),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 24,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop<List<String>>(_selectedTags);
                    },
                    child: Text("Confirm"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
