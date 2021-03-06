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
    Map<String, FieldValueKey> valueKeys
  }) {
    return FixtureModel(
      uid: uid ?? this.uid,
      valueKeys: valueKeys ?? this.valueKeys,
    );
  }

  FixtureModel copyWithUpdatedValueKey(String fieldId, FieldValueKey newValue) {
    final map = Map<String, FieldValueKey>.from(valueKeys);
    map[fieldId] = newValue;

    return this.copyWith(
      valueKeys: map,
    );
  }

  bool containsFieldValueKey(String targetFieldId, FieldValueKey key) {
    return valueKeys[targetFieldId] == key;
  }

  bool containsFieldValueKeys(String targetFieldId, Set<FieldValueKey> keys) {
    return keys.any((key) => valueKeys[targetFieldId] == key);
  }
}
