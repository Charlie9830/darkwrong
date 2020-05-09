import 'package:darkwrong/mock_data/initMockData.dart';
import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValue.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/SelectedCell.dart';
import 'package:darkwrong/models/WorksheetCell.dart';
import 'package:darkwrong/models/WorksheetHeader.dart';
import 'package:darkwrong/models/WorksheetModel.dart';
import 'package:darkwrong/models/WorksheetRow.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:darkwrong/util/getCellId.dart';
import 'package:darkwrong/util/getUid.dart';

AppState appStateReducer(AppState state, dynamic action) {
  if (action is InitMockData) {
    final mockState = initMockData(state);
    return mockState.copyWith(
      worksheet: _rebuildWorksheet(state.worksheet, mockState.fixtures,
          mockState.fieldValues, mockState.fields),
    );
  }

  if (action is AddFields) {
    return state.copyWith(fields: _addFields(state.fields, action.names));
  }

  if (action is UpdateFixtureValue) {
    final selectedCells = state.worksheet.selectedCells.values;
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

  if (action is AddBlankFixture) {
    final fixtures = Map<String, FixtureModel>.from(state.fixtures);
    final fixture = FixtureModel(
      uid: getUid(),
      values: <String, FieldValue>{},
    );

    fixtures[fixture.uid] = fixture;

    return state.copyWith(
        fixtures: fixtures,
        worksheet: _rebuildWorksheet(
            state.worksheet, fixtures, state.fieldValues, state.fields));
  }

  if (action is SelectWorksheetCell) {
    return state.copyWith(
        worksheet: state.worksheet.copyWith(
            selectedCells: Map<String, SelectedCellModel>.from(
                state.worksheet.selectedCells)
              ..addAll({
                action.cellId: SelectedCellModel(
                  rowId: action.rowId,
                  columnId: action.columnId,
                )
              })));
  }

  if (action is DeselectWorksheetCell) {
    return state.copyWith(
        worksheet: state.worksheet.copyWith(
      selectedCells:
          Map<String, SelectedCellModel>.from(state.worksheet.selectedCells)
            ..removeWhere((key, value) => key == action.cellId),
    ));
  }

  return state;
}

WorksheetModel _rebuildWorksheet(
    WorksheetModel existingWorksheet,
    Map<String, FixtureModel> fixtures,
    Map<String, Map<String, FieldValue>> fieldValues,
    Map<String, FieldModel> fields) {
  final List<WorksheetRowModel> rows = [];
  final Map<String, int> maxFieldLengths = {};
  final displayedFields =
      fields; // Actual implementation of Filtering and sorting to be completed at a later date.

  // Iterate through Fixtures then each Fixtures fieldEntrys to build Cells into the Rows. Also collect the maxFieldLengths.
  for (var fixture in fixtures.values) {
    final String rowId = fixture.uid;
    final List<WorksheetCellModel> cells = [];

    for (var fieldsEntry in displayedFields.entries) {
      // Build the Cell.
      final fieldValue = fixture.values[fieldsEntry.key];

      cells.add(WorksheetCellModel(
        cellId: getCellId(rowId, fieldsEntry.key),
        columnId: fieldsEntry.key,
        rowId: rowId,
        value: fieldValue?.value ?? '',
      ));

      // Update maxFieldLengths.
      final coercedValueLength = fieldValue?.length ?? 0;
      if (maxFieldLengths.containsKey(fieldsEntry.key) == false) {
        maxFieldLengths[fieldsEntry.key] = coercedValueLength;
      }

      if (coercedValueLength > maxFieldLengths[fieldsEntry.key]) {
        maxFieldLengths[fieldsEntry.key] = coercedValueLength;
      }
    }

    rows.add(WorksheetRowModel(
      rowId: rowId,
      cells: cells,
    ));
  }

  return existingWorksheet.copyWith(
    rows: rows,
    headers: displayedFields.entries.map((entry) {
      return WorksheetHeaderModel(
          uid: entry.key,
          title: entry.value.name,
          maxFieldLength: maxFieldLengths[entry.key] ?? 0);
    }).toList(),
  );
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
