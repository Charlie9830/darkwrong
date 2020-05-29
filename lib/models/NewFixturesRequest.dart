import 'package:darkwrong/models/FieldValueKey.dart';

class NewFixturesRequest {
  final Map<String, FieldValueKey> existingValueKeys;
  final Map<String, String> newValues;
  final int multiplier;

  NewFixturesRequest({this.existingValueKeys, this.newValues, this.multiplier});

  NewFixturesRequest.initial()
      : existingValueKeys = <String, FieldValueKey>{},
        newValues = <String, String>{},
        multiplier = 1;

  NewFixturesRequest copyWith({
    Map<String, FieldValueKey> existingValueKeys,
    Map<String, String> newValues,
    int multiplier,
  }) {
    return NewFixturesRequest(
        existingValueKeys: existingValueKeys ?? this.existingValueKeys,
        newValues: newValues ?? this.newValues,
        multiplier: multiplier ?? this.multiplier);
  }

  bool get isBlank => existingValueKeys.isEmpty && newValues.isEmpty;
}
