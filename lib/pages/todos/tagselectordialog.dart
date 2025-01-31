import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_it/get_it.dart';

import '../../models/local_db_state.dart';

class TagSelectorDialog extends StatefulWidget {
  const TagSelectorDialog({
    super.key,
    List<String>? selectedTags = const <String>[],
  }) : selectedTags = selectedTags ?? const <String>[];

  final List<String> selectedTags;

  @override
  State<TagSelectorDialog> createState() => _TagSelectionState();
}

class _TagSelectionState extends State<TagSelectorDialog> {
  late List<String> _selectedTags = widget.selectedTags;
  List<String> _allTags = [];
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    _fetchTags();
    super.initState();
  }

  void _fetchTags() {
    final tags = GetIt.I<LocalDbState>().allTags;
    setState(() {
      _allTags = tags;
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
    if (_formKey.currentState?.saveAndValidate() == true) {
      final tag = (_formKey.currentState!.value["tag"] as String);
      setState(() {
        _allTags = (_allTags.toList()..add(tag));
        _selectedTags = (_selectedTags.toList()..add(tag));
      });
      _formKey.currentState!.reset();
    }
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
              child: FormBuilder(
                key: _formKey,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: FormBuilderTextField(
                        name: "tag",
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Add tag",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _addNewTag(),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                          FormBuilderValidators.minLength(3),
                          FormBuilderValidators.maxLength(15),
                        ]),
                      ),
                    ),
                    IconButton(
                      onPressed: _addNewTag,
                      icon: Icon(Icons.add),
                    )
                  ],
                ),
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
