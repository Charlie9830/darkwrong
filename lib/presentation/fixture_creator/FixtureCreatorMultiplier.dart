import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FixtureCreatorMultiplier extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  const FixtureCreatorMultiplier({
    Key key,
    this.controller,
    this.focusNode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80.0,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
          BlacklistingTextInputFormatter(RegExp(r'^[^1-9]')),
        ],
        decoration: InputDecoration(
          hintText: 'Multiplier',
        ),
      ),
    );
  }
}
