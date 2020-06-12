import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/presentation/fast_table/CellId.dart';
import 'package:darkwrong/presentation/field_editor/FieldListTile.dart';
import 'package:darkwrong/redux/state/WorksheetState.dart';

class InitMockData {
  InitMockData();
}

class SetFieldsAndValuesEditorTabIndex {
  final int index;

  SetFieldsAndValuesEditorTabIndex({
    this.index,
  });
}

class UpdateFieldValue {
  final Map<String, FixtureModel> updatedFixtures;
  final FieldValuesStore fieldValues;

  UpdateFieldValue({
    this.updatedFixtures,
    this.fieldValues,
  });
}

class UpdateFieldMetadataValue {
  final FieldValueKey fieldValueKey;
  final String propertyName;
  final String newValue;

  UpdateFieldMetadataValue(
      {this.fieldValueKey, this.propertyName, this.newValue});
}

class SetFieldsAndValuesEditorSelectedFieldId {
  final String fieldId;

  SetFieldsAndValuesEditorSelectedFieldId({
    this.fieldId,
  });
}

class DeleteCustomField {
  final String fieldId;

  DeleteCustomField({
    this.fieldId,
  });
}

class AddCustomField {
  final String fieldName;
  final ValueEncoding encoding;

  AddCustomField({this.fieldName, this.encoding});
}

class UpdateField {
  final String fieldId;
  final FieldChangeRequest request;

  UpdateField({
    this.fieldId,
    this.request,
  });
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
  final FieldValuesStore fieldValues;

  UpdateFixturesAndFieldValues({
    this.fixtureUpdates,
    this.fieldValues,
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

class AddBlankFixture {
  AddBlankFixture();
}

class SetWorksheetSelectedCellIds {
  final Set<CellId> selectedIds;

  SetWorksheetSelectedCellIds({
    this.selectedIds,
  });
}
