import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/models/Fixture.dart';

class FixtureState {
  final Map<String, FixtureModel> fixtures;
  final Map<String, FieldModel> fields;
  final FieldValuesStore fieldValues;
  
  FixtureState({
    this.fixtures,
    this.fields,
    this.fieldValues,
  });

  FixtureState.initial()
      : fixtures = <String, FixtureModel>{},
        fields = <String, FieldModel>{},
        fieldValues = FieldValuesStore.initial();

  FixtureState copyWith({
    Map<String, FixtureModel> fixtures,
    Map<String, FieldModel> fields,
    FieldValuesStore fieldValues,
  }) {
    return FixtureState(
      fixtures: fixtures ?? this.fixtures,
      fields: fields ?? this.fields,
      fieldValues: fieldValues ?? this.fieldValues,
    );
  }
}
