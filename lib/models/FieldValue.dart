import 'package:darkwrong/models/FieldValueKey.dart';

class FieldValue {
  final String value;
  final FieldValueKey key;
  final int length;

  FieldValue(this.value, this.key)
      : length = value?.length ?? 0;

  FieldValue.fromText(this.value, this.key)
      : length = value?.length ?? 0;

  // In future, could be fleshed out to return different types of Values. For example an asNumber getter or asGobo getter.
  String get asText => value;

  operator ==(Object o) {
    return o is FieldValue && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}
