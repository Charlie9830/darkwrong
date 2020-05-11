import 'package:darkwrong/models/FieldValue.dart';
import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:flutter/foundation.dart';

class FixtureModel {
  final String uid;
  final Map<String, FieldValueKey> valueKeys;

  FixtureModel({
    @required this.uid,
    @required this.valueKeys,
  });

  FixtureModel copyWith({
    String uid,
    Map<String, FieldValueKey> values
  }) {
    return FixtureModel(
      uid: uid ?? this.uid,
      valueKeys: values ?? this.valueKeys,
    );
  }

  FixtureModel copyWithUpdatedValue(String fieldId, FieldValueKey newValue) {
    final map = Map<String, FieldValueKey>.from(valueKeys);
    map[fieldId] = newValue;

    return this.copyWith(
      values: map,
    );
  }
}
