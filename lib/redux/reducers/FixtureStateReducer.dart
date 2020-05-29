import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/FixtureState.dart';
import 'package:darkwrong/util/getUid.dart';

FixtureState fixtureStateReducer(FixtureState state, dynamic action) {
  if (action is AddFields) {
    return state.copyWith(fields: _addFields(state.fields, action.names));
  }

  if (action is UpdateFixturesAndFieldValues) {
    return state.copyWith(
      fixtures: Map<String, FixtureModel>.from(state.fixtures)
        ..updateAll((key, value) {
          if (action.fixtureUpdates.containsKey(key)) {
            return action.fixtureUpdates[key];
          } else {
            return value;
          }
        }),
      fieldValues: state.fieldValues.copyWithNewValues(action.fieldValueUpdates.valueMap),
    );
  }

  if (action is AddNewFixtures) {
    return state.copyWith(
      fixtures: Map<String, FixtureModel>.from(state.fixtures)..addAll(action.fixtures),
      fieldValues: action.fieldValues
    );
  }

  if (action is AddBlankFixture) {
    final fixtures = Map<String, FixtureModel>.from(state.fixtures);
    final fixture = FixtureModel(
      uid: getUid(),
      valueKeys: <String, FieldValueKey>{},
    );

    fixtures[fixture.uid] = fixture;

    return state.copyWith(fixtures: fixtures);
  }

  if (action is RemoveFixtures) {
    final fixtures = Map<String, FixtureModel>.from(state.fixtures);
    for (var fixtureId in action.fixtureIds) {
      fixtures.remove(fixtureId);
    }

    return state.copyWith(
      fixtures: fixtures,
    );
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
        type: FieldType.custom,
        encoding: ValueEncoding.text,
      );
    }
  }

  return fields;
}
