import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/FieldValue.dart';
import 'package:meta/meta.dart';

class CustomValue extends FieldValue {
  CustomValue({
    @required String primaryValue,
    String shortValue,
    String note,
  }) : super.build(
            primaryValue: primaryValue,
            type: FieldType.custom,
            shortValue: shortValue,
            note: note);

  CustomValue copyWith({
    String shortValue,
    String note,
    InstrumentType instrumentType,
  }) {
    return CustomValue(
      primaryValue: this
          .primaryValue, // Currently do not allow copyWith to change the primaryValue as the primaryValue is used to generate the key.
      shortValue: shortValue ?? this.shortValue,
      note: note ?? this.note,
    );
  }
}
