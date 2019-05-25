import 'package:fastter_dart/fastter/fastter_bloc.dart';
import 'package:fastter_dart/models/base.model.dart';
import 'package:fastter_dart/store/labels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fastter_dart/models/label.model.dart';

import '../screens/addlabel.dart';
import '../screens/managelabels.dart';
import 'expansiontile.dart';

class LabelExpansionTile extends StatelessWidget {
  const LabelExpansionTile({
    @required this.onChildSelected,
    this.selectedLabel,
    Key key,
  }) : super(key: key);

  final Label selectedLabel;
  final void Function(Label) onChildSelected;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterEvent<Label>, ListState<Label>>(
        bloc: fastterLabels,
        builder: (context, state) => BaseExpansionTile<Label>(
              liststate: state,
              addRoute: MaterialPageRoute<void>(
                builder: (context) => const AddLabelScreen(),
              ),
              manageRoute: MaterialPageRoute(
                builder: (context) => ManageLabelsScreen(),
              ),
              icon: const Icon(Icons.label),
              title: 'Labels',
              buildChild: (label) => ListTile(
                    dense: true,
                    enabled:
                        selectedLabel == null || selectedLabel.id != label.id,
                    selected:
                        selectedLabel != null && selectedLabel.id == label.id,
                    leading: const Icon(Icons.label),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          constraints: const BoxConstraints(
                              maxWidth: 200, maxHeight: 40),
                          child: Text(label.title),
                        ),
                      ],
                    ),
                    onTap: () => onChildSelected(label),
                  ),
            ),
      );
}
