import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:meta/meta.dart';

class FieldValue {
  final String primaryValue;
  final FieldValueKey key;
  final int length;
  final FieldType type;

  FieldValue({
    @required this.primaryValue,
    @required this.type,
  })  : key = FieldValueKey(primaryValue),
        length = primaryValue?.length ?? 0;

  FieldValue copyWith({
    String primaryValue,
    FieldType type,
  }) {
    return FieldValue(
      primaryValue: primaryValue ?? this.primaryValue,
      type: type ?? this.type,
    );
  }

  // In future, could be fleshed out to return different types of Values. For example an asNumber getter or asGobo getter.
  String get asText => primaryValue;

  operator ==(Object o) {
    return o is FieldValue && o.primaryValue == primaryValue;
  }

  @override
  int get hashCode => primaryValue.hashCode;
}
