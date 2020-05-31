import 'package:darkwrong/models/Field.dart';
import 'package:flutter/material.dart';

typedef void FieldSelectorChangedCallback(FieldModel field);

class FieldSelector extends StatelessWidget {
  final List<FieldModel> options;
  final FieldModel selectedValue;
  final FieldSelectorChangedCallback onChanged;

  const FieldSelector(
      {Key key, this.options, this.selectedValue, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<FieldModel>(
      onChanged: (field) => onChanged(field),
      items: options.map(
        (item) => DropdownMenuItem(
          key: Key(item.uid),
          value: item,
          child: Text(item.name ?? ''),
        ),
      ).toList(),
    );
  }
}
