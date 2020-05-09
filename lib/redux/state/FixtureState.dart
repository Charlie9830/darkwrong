import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValue.dart';
import 'package:darkwrong/models/Fixture.dart';

class FixtureState {
  final Map<String, FixtureModel> fixtures;
  final Map<String, FieldModel> fields;
  final Map<String, Map<String, FieldValue>> fieldValues;
  
  FixtureState({
    this.fixtures,
    this.fields,
    this.fieldValues,
  });

  FixtureState.initial()
      : fixtures = <String, FixtureModel>{},
        fields = <String, FieldModel>{},
        fieldValues = <String, Map<String,FieldValue>>{};

  FixtureState copyWith({
    Map<String, FixtureModel> fixtures,
    Map<String, FieldModel> fields,
    Map<String, Map<String, FieldValue>> fieldValues,
  }) {
    return FixtureState(
      fixtures: fixtures ?? this.fixtures,
      fields: fields ?? this.fields,
      fieldValues: fieldValues ?? this.fieldValues,
    );
  }
}
