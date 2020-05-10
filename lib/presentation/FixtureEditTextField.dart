import 'package:flutter/material.dart';

class FixtureEditTextField extends StatefulWidget {
  final String defaultValue;
  final bool enabled;
  final dynamic onSubmitted;

  FixtureEditTextField({
    this.defaultValue,
    this.enabled,
    this.onSubmitted,
  });

  @override
  _FixtureEditTextFieldState createState() => _FixtureEditTextFieldState();
}

class _FixtureEditTextFieldState extends State<FixtureEditTextField> {
  TextEditingController _controller;

  @override
  void initState() { 
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.enabled,
      controller: _controller,
      onSubmitted: (_) => widget.onSubmitted(_controller.text),
    );
  }
}