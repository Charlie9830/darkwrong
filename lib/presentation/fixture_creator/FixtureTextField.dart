import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:darkwrong/models/FieldValue.dart';
import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:flutter/material.dart';

typedef void FieldValueSubmittedCallback(FieldValueKey valueKey);
typedef void StringSubmittedCallback(String value);

class FixtureTextField extends StatefulWidget {
  final List<FieldValue> options;
  final FieldValueSubmittedCallback onExistingOptionSubmitted;
  final StringSubmittedCallback onNewOptionSubmitted;

  FixtureTextField(
      {Key key,
      this.options,
      this.onExistingOptionSubmitted,
      this.onNewOptionSubmitted})
      : super(key: key);

  @override
  _FixtureTextFieldState createState() => _FixtureTextFieldState();
}

class _FixtureTextFieldState extends State<FixtureTextField> {
  GlobalKey<AutoCompleteTextFieldState<FieldValue>> globalKey;
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AutoCompleteTextField<FieldValue>(
      key: globalKey,
      controller: _controller,
      clearOnSubmit: false,
      suggestions: widget.options ?? <FieldValue>[],
      itemSorter: (a, b) => a.asText.compareTo(b.asText),
      itemFilter: (suggestion, input) =>
          suggestion.asText.toLowerCase().startsWith(input.toLowerCase()) ||
          suggestion.asText.toLowerCase().contains(input.toLowerCase()),
      itemSubmitted: (FieldValue value) {
        _controller.text = value.asText;
        widget.onExistingOptionSubmitted(value.key);
      },
      textSubmitted: (String value) => widget.onNewOptionSubmitted(value),
      itemBuilder: (context, item) =>
          ListTile(key: ValueKey(item.key), title: Text(item.asText)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
