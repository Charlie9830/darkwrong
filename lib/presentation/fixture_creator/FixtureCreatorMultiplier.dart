import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FixtureCreatorMultiplier extends StatefulWidget {
  final String defaultValue;
  final dynamic onChanged;
  FixtureCreatorMultiplier({Key key, this.defaultValue, this.onChanged})
      : super(key: key);

  @override
  _FixtureCreatorMultiplierState createState() =>
      _FixtureCreatorMultiplierState();
}

class _FixtureCreatorMultiplierState extends State<FixtureCreatorMultiplier> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.defaultValue ?? '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.center,
        onChanged: (newValue) => widget.onChanged,
        keyboardType: TextInputType.number,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          hintText: 'Multiplier',
        ),
      ),
    );
  }
}
