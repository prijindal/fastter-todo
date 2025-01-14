import 'package:auto_route/auto_route.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:provider/provider.dart';

import '../../models/db_selector.dart';
import 'form.dart';

@RoutePage()
class NewProjectScreen extends StatelessWidget {
  const NewProjectScreen({super.key});

  void _onSave(BuildContext context, {String? title, HexColor? color}) async {
    if (title == null || color == null) {
      return;
    }
    await Provider.of<DbSelector>(context, listen: false)
        .database
        .managers
        .project
        .create(
          (o) => o(
            color: color.hex,
            title: title,
          ),
        );
    // ignore: use_build_context_synchronously
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Add new project'),
        ),
        body: ProjectForm(
          onSave: ({title, color}) => _onSave(
            context,
            title: title,
            color: color,
          ),
        ),
      );
}
