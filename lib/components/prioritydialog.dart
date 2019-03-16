import 'package:flutter/material.dart';

List<Color> priorityColors = [
  Colors.grey[700],
  Colors.indigo,
  Colors.deepOrange,
  Colors.red,
];

Future<int> showPriorityDialog(BuildContext context) => showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Select priority'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [1, 2, 3, 4]
                  .map(
                    (pr) => ListTile(
                          leading: Container(
                            width: 10,
                            height: 20,
                            decoration: BoxDecoration(
                              color: priorityColors[pr - 1],
                            ),
                          ),
                          title: Text('Priority ${pr.toString()}'),
                          onTap: () => Navigator.of(context).pop(pr),
                        ),
                  )
                  .toList(),
            ),
          ),
    );
