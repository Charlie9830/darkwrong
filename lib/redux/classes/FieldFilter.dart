import 'package:darkwrong/models/FieldValueKey.dart';

class FieldFilter {
  final String fieldId;
  final Set<FieldValueKey> includedValueKeys;

  FieldFilter({
    this.fieldId,
    this.includedValueKeys,
  });

  FieldFilter.initial()
      : fieldId = '',
        includedValueKeys = <FieldValueKey>{};
}
