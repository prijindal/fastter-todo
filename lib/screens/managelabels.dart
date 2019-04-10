import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/fastter/fastter_action.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/models/todo.model.dart';
import 'package:fastter_dart/store/state.dart';

import '../helpers/theme.dart';
import 'addlabel.dart';
import 'editlabel.dart';

class ManageLabelsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _ManageLabelsScreen(
              labels: store.state.labels,
              deleteLabel: (Label label) {
                store.dispatch(DeleteItem<Label>(label.id));
                store.dispatch(StartSync<Todo>());
              },
            ),
      );
}

class _ManageLabelsScreen extends StatefulWidget {
  const _ManageLabelsScreen({
    @required this.labels,
    @required this.deleteLabel,
    Key key,
  }) : super(key: key);

  final ListState<Label> labels;
  final void Function(Label) deleteLabel;

  @override
  _ManageLabelsScreenState createState() => _ManageLabelsScreenState();
}

class _ManageLabelsScreenState extends State<_ManageLabelsScreen> {
  List<String> selectedLabels = <String>[];

  Future<bool> _deleteLabel(String title) => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
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
            ),
      );

  void _unSelectAll() {
    setState(() {
      selectedLabels = [];
    });
  }

  Widget _buildDeleteButton() => IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          if (await _deleteLabel('Delete${_buildAppBarTitle()}?')) {
            final labels = widget.labels.items
                .where((label) => selectedLabels.contains(label.id))
                .toList();
            labels.forEach(widget.deleteLabel);
          }
        },
      );

  Widget _buildEditButton() {
    if (selectedLabels.isNotEmpty && widget.labels.items.isNotEmpty) {
      final todoid = selectedLabels[0];
      final label =
          widget.labels.items.singleWhere((item) => item.id == todoid);
      if (label != null) {
        return IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                builder: (context) => EditLabelScreen(
                      label: label,
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
    if (selectedLabels.isEmpty) {
      return [];
    }
    if (selectedLabels.length == 1) {
      return <Widget>[
        _buildEditButton(),
        _buildDeleteButton(),
      ];
    }
    return <Widget>[
      _buildDeleteButton(),
    ];
  }

  Widget _buildBottom() {
    final position = selectedLabels.isEmpty ? 48.0 : 0.0;
    return Positioned(
      bottom: position,
      right: position,
      child: selectedLabels.isEmpty
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => Navigator.of(context).push<void>(
                    MaterialPageRoute<void>(
                      builder: (context) => AddLabelScreen(),
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

  String _buildAppBarTitle() => '${selectedLabels.length.toString()} '
      'Label${selectedLabels.length > 1 ? 's' : ''}';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: AnimatedTheme(
            data: selectedLabels.isNotEmpty ? whiteTheme : primaryTheme,
            child: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: selectedLabels.isNotEmpty
                    ? _unSelectAll
                    : () {
                        Navigator.of(context).pop();
                      },
              ),
              title: Text(selectedLabels.isNotEmpty
                  ? '${_buildAppBarTitle()} selected'
                  : 'Manage Labels'),
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView(
              children: widget.labels.items
                  .map(
                    (label) => ListTile(
                          onTap: () {
                            if (selectedLabels.contains(label.id)) {
                              setState(() {
                                selectedLabels.remove(label.id);
                              });
                            } else {
                              setState(() {
                                selectedLabels.add(label.id);
                              });
                            }
                          },
                          selected: selectedLabels.contains(label.id),
                          title: Text(label.title),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              if (await _deleteLabel(
                                  'Delete ${label.title}?')) {
                                widget.deleteLabel(label);
                              }
                            },
                          ),
                        ),
                  )
                  .toList(),
            ),
            _buildBottom(),
          ],
        ),
      );
}
