import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:darkwrong/models/field_values/FieldValue.dart';
import 'package:flutter/material.dart';

class FixtureTextField extends StatefulWidget {
  final List<FieldValue> options;
  final TextEditingController controller;

  FixtureTextField({Key key, this.controller, this.options}) : super(key: key);

  @override
  _FixtureTextFieldState createState() => _FixtureTextFieldState();
}

class _FixtureTextFieldState extends State<FixtureTextField> {
  GlobalKey<AutoCompleteTextFieldState<FieldValue>> globalKey;

  @override
  Widget build(BuildContext context) {
    return AutoCompleteTextField<FieldValue>(
      key: globalKey,
      controller: widget.controller,
      clearOnSubmit: false,
      suggestions: widget.options ?? <FieldValue>[],
      itemSorter: (a, b) => a.asText.compareTo(b.asText),
      itemFilter: (suggestion, input) =>
          suggestion.asText.toLowerCase().startsWith(input.toLowerCase()) ||
          suggestion.asText.toLowerCase().contains(input.toLowerCase()),
      itemSubmitted: (FieldValue value) {
        widget.controller.text = value.asText;
      },
      
      itemBuilder: (context, item) =>
          ListTile(key: ValueKey(item.key), title: Text(item.asText)),
    );
  }
}
