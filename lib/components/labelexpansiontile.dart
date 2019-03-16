import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:fastter_dart/models/label.model.dart';
import 'package:fastter_dart/store/state.dart';

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
      StoreConnector<AppState, Store<AppState>>(
        converter: (store) => store,
        builder: (context, store) => BaseExpansionTile<Label>(
              liststate: store.state.labels,
              addRoute: MaterialPageRoute<void>(
                builder: (context) => AddLabelScreen(),
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
