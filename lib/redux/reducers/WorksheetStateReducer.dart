import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/models/SelectedCell.dart';
import 'package:darkwrong/models/WorksheetCell.dart';
import 'package:darkwrong/models/WorksheetHeader.dart';
import 'package:darkwrong/models/WorksheetRow.dart';
import 'package:darkwrong/presentation/fast_table/CellId.dart';
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

  if (action is SetWorksheetSelectedCellIds) {
    return state.copyWith(
      selectedCellIds: action.selectedIds,
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
        headers: _mergeHeaderUpdates(state.headers, action.fieldValues),
        rows: _mergeRowUpdates(
            state.rows, action.fixtureUpdates, action.fieldValues));

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
      selectedCellIds: <CellId>{},
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
    Map<String, WorksheetHeaderModel> headers, FieldValuesStore fieldValues) {
  return headers.map((key, value) {
    final newMaxFieldLength = fieldValues.getMaxFieldLength(key);
    if (fieldValues.containsField(key) &&
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
    FieldValuesStore fieldValues) {
  return rows.map((rowKey, rowValue) {
    // Map through rows and merge in updated fixtures.
    if (fixtureUpdates.containsKey(rowKey)) {
      final fixture = fixtureUpdates[rowKey];
      return MapEntry(
          rowKey, rowValue.copyWith(cells: _buildCells(fixture, fieldValues)));
    }

    return MapEntry(rowKey, rowValue);
  });
}
