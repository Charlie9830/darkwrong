import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FixtureCreatorMultiplier extends StatelessWidget {
  final TextEditingController controller;
  const FixtureCreatorMultiplier({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.0,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.end,
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
