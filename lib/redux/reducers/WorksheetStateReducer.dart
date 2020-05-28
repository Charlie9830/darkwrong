import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/models/SelectedCell.dart';
import 'package:darkwrong/models/WorksheetCell.dart';
import 'package:darkwrong/models/WorksheetHeader.dart';
import 'package:darkwrong/models/WorksheetRow.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/WorksheetState.dart';
import 'package:darkwrong/util/getCellId.dart';

WorksheetState worksheetStateReducer(WorksheetState state, dynamic action) {
  if (action is BuildWorksheetState) {
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

  if (action is AddNewFixtures) {
    return state.copyWith(
        rows: Map<String, WorksheetRowModel>.from(state.rows)
          ..addAll(_buildRows(action.fixtures, action.fieldValues)));
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

  if (action is AddWorksheetRows) {
    return state.copyWith(
        rows: Map<String, WorksheetRowModel>.from(state.rows)
          ..addAll(_buildRows(action.fixtures, action.fieldValues)));
  }

  if (action is RemoveWorksheetRows) {
    Map<String, WorksheetRowModel> rows =
        _removeRows(state.rows, action.rowIds);

    return state.copyWith(
      rows: rows,
      selectedCells: <String, SelectedCellModel>{},
    );
  }

  if (action is SelectFieldQueryId) {
    return state.copyWith(
      selectedFieldQueryId: action.fieldId,
    );
  }

  if (action is AddFieldValueQueries) {
    final fieldValueQueries = Set<FieldValueKey>.from(state.fieldValueQueries)
      ..addAll(action.valueKeys);

    final fixtureIds =
        _queryFixtures(action.fixtures, action.fieldId, fieldValueQueries);
    final fixturesToAdd = Map<String, FixtureModel>.fromEntries(
        fixtureIds.map((item) => MapEntry(item, action.fixtures[item])));

    return state.copyWith(
      fieldValueQueries: fieldValueQueries,
      rows: _buildRows(fixturesToAdd, action.fieldValues),
    );
  }

  if (action is RemoveFieldValueQueries) {
    final fieldValueQueries = Set<FieldValueKey>.from(state.fieldValueQueries)
      ..removeAll(action.valueKeys);

    // If fieldValueQueries is about to be emptied, we are falling back to the 'All' option. So just return all rows.
    if (fieldValueQueries.isEmpty) {
      return state.copyWith(
        fieldValueQueries: fieldValueQueries,
        rows: _buildRows(action.fixtures, action.fieldValues),
      );
    }

    // fieldValueQueries isn't empty so we need to query for and re add the fixtures.
    final fixtureIds =
        _queryFixtures(action.fixtures, action.fieldId, action.valueKeys);

    return state.copyWith(
        fieldValueQueries: fieldValueQueries,
        rows: _removeRows(state.rows, fixtureIds));
  }

  return state;
}

Map<String, WorksheetRowModel> _removeRows(
    Map<String, WorksheetRowModel> existingRows, Iterable<String> rowIds) {
  final rows = Map<String, WorksheetRowModel>.from(existingRows);
  for (var fixtureId in rowIds) {
    rows.remove(fixtureId);
  }

  return rows;
}

///
/// Returns a Set of fixtureIds that contain valueKey within their targetFieldId.
///
Set<String> _queryFixtures(Map<String, FixtureModel> fixtures,
    String targetFieldId, Set<FieldValueKey> valueKeys) {
  return fixtures.values
      .where(
          (fixture) => fixture.containsFieldValueKeys(targetFieldId, valueKeys))
      .map((fixture) => fixture.uid)
      .toSet();
}

Map<String, WorksheetRowModel> _buildRows(
    Map<String, FixtureModel> fixtures, FieldValuesStore fieldValues) {
  return Map<String, WorksheetRowModel>.fromEntries(
      fixtures.values.map((fixture) {
    return MapEntry(
      fixture.uid,
      WorksheetRowModel(
        rowId: fixture.uid,
        cells: _buildCells(fixture, fieldValues),
      ),
    );
  }));
}

Map<String, WorksheetCellModel> _buildCells(
    FixtureModel fixture, FieldValuesStore fieldValues) {
  return Map<String, WorksheetCellModel>.fromEntries(
      fixture.valueKeys.entries.map((valueEntry) {
    final rowId = fixture.uid;
    final fieldId = valueEntry.key;
    final cellValue =
        fieldValues.getValue(valueEntry.key, valueEntry.value).asText;

    return MapEntry(
        valueEntry.key,
        WorksheetCellModel(
            cellId: getCellId(rowId, fieldId),
            rowId: rowId,
            columnId: fieldId,
            value: cellValue));
  }));
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
      updatedFieldValues.getValue(cellKey, valueKey).primaryValue != cellValue.value) {
    return true;
  }

  // If the Existing Field Values contains a matching value entry and it differs from the current cell value. This covers the case in which
  // a fixture is updated to an already existing value, because the value already exists within fieldValues it will not be added to the updatedFieldValues map as
  // the value itself has not changed just which fixtures it is referenced by.
  if (existingFieldValues.containsValue(cellKey, valueKey) &&
      existingFieldValues.getValue(cellKey, valueKey).primaryValue !=
          cellValue.value) {
    return true;
  }

  return false;
}
