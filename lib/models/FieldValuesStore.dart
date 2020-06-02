import 'package:darkwrong/models/field_values/FieldValue.dart';
import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/field_values/MetadataValue.dart';

class FieldValuesStore {
  final Map<String, Map<FieldValueKey, FieldValue>> valueMap;
  final Map<FieldValueKey, Map<String, MetadataValue>> metadataValues;

  FieldValuesStore({this.valueMap, this.metadataValues});

  FieldValuesStore.initial()
      : valueMap = <String, Map<FieldValueKey, FieldValue>>{},
        metadataValues = <FieldValueKey, Map<String, MetadataValue>>{};

  FieldValuesStore copyWith({
    Map<String, Map<FieldValueKey, FieldValue>> valueMap,
    Map<FieldValueKey, Map<String, MetadataValue>> metadataValues,
  }) {
    return FieldValuesStore(
      valueMap: valueMap ?? this.valueMap,
      metadataValues: metadataValues ?? this.metadataValues,
    );
  }

  FieldValuesStore copyWithNewMetadataValue(
      FieldValueKey valueId, String propertyName, MetadataValue newValue) {
    final newMap =
        Map<FieldValueKey, Map<String, MetadataValue>>.from(metadataValues);
    if (newMap.containsKey(valueId) == false || newMap[valueId] == null) {
      newMap[valueId] = <String, MetadataValue>{};
    }

    newMap[valueId][propertyName] = newValue;

    return copyWith(metadataValues: newMap);
  }

  MetadataValue getMetadataValue(FieldValueKey valueId, String propertyName) {
    if (metadataValues[valueId] == null) {
      return null;
    }

    return metadataValues[valueId][propertyName];
  }

  FieldValuesStore copyWithReplacedValue(String fieldId,
      FieldValueKey oldValueId, FieldValueKey newValueId, FieldValue newValue) {
    final newValueMap =
        Map<String, Map<FieldValueKey, FieldValue>>.from(valueMap);

    if (containsField(fieldId) == false) {
      // Coerce field Existence.
      newValueMap[fieldId] = <FieldValueKey, FieldValue>{};
    }

    print('MetadataValues');
    print(metadataValues);

    newValueMap[fieldId].remove(oldValueId);
    newValueMap[fieldId][newValueId] = newValue;

    final associatedMetadata = metadataValues[oldValueId];
    final newMetadataValues =
        Map<FieldValueKey, Map<String, MetadataValue>>.from(metadataValues);

    if (associatedMetadata != null) {
      newMetadataValues.remove(oldValueId);
      newMetadataValues[newValueId] =
          Map<String, MetadataValue>.from(associatedMetadata);
    }

    return copyWith(
      valueMap: newValueMap,
      metadataValues: newMetadataValues,
    );
  }

  FieldValuesStore copyWithNewValue(
      String fieldId, FieldValueKey valueId, FieldValue value) {
    final newValueMap =
        Map<String, Map<FieldValueKey, FieldValue>>.from(valueMap);

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
    final newValueMap =
        Map<String, Map<FieldValueKey, FieldValue>>.from(valueMap);

    for (var fieldEntry in values.entries) {
      for (var valueEntry in fieldEntry.value.entries) {
        final innerMap = newValueMap.putIfAbsent(
            fieldEntry.key, () => <FieldValueKey, FieldValue>{});
        innerMap[valueEntry.key] = valueEntry.value;
      }
    }

    return copyWith(
      valueMap: newValueMap,
    );
  }

  bool containsField(String fieldId) {
    return fieldId != null &&
        valueMap.containsKey(fieldId) &&
        valueMap[fieldId] != null;
  }

  bool containsValue(String fieldId, FieldValueKey valueKey) {
    return containsField(fieldId) &&
        valueMap[fieldId].containsKey(valueKey) &&
        valueMap[fieldId][valueKey] != null;
  }

  FieldValue getValue(String fieldId, FieldValueKey valueKey) {
    return containsValue(fieldId, valueKey)
        ? valueMap[fieldId][valueKey]
        : null;
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
