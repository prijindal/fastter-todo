import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../fastter/fastter_bloc.dart';
import '../models/base.model.dart';
import '../models/label.model.dart';
import '../screens/addlabel.dart';
import '../screens/managelabels.dart';
import '../store/labels.dart';

import 'expansiontile.dart';

class LabelExpansionTile extends StatelessWidget {
  const LabelExpansionTile({
    super.key,
    required this.onChildSelected,
    this.selectedLabel,
  });

  final Label? selectedLabel;
  final void Function(Label) onChildSelected;

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FastterBloc<Label>, ListState<Label>>(
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
            enabled: selectedLabel == null || selectedLabel?.id != label.id,
            selected: selectedLabel != null && selectedLabel?.id == label.id,
            leading: const Icon(Icons.label),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  constraints:
                      const BoxConstraints(maxWidth: 200, maxHeight: 40),
                  child: Text(label.title),
                ),
              ],
            ),
            onTap: () => onChildSelected(label),
          ),
        ),
      );
}
