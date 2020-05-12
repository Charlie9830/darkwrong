import 'package:darkwrong/models/FieldValue.dart';
import 'package:darkwrong/models/FieldValueKey.dart';

class FieldValuesStore {
  final Map<String, Map<FieldValueKey, FieldValue>> valueMap;

  FieldValuesStore({this.valueMap});

  FieldValuesStore.initial() : valueMap = <String, Map<FieldValueKey, FieldValue>>{};

  FieldValuesStore copyWith({
    Map<String, Map<FieldValueKey, FieldValue>> valueMap,
  }) {
    return FieldValuesStore(
      valueMap: valueMap ?? this.valueMap,
    );
  }

  FieldValuesStore copyWithNewValue(
      String fieldId, FieldValueKey valueId, FieldValue value) {
    final newValueMap = Map<String, Map<FieldValueKey, FieldValue>>.from(valueMap);

    if (containsField(fieldId) == false) {
      // Coerce field Existence.
      newValueMap[fieldId] = <FieldValueKey, FieldValue>{};
    }

    newValueMap[fieldId][valueId] = value;

    return copyWith(
      valueMap: newValueMap,
    );
  }

  FieldValuesStore copyWithNewValues(
      Map<String, Map<FieldValueKey, FieldValue>> values) {
    final newValueMap = Map<String, Map<FieldValueKey, FieldValue>>.from(valueMap);

    for (var fieldEntry in values.entries) {
      for (var valueEntry in fieldEntry.value.entries) {
        newValueMap[fieldEntry.key][valueEntry.key] = valueEntry.value;
      }
    }

    return copyWith(
      valueMap: newValueMap,
    );
  }

  bool containsField(String fieldId) {
    return fieldId != null && valueMap.containsKey(fieldId) && valueMap[fieldId] != null;
  }

  bool containsValue(String fieldId, FieldValueKey valueKey) {
    return containsField(fieldId) &&
        valueMap[fieldId].containsKey(valueKey) &&
        valueMap[fieldId][valueKey] != null;
  }

  FieldValue getValue(String fieldId, FieldValueKey valueKey) {
    return containsValue(fieldId, valueKey) == null
        ? null
        : valueMap[fieldId][valueKey];
  }

  ///
  /// Returns the entire contents of a field. Returns an empty map if fieldId is null or does not match.
  ///
  Map<FieldValueKey, FieldValue> getFieldContents(String fieldId) {
    if (containsField(fieldId)) {
      return valueMap[fieldId];
    }

    return <FieldValueKey, FieldValue>{};
  }

  int getMaxFieldLength(String fieldId) {
    if (containsField(fieldId) == false) {
      return 0;
    }

    int length = 0;
    valueMap[fieldId].forEach((key, value) {
      if (value.length > length) {
        length = value.length;
      }
    });

    return length;
  }
}
