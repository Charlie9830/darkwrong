import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/FieldValue.dart';
import 'package:meta/meta.dart';

class InstrumentNameValue extends FieldValue {
  final InstrumentType instrumentType;

  InstrumentNameValue({
    @required String primaryValue,
    String shortValue,
    String note,
    this.instrumentType = InstrumentType.conventional,
  }) : super.build(
            primaryValue: primaryValue,
            type: FieldType.instrumentName,
            shortValue: shortValue,
            note: note);

  InstrumentNameValue copyWith({
    String shortValue,
    String note,
    InstrumentType instrumentType,
  }) {
    return InstrumentNameValue(
      primaryValue: this.primaryValue, // Currently do not allow copyWith to change the primaryValue as the primaryValue is used to generate the key.
      shortValue: shortValue ?? this.shortValue,
      note: note ?? this.note,
      instrumentType: instrumentType ?? this.instrumentType,
    );
  }
}
