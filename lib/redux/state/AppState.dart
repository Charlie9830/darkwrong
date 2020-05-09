import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValue.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/models/SelectedCell.dart';
import 'package:darkwrong/models/WorksheetModel.dart';

class AppState {
  final Map<String, FixtureModel> fixtures;
  final WorksheetModel worksheet;
  final Map<String, FieldModel> fields;
  final Map<String, Map<String, FieldValue>> fieldValues;
  final Map<String, int> maxFieldLengths;
  
  AppState({
    this.fixtures,
    this.worksheet,
    this.fields,
    this.fieldValues,
    this.maxFieldLengths,
  });

  AppState.initial()
      : fixtures = <String, FixtureModel>{},
        worksheet = WorksheetModel.initial(),
        fields = <String, FieldModel>{},
        fieldValues = <String, Map<String,FieldValue>>{},
        maxFieldLengths = <String, int>{};

  AppState copyWith({
    Map<String, FixtureModel> fixtures,
    WorksheetModel worksheet,
    Map<String, FieldModel> fields,
    Map<String, Map<String, FieldValue>> fieldValues,
    Map<String, int> maxFieldLengths,
  }) {
    return AppState(
      fixtures: fixtures ?? this.fixtures,
      worksheet: worksheet ?? this.worksheet,
      fields: fields ?? this.fields,
      fieldValues: fieldValues ?? this.fieldValues,
      maxFieldLengths: maxFieldLengths ?? this.maxFieldLengths,
    );
  }
}
