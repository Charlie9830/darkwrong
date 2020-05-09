import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValue.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/FixtureState.dart';
import 'package:darkwrong/util/getUid.dart';

FixtureState fixtureStateReducer(FixtureState state, dynamic action) {
  if (action is AddFields) {
    return state.copyWith(fields: _addFields(state.fields, action.names));
  }

  if (action is AddBlankFixture) {
    final fixtures = Map<String, FixtureModel>.from(state.fixtures);
    final fixture = FixtureModel(
      uid: getUid(),
      values: <String, FieldValue>{},
    );

    fixtures[fixture.uid] = fixture;

    return state.copyWith(
        fixtures: fixtures
    );
  }

  if (action is UpdateFixtureValue) {
    final selectedCells = action.selectedCells;
    final fieldValues =
        Map<String, Map<String, FieldValue>>.from(state.fieldValues);
    final modifiedFixtures = <String, FixtureModel>{};

    for (var cell in selectedCells) {
      final fixtureId = cell.rowId;
      final fieldId = cell.columnId;
      final fixture = state.fixtures[fixtureId];
      final currentValue = fixture.values[fieldId];

      if (currentValue == action.newValue) {
        continue;
      }

      if (fieldValues[fieldId][currentValue.key] == null) {
        // Add the value to fieldValues.
        fieldValues[fieldId][currentValue.key] = currentValue;
      }

      // Modify the Fixture.
      if (modifiedFixtures.containsKey(fixtureId)) {
        modifiedFixtures[fixtureId] = modifiedFixtures[fixtureId]
            .copyWithUpdatedValue(currentValue.key, currentValue);
      } else {
        modifiedFixtures[fixtureId] =
            fixture.copyWithUpdatedValue(currentValue.key, currentValue);
      }
    }

    // Merge modifiedFixtures with fixtures.
    final newFixtures = state.fixtures.map((key, value) {
      if (modifiedFixtures.containsKey(key)) {
        return MapEntry(key, modifiedFixtures[key]);
      }
      return MapEntry(key, value);
    });

    return state.copyWith(fieldValues: fieldValues, fixtures: newFixtures);
  }

  return state;
}

Map<String, FieldModel> _addFields(
    Map<String, FieldModel> existingFields, List<String> fieldNames) {
  final fields = Map<String, FieldModel>.from(existingFields);

  // Add Fields if not already existing.
  for (var name in fieldNames) {
    if (existingFields.values.any((item) => item.name == name) == false) {
      final uid = getUid();

      fields[uid] = FieldModel(
        uid: uid,
        name: name,
        type: FieldType.text,
      );
    }
  }

  return fields;
}
