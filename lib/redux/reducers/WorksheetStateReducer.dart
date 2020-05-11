import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/models/SelectedCell.dart';
import 'package:darkwrong/models/WorksheetCell.dart';
import 'package:darkwrong/models/WorksheetHeader.dart';
import 'package:darkwrong/models/WorksheetRow.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/WorksheetState.dart';

WorksheetState worksheetStateReducer(WorksheetState state, dynamic action) {
  if (action is RebuildWorksheetState) {
    return state.copyWith(
      headers: action.state.headers,
      rows: action.state.rows,
    );
  }

  if (action is SelectWorksheetCell) {
    return state.copyWith(
        selectedCells: Map<String, SelectedCellModel>.from(state.selectedCells)
          ..addAll({
            action.cellId: SelectedCellModel(
              rowId: action.rowId,
              columnId: action.columnId,
            )
          }));
  }

  if (action is DeselectWorksheetCell) {
    return state.copyWith(
      selectedCells: Map<String, SelectedCellModel>.from(state.selectedCells)
        ..removeWhere((key, value) => key == action.cellId),
    );
  }

  if (action is UpdateFixturesAndFieldValues) {
    final watch = Stopwatch()..start();
    final newState = state.copyWith(
        headers: _mergeHeaderUpdates(state.headers, action.fieldValueUpdates),
        rows: _mergeRowUpdates(state.rows, action.fixtureUpdates,
            action.fieldValueUpdates, action.existingFieldValues));

    watch.stop();

    return newState;
  }

  return state;
}

Map<String, WorksheetHeaderModel> _mergeHeaderUpdates(
    Map<String, WorksheetHeaderModel> headers,
    FieldValuesStore fieldValueUpdates) {
  return headers.map((key, value) {
    final newMaxFieldLength = fieldValueUpdates.getMaxFieldLength(key);
    if (fieldValueUpdates.containsField(key) &&
        newMaxFieldLength > value.maxFieldLength) {
      return MapEntry(
          key,
          value.copyWith(
            maxFieldLength: newMaxFieldLength,
          ));
    } else {
      return MapEntry(key, value);
    }
  });
}

Map<String, WorksheetRowModel> _mergeRowUpdates(
    Map<String, WorksheetRowModel> rows,
    Map<String, FixtureModel> fixtureUpdates,
    FieldValuesStore updatedFieldValues,
    FieldValuesStore existingFieldValues) {
  return rows.map((rowKey, rowValue) {
    // Map through rows and merge in updated fixtures.
    if (fixtureUpdates.containsKey(rowKey)) {
      final fixtureUpdate = fixtureUpdates[rowKey];
      return MapEntry(
          rowKey,
          rowValue.copyWith(
            cells: _mergeCellUpdates(rowValue.cells, fixtureUpdate,
                updatedFieldValues, existingFieldValues),
          ));
    }

    return MapEntry(rowKey, rowValue);
  });
}

Map<String, WorksheetCellModel> _mergeCellUpdates(
    Map<String, WorksheetCellModel> cells,
    FixtureModel fixtureUpdate,
    FieldValuesStore updatedFieldValues,
    FieldValuesStore existingFieldValues) {
  // Map through cells and merge in updated values from the fixtureUpdate by comparing new values to existing values and return new cells accordingly.
  return cells.map((cellKey, cellValue) {
    final valueKey = fixtureUpdate.valueKeys[cellKey];
    if (_compareFixtureValue(cellKey, valueKey, cellValue, updatedFieldValues,
        existingFieldValues)) {
      return MapEntry(
          cellKey,
          cellValue.copyWith(
            // Lookup the value in updatedFieldValues if it's not there fall back to existingFieldValues.
            value: updatedFieldValues.containsValue(cellKey, valueKey)
                ? updatedFieldValues.getValue(cellKey, valueKey).asText
                : existingFieldValues.getValue(cellKey, valueKey).asText,
          ));
    }
    return MapEntry(
      cellKey,
      cellValue,
    );
  });
}

bool _compareFixtureValue(
    String cellKey,
    FieldValueKey valueKey,
    WorksheetCellModel cellValue,
    FieldValuesStore updatedFieldValues,
    FieldValuesStore existingFieldValues) {
  // If the Updated Field Values contains a matching value entry and it differs from the current cell value.
  if (updatedFieldValues.containsValue(cellKey, valueKey) &&
      updatedFieldValues.getValue(cellKey, valueKey).value != cellValue.value) {
    return true;
  }

  // If the Existing Field Values contains a matching value entry and it differs from the current cell value. This covers the case in which
  // a fixture is updated to an already existing value, because the value already exists within fieldValues it will not be added to the updatedFieldValues map as
  // the value itself has not changed just which fixtures it is referenced by.
  if (existingFieldValues.containsValue(cellKey, valueKey) &&
      existingFieldValues.getValue(cellKey, valueKey).value !=
          cellValue.value) {
    return true;
  }

  return false;
}
