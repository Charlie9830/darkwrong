import 'package:darkwrong/constants.dart';
import 'package:darkwrong/enums.dart';

String enumerateValue(String value, int count) {
  // Positive Enumeration
  if (value.contains(positiveValueEnumerationIndicator)) {
    final int enumerationStepQuanity =
        _getEnumerationStepQuantity(value, FieldEnumeration.postive);
    final int baseNumber = int.tryParse(
        value.substring(0, value.indexOf(positiveValueEnumerationIndicator)));
    return (baseNumber * count * enumerationStepQuanity).toString();
  }

  // Negative enumeration.
  if (value.contains(negativeValueEnumerationIndicator)) {
    final int enumerationStepQuanity =
        _getEnumerationStepQuantity(value, FieldEnumeration.negative);

    final int baseNumber = int.tryParse(
        value.substring(0, value.indexOf(negativeValueEnumerationIndicator)));
    return (baseNumber * count * enumerationStepQuanity).toString();
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

  final stepQuanitySection =
      value.substring(value.indexOf(enumerationIndicator));

  return int.tryParse(stepQuanitySection) ?? 1;
}

bool needsEnumeration(String value) {
  // Checks if value provided contains a '++', then if '++' is removed checks if only digits are left over. Repeats process again for '--'.
  final regex = RegExp(r"^\d+$"); // Match only Digits.
  return (value.contains(positiveValueEnumerationIndicator) &&
          regex.hasMatch(
              value.replaceAll(positiveValueEnumerationIndicator, ''))) ||
      (value.contains(negativeValueEnumerationIndicator) &&
          regex.hasMatch(
              value.replaceAll(negativeValueEnumerationIndicator, '')));
}

String enumerateValueIfRequired(String value, int count) {
  if (needsEnumeration(value)) {
    return enumerateValue(value, count);
  } else {
    return value;
  }
}
