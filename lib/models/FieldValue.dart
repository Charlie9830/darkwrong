import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:meta/meta.dart';

class FieldValue {
  final String primaryValue;
  final String shortValue;
  final String note;
  final FieldValueKey key;
  final int length;

  FieldValue({
    @required this.primaryValue,
    this.shortValue,
    this.note,
  })  : key = FieldValueKey(primaryValue),
        length = primaryValue?.length ?? 0;

  FieldValue.fromText({
    @required this.primaryValue,
    this.shortValue,
    this.note,
  }) : 
  key = FieldValueKey(primaryValue),
  length = primaryValue?.length ?? 0;

  // In future, could be fleshed out to return different types of Values. For example an asNumber getter or asGobo getter.
  String get asText => primaryValue;

  operator ==(Object o) {
    return o is FieldValue && o.primaryValue == primaryValue;
  }

  @override
  int get hashCode => primaryValue.hashCode;
}
