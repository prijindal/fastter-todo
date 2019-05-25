import 'package:fastter_dart/fastter/fastter_bloc.dart';
import 'package:fastter_dart/store/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/models/label.model.dart';

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
      BlocBuilder<FastterEvent<Label>, ListState<Label>>(
        bloc: fastterLabels,
        builder: (context, state) => _LabelItem(
              label: label,
              labels: state.items,
            ),
      );
}

class _LabelItem extends StatelessWidget {
  const _LabelItem({
    @required this.labels,
    @required this.label,
  });

  final List<Label> labels;
  final Label label;

  @override
  Widget build(BuildContext context) {
    final filteredLabel = labels.singleWhere((l) => l.id == label.id);
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
