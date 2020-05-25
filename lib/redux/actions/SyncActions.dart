import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/redux/state/WorksheetState.dart';

class InitMockData {
  InitMockData();
}

class SelectWorksheetLeftTool {
  final String value;

  SelectWorksheetLeftTool({
    this.value,
  });
}

class SetWorksheetLeftRailPersistence {
  final bool persist;

  SetWorksheetLeftRailPersistence({
    this.persist,
  });
}

class AddNewFixtures {
  final Map<String, FixtureModel> fixtures;
  final FieldValuesStore fieldValues;

  AddNewFixtures({this.fixtures, this.fieldValues});
}

class UpdateFixturesAndFieldValues {
  final Map<String, FixtureModel> fixtureUpdates;
  final FieldValuesStore fieldValueUpdates;
  final FieldValuesStore existingFieldValues;

  UpdateFixturesAndFieldValues({
    this.fixtureUpdates,
    this.fieldValueUpdates,
    this.existingFieldValues,
  });
}

class RemoveFixtures {
  final Set<String> fixtureIds;

  RemoveFixtures({
    this.fixtureIds,
  });
}

class RemoveWorksheetRows {
  final Set<String> rowIds;

  RemoveWorksheetRows({this.rowIds});
}

class AddWorksheetRows {
  final Map<String, FixtureModel> fixtures;
  final FieldValuesStore fieldValues;

  AddWorksheetRows({
    this.fixtures,
    this.fieldValues,
  });
}

class AddFieldValueQueries {
  final String fieldId;
  final Set<FieldValueKey> valueKeys;
  final Map<String, FixtureModel> fixtures;
  final FieldValuesStore fieldValues;

  AddFieldValueQueries({
    this.fieldId,
    this.valueKeys,
    this.fixtures,
    this.fieldValues,
  });
}

class RemoveFieldValueQueries {
  final String fieldId;
  final Set<FieldValueKey> valueKeys;
  final Map<String, FixtureModel> fixtures;
  final FieldValuesStore fieldValues;

  RemoveFieldValueQueries({
    this.fieldId,
    this.valueKeys,
    this.fixtures,
    this.fieldValues,
  });
}

class SelectFieldQueryId {
  final String fieldId;

  SelectFieldQueryId({
    this.fieldId,
  });
}

class BuildWorksheetState {
  final WorksheetState state;

  BuildWorksheetState({
    this.state,
  });
}

class AddFields {
  final List<String> names;

  AddFields({
    this.names,
  });
}

class AddBlankFixture {
  AddBlankFixture();
}

class SelectWorksheetCell {
  final String cellId;
  final String rowId;
  final String columnId;

  SelectWorksheetCell({
    this.cellId,
    this.rowId,
    this.columnId,
  });
}

class DeselectWorksheetCell {
  final String cellId;
  final String rowId;
  final String columnId;

  DeselectWorksheetCell({
    this.cellId,
    this.rowId,
    this.columnId,
  });
}
