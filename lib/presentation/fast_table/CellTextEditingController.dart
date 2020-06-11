import 'package:darkwrong/constants.dart';
import 'package:flutter/material.dart';

class CellTextEditingController extends TextEditingController {
  CellTextEditingController({
    String text,
  }) : super(text: text);

  @override
  TextSpan buildTextSpan({TextStyle style, bool withComposing}) {
    if (text.contains(positiveValueEnumerationIndicator) ||
        text.contains(negativeValueEnumerationIndicator)) {
      final indicator = text.contains(positiveValueEnumerationIndicator)
          ? positiveValueEnumerationIndicator
          : negativeValueEnumerationIndicator;

      final enumerationValue = text.substring(text.indexOf(indicator));

      final value = text.substring(0, text.indexOf(indicator));

      return TextSpan(children: <InlineSpan>[
        TextSpan(
          text: value,
          style: style,
        ),
        TextSpan(
            text: enumerationValue,
            style: style.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.orangeAccent,
            ))
      ]);
    }

    return super.buildTextSpan(style: style, withComposing: withComposing);
  }
}
