import 'package:darkwrong/models/FieldValue.dart';
import 'package:flutter/foundation.dart';

class FixtureModel {
  final String uid;
  final Map<String, FieldValue> values;

  FixtureModel({
    @required this.uid,
    @required this.values,
  });

  FixtureModel copyWith({
    String uid,
    Map<String, FieldValue> values
  }) {
    return FixtureModel(
      uid: uid ?? this.uid,
      values: values ?? this.values,
    );
  }

  FixtureModel copyWithUpdatedValue(String fieldId, FieldValue newValue) {
    final map = Map<String, FieldValue>.from(values);
    map[fieldId] = newValue;

    return this.copyWith(
      values: map,
    );
  }

  FieldValue getValue(String fieldId) {
    return values[fieldId];
  }
}
