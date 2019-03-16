import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/store/state.dart';

class LabelsList extends StatelessWidget {
  const LabelsList({
    @required this.labels,
  });

  final List<Label> labels;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 100,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: labels
                .map<Widget>((label) => LabelItem(
                      label: label,
                    ))
                .toList(),
          ),
        ),
      );
}

class LabelItem extends StatelessWidget {
  const LabelItem({
    @required this.label,
  });

  final Label label;

  @override
  Widget build(BuildContext context) =>
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => _LabelItem(
              label: label,
              labels: store.state.labels,
            ),
      );
}

class _LabelItem extends StatelessWidget {
  const _LabelItem({
    @required this.labels,
    @required this.label,
  });

  final ListState<Label> labels;
  final Label label;

  @override
  Widget build(BuildContext context) {
    final filteredLabel = labels.items.singleWhere((l) => l.id == label.id);
    return Container(
      color: Theme.of(context).primaryColor,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Text(
        filteredLabel.title,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.body1.fontSize,
          color: Colors.grey[200],
        ),
      ),
    );
  }
}
