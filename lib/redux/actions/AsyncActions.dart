import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValue.dart';
import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/models/SelectedCell.dart';
import 'package:darkwrong/models/WorksheetCell.dart';
import 'package:darkwrong/models/WorksheetHeader.dart';
import 'package:darkwrong/models/WorksheetRow.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:darkwrong/redux/state/WorksheetState.dart';
import 'package:darkwrong/util/getCellId.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<AppState> updateFixtureValues(
    Map<String, SelectedCellModel> selectedCells, FieldValue newValue) {
  return (Store<AppState> store) async {
    // Iterate through selectedCells, build new updated fixtures and fieldValues as required.
    // If a matching value doesn't already exist within fieldValues, create it. Then attach the fixture to that value.
    final fieldValues = store.state.fixtureState.fieldValues;
    final updatedFieldValues = <String, Map<String, FieldValue>>{};
    final updatedFixtures = <String, FixtureModel>{};

    for (var cell in selectedCells.values) {
      final fixtureId = cell.rowId;
      final fieldId = cell.columnId;
      final fixture = store.state.fixtureState.fixtures[fixtureId];

      if (fieldValues.getValue(fieldId, fixture.values[fieldId].key) == newValue) {
        // No update required.
        continue;
      }

      // If fieldValues doesn't already contain the new value we add it.
      if (fieldValues.containsValue(fieldId, newValue.key) == false) {
        // Ensure a map exists at the fieldId location first.
        if (updatedFieldValues[fieldId] == null) {
          updatedFieldValues[fieldId] = <String, FieldValue>{};
        }

        updatedFieldValues[fieldId][newValue.key] = newValue;
      }

      // Create a new updated Fixture or use an existing one if we have already updated this fixture previously in the loop.
      if (updatedFixtures.containsKey(fixtureId)) {
        updatedFixtures[fixtureId] = updatedFixtures[fixtureId]
            .copyWithUpdatedValue(fieldId, newValue);
      } else {
        updatedFixtures[fixtureId] =
            fixture.copyWithUpdatedValue(fieldId, newValue);
      }
    }

    // Update State.
    store.dispatch(UpdateFixturesAndFieldValues(
      fixtureUpdates: updatedFixtures,
      fieldValueUpdates: FieldValuesStore(valueMap: updatedFieldValues),
      existingFieldValues: store.state.fixtureState.fieldValues,
    ));
  };
}

ThunkAction<AppState> buildWorksheet() {
  return (Store<AppState> store) async {
    final watch = Stopwatch();
    watch.start();
    final worksheet = _buildWorksheet(
        store.state.worksheetState,
        store.state.fixtureState.fixtures,
        store.state.fixtureState.fieldValues,
        store.state.fixtureState.fields);

    print('Completed in ${watch.elapsedMilliseconds}ms');
    watch.stop();
    watch.reset();

    store.dispatch(RebuildWorksheetState(state: worksheet));
  };
}

WorksheetState _buildWorksheet(
    WorksheetState existingWorksheet,
    Map<String, FixtureModel> fixtures,
    FieldValuesStore fieldValuesStore,
    Map<String, FieldModel> fields) {
  final Map<String, WorksheetRowModel> rows = {};
  final Map<String, int> maxFieldLengths = {};
  final displayedFields =
      fields; // Actual implementation of Filtering and sorting to be completed at a later date.

  // Iterate through Fixtures then each Fixtures fieldEntrys to build Cells into the Rows. Also collect the maxFieldLengths.
  for (var fixture in fixtures.values) {
    final String rowId = fixture.uid;
    final Map<String, WorksheetCellModel> cells = {};

    for (var fieldsEntry in displayedFields.entries) {
      // Build the Cell.
      final fieldValue =
          fieldValuesStore.getValue(fieldsEntry.key, fixture.values[fieldsEntry.key].key);

      cells[fieldsEntry.key] = WorksheetCellModel(
        cellId: getCellId(rowId, fieldsEntry.key),
        columnId: fieldsEntry.key,
        rowId: rowId,
        value: fieldValue?.value ?? '',
      );

      // Update maxFieldLengths.
      final coercedValueLength = fieldValue?.length ?? 0;
      if (maxFieldLengths.containsKey(fieldsEntry.key) == false) {
        maxFieldLengths[fieldsEntry.key] = coercedValueLength;
      }

      if (coercedValueLength > maxFieldLengths[fieldsEntry.key]) {
        maxFieldLengths[fieldsEntry.key] = coercedValueLength;
      }
    }

    rows[rowId] = WorksheetRowModel(
      rowId: rowId,
      cells: cells,
    );
  }

  return existingWorksheet.copyWith(
      rows: rows,
      headers: Map<String, WorksheetHeaderModel>.from(existingWorksheet.headers)
        ..updateAll((key, value) {
          return WorksheetHeaderModel(
              uid: key,
              title: value.title,
              maxFieldLength: maxFieldLengths[key] ?? 0);
        }));
}
