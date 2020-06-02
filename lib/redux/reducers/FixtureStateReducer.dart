import 'package:darkwrong/config/FieldMetadataDescriptors.dart';
import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/models/field_values/MetadataValue.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/FixtureState.dart';
import 'package:darkwrong/util/getUid.dart';

FixtureState fixtureStateReducer(FixtureState state, dynamic action) {
  if (action is DeleteCustomField) {
    return state.copyWith(
        fields: Map<String, FieldModel>.from(state.fields)
          ..remove(action.fieldId));
  }

  if (action is UpdateField) {
    return state.copyWith(
        fields: Map<String, FieldModel>.from(state.fields)
          ..update(
              action.fieldId,
              (value) => value.copyWith(
                    encoding: action.request.encoding ?? value.encoding,
                    name: action.request.fieldName ?? value.name,
                  )));
  }

  if (action is AddCustomField) {
    final newField = FieldModel(
      uid: getUid(),
      name: action.fieldName,
      encoding: action.encoding,
      type: FieldType.custom,
      valueMetadataDescriptors: FieldMetadataDescriptors.custom,
    );

    return state.copyWith(
        fields: Map<String, FieldModel>.from(state.fields)
          ..addAll({newField.uid: newField}));
  }

  if (action is UpdateFieldMetadataValue) {
    return state.copyWith(
        fieldValues: state.fieldValues.copyWithNewMetadataValue(
            action.fieldValueKey,
            action.propertyName,
            MetadataValue(primaryValue: action.newValue)));
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
      fieldValues: state.fieldValues
          .copyWithNewValues(action.fieldValueUpdates.valueMap),
    );
  }

  if (action is UpdateFieldValue) {
    return state.copyWith(
      fixtures: Map<String, FixtureModel>.from(state.fixtures)
        ..updateAll((key, value) {
          if (action.updatedFixtures.containsKey(key)) {
            return action.updatedFixtures[key];
          } else {
            return value;
          }
        }),
      fieldValues: action.fieldValues,
    );
  }

  if (action is AddNewFixtures) {
    return state.copyWith(
        fixtures: Map<String, FixtureModel>.from(state.fixtures)
          ..addAll(action.fixtures),
        fieldValues: action.fieldValues);
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
