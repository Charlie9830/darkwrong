import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/CustomValue.dart';
import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/InstrumentNameValue.dart';
import 'package:meta/meta.dart';

class FieldValue {
  final String primaryValue;
  final FieldValueKey key;
  final int length;
  final FieldType type;

  // Common Metadata.
  final String shortValue;
  final String note;

  factory FieldValue({
    @required String primaryValue,
    @required FieldType type,
    String shortValue,
    String note,
  }) {
    switch (type) {
      case FieldType.custom:
        return CustomValue(
          primaryValue: primaryValue,
          shortValue: shortValue,
          note: note,
        );
      case FieldType.instrumentName:
        return InstrumentNameValue(
          primaryValue: primaryValue,
          shortValue: shortValue,
          note: note,
        );
      default:
        throw UnimplementedError(
            'FieldValue factory constructor does not have a case for the FieldType $type. Please add one.');
    }
  }

  /// Do not call this constructor directly. It is intended to only be called by FieldValue Subclasses.
  FieldValue.build({
    @required this.primaryValue,
    @required this.type,
    this.shortValue,
    this.note,
  })  : key = FieldValueKey(primaryValue),
        length = primaryValue?.length ?? 0;


  // In future, could be fleshed out to return different types of Values. For example an asNumber getter or asGobo getter.
  String get asText => primaryValue;

  operator ==(Object o) {
    return o is FieldValue && o.primaryValue == primaryValue;
  }

  @override
  int get hashCode => primaryValue.hashCode;
}
