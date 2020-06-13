import 'package:darkwrong/constants.dart';
import 'package:darkwrong/enums.dart';

String enumerateValueIfRequired(String value, int count) {
  if (_needsEnumeration(value)) {
    return _enumerateValue(value, count);
  } else {
    return value;
  }
}

String _enumerateValue(String value, int count) {
  // Positive Enumeration
  if (value.contains(positiveValueEnumerationIndicator)) {
    final int enumerationStepQuanity =
        _getEnumerationStepQuantity(value, FieldEnumeration.postive);

    final int baseNumber = int.tryParse(
        value.substring(0, value.indexOf(positiveValueEnumerationIndicator)));
    return (baseNumber + (count * enumerationStepQuanity)).toString();
  }

  // Negative enumeration.
  if (value.contains(negativeValueEnumerationIndicator)) {
    final int enumerationStepQuanity =
        _getEnumerationStepQuantity(value, FieldEnumeration.negative);

    final int baseNumber = int.tryParse(
        value.substring(0, value.indexOf(negativeValueEnumerationIndicator)));
    return (baseNumber - (count * enumerationStepQuanity)).toString();
  }

  return 'fail';
}

int _getEnumerationStepQuantity(
    String value, FieldEnumeration fieldEnumeration) {
  if (fieldEnumeration == FieldEnumeration.none) {
    return 1;
  }

  final String enumerationIndicator =
      fieldEnumeration == FieldEnumeration.postive
          ? positiveValueEnumerationIndicator
          : negativeValueEnumerationIndicator;

  final stepQuanitySection = value
      .substring(value.indexOf(enumerationIndicator))
      .replaceAll(enumerationIndicator, '')
      .trim();

  final parsedInt = int.tryParse(stepQuanitySection);

  if (parsedInt == null) {
    return 1;
  }

  return parsedInt > 0 ? parsedInt : 1;
}

bool _needsEnumeration(String value) {
  // Checks if value provided contains a '++', then if '++' is removed checks if only digits are left over. Repeats process again for '--'.
  final digitPattern = RegExp(r"^\d+$"); // Match only Digits.
  final whitespacePattern = RegExp(r'\s');

  return (value.contains(positiveValueEnumerationIndicator) &&
          digitPattern.hasMatch(value
              .replaceAll(positiveValueEnumerationIndicator, '')
              .replaceAll(whitespacePattern, ''))) ||
      (value.contains(negativeValueEnumerationIndicator) &&
          digitPattern.hasMatch(value
              .replaceAll(negativeValueEnumerationIndicator, '')
              .replaceAll(whitespacePattern, '')));
}
