import 'package:darkwrong/models/FieldValue.dart';

class FieldValuesStore {
  final Map<String, Map<String, FieldValue>> valueMap;

  FieldValuesStore({this.valueMap});

  FieldValuesStore.initial() : valueMap = <String, Map<String, FieldValue>>{};

  FieldValuesStore copyWith({
    Map<String, Map<String, FieldValue>> valueMap,
  }) {
    return FieldValuesStore(
      valueMap: valueMap ?? this.valueMap,
    );
  }

  FieldValuesStore copyWithNewValue(
      String fieldId, String valueId, FieldValue value) {
    final newValueMap = Map<String, Map<String, FieldValue>>.from(valueMap);

    if (containsField(fieldId) == false) {
      // Coerce field Existence.
      newValueMap[fieldId] = <String, FieldValue>{};
    }

    newValueMap[fieldId][valueId] = value;

    return copyWith(
      valueMap: newValueMap,
    );
  }

  FieldValuesStore copyWithNewValues(
      Map<String, Map<String, FieldValue>> values) {
    final newValueMap = Map<String, Map<String, FieldValue>>.from(valueMap);

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
    return valueMap.containsKey(fieldId) && valueMap[fieldId] != null;
  }

  bool containsValue(String fieldId, String valueId) {
    return containsField(fieldId) &&
        valueMap[fieldId].containsKey(valueId) &&
        valueMap[fieldId][valueId] != null;
  }

  FieldValue getValue(String fieldId, String valueId) {
    return containsValue(fieldId, valueId) == null
        ? null
        : valueMap[fieldId][valueId];
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
