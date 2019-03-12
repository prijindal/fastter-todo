import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/block_picker.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker({
    @required this.currentValue,
    @required this.onChange,
  });

  final Color currentValue;
  final void Function(Color) onChange;

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  void _pickColor() {
    var _pickerColor = widget.currentValue;
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
              FlatButton(
                child: const Text('Got it'),
                onPressed: () {
                  widget.onChange(_pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) => ListTile(
        onTap: _pickColor,
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: widget.currentValue,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        title: const Text('Color'),
        subtitle: Text('#${widget.currentValue.value.toRadixString(16)}'),
      );
}
