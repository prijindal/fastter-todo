import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    required this.currentValue,
    required this.onChange,
  });

  final Color currentValue;
  final void Function(Color) onChange;

  void _pickColor(BuildContext context) {
    var _pickerColor = currentValue;
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _pickerColor,
            onColorChanged: (color) {
              _pickerColor = color;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Got it'),
            onPressed: () {
              onChange(_pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: () => _pickColor(context),
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: currentValue,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        title: const Text('Color'),
        subtitle: Text('#${currentValue.value.toRadixString(16)}'),
      );
}
