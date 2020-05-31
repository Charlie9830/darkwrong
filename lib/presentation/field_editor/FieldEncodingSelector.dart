import 'package:darkwrong/enums.dart';
import 'package:darkwrong/util/getHumanFriendlyValueEncoding.dart';
import 'package:flutter/material.dart';

typedef void FieldEncodingChangedCallback(ValueEncoding encoding);

class FieldEncodingSelector extends StatelessWidget {
  final ValueEncoding selectedValue;
  final FieldEncodingChangedCallback onChanged;

  const FieldEncodingSelector({Key key, this.selectedValue, this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<ValueEncoding>(
        value: selectedValue,
        onChanged: onChanged,
        items: ValueEncoding.values
            .map((item) => DropdownMenuItem(
                  key: ValueKey(item),
                  value: item,
                  child: Text(getHumanFriendlyValueEncoding(item)),
                ))
            .toList());
  }
}
