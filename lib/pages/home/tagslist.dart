import 'package:flutter/material.dart';

class TagsList extends StatelessWidget {
  const TagsList({
    super.key,
    required this.tags,
  });

  final List<String> tags;

  @override
  Widget build(BuildContext context) => Wrap(
        spacing: 8.0,
        children: [
          ...tags.map<Widget>(
            (a) => Text('#$a'),
          )
        ],
      );
}
