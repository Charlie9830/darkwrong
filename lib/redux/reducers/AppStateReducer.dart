import 'package:darkwrong/mock_data/initMockData.dart';
import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValue.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/SelectedCell.dart';
import 'package:darkwrong/models/ValueReferenceModel.dart';
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
      worksheet: _rebuildWorksheet(state.worksheet, mockState.fixtures, mockState.fieldValues, mockState.fields),
    );
  }

  if (action is AddFields) {
    return state.copyWith(fields: _addFields(state.fields, action.names));
  }

  if (action is UpdateValue) {
    // final selectedCells = state.worksheet.selectedCells.values.toList();

    // for (var cell in selectedCells) {
    //   final fixtureId = cell.rowId;
    //   final fieldId = cell.columnId;
    //   final valueId = action.newValue;

    //   if (state.fieldValues[fieldId] != null && state.fieldValues[fieldId][action.newValue] != null) {
    //     // Set to existing Value.
        
    //   }
    // }
  }

  if (action is AddBlankFixture) {
    final fixtures = state.fixtures.toList()
      ..add(FixtureModel(
        uid: getUid(),
        values: <String, ValueReferenceModel>{},
      ));

    return state.copyWith(
        fixtures: fixtures,
        worksheet: _rebuildWorksheet(state.worksheet, fixtures, state.fieldValues, state.fields));
  }

  if (action is SelectWorksheetCell) {
    return state.copyWith(
      worksheet: state.worksheet.copyWith(
        selectedCells: Map<String, SelectedCellModel>.from(state.worksheet.selectedCells)..addAll({
          action.cellId : SelectedCellModel(
            rowId: action.rowId,
            columnId: action.columnId,
          )
        })
      )
    );
  }

  if (action is DeselectWorksheetCell) {
    return state.copyWith(
      worksheet: state.worksheet.copyWith(
        selectedCells: Map<String, SelectedCellModel>.from(state.worksheet.selectedCells)..removeWhere((key, value) => key == action.cellId),
      )
    );
  }

  return state;
}

WorksheetModel _rebuildWorksheet(
    WorksheetModel existingWorksheet,
    List<FixtureModel> fixtures,
    Map<String, Map<String, FieldValueModel>> fieldValues,
    Map<String, FieldModel> fields) {
  final List<WorksheetRowModel> rows = [];
  final Map<String, int> maxFieldLengths = {};
  final displayedFields =
      fields; // Actual implementation of Filtering and sorting to be completed at a later date.

  // Iterate through Fixtures then each Fixtures fieldEntrys to build Cells into the Rows. Also collect the maxFieldLengths.
  for (var fixture in fixtures) {
    final String rowId = fixture.uid;
    final List<WorksheetCellModel> cells = [];

    for (var fieldsEntry in displayedFields.entries) {
      // Lookup the fieldValue. Build the Cell.
      final FieldValueModel value = _lookupFieldValue(fieldValues,
          fieldsEntry.key, fixture.values[fieldsEntry.key]?.id);
      cells.add(WorksheetCellModel(
        cellId: getCellId(rowId, fieldsEntry.key),
        columnId: fieldsEntry.key,
        rowId: rowId,
        value: value?.value ?? '',
      ));

      // Update maxFieldLengths.
      final coercedValueLength = value?.length ?? 0;
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

FieldValueModel _lookupFieldValue(
    Map<String, Map<String, FieldValueModel>> fieldValues,
    String fieldId,
    String valueId) {
  if (fieldValues == null ||
      fieldValues.isEmpty ||
      fieldId == null ||
      valueId == null) {
    return null;
  }

  final Map<String, FieldValueModel> valueMap = fieldValues[fieldId];
  if (valueMap == null) {
    return null;
  }

  return valueMap[valueId];
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
