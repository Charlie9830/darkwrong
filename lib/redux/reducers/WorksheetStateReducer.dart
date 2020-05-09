import 'package:darkwrong/models/SelectedCell.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/WorksheetState.dart';

WorksheetState worksheetStateReducer(WorksheetState state, dynamic action) {
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

  return state;
}

// WorksheetModel _rebuildWorksheet(
//     WorksheetModel existingWorksheet,
//     Map<String, FixtureModel> fixtures,
//     Map<String, Map<String, FieldValue>> fieldValues,
//     Map<String, FieldModel> fields) {
//   final List<WorksheetRowModel> rows = [];
//   final Map<String, int> maxFieldLengths = {};
//   final displayedFields =
//       fields; // Actual implementation of Filtering and sorting to be completed at a later date.

//   // Iterate through Fixtures then each Fixtures fieldEntrys to build Cells into the Rows. Also collect the maxFieldLengths.
//   for (var fixture in fixtures.values) {
//     final String rowId = fixture.uid;
//     final List<WorksheetCellModel> cells = [];

//     for (var fieldsEntry in displayedFields.entries) {
//       // Build the Cell.
//       final fieldValue = fixture.values[fieldsEntry.key];

//       cells.add(WorksheetCellModel(
//         cellId: getCellId(rowId, fieldsEntry.key),
//         columnId: fieldsEntry.key,
//         rowId: rowId,
//         value: fieldValue?.value ?? '',
//       ));

//       // Update maxFieldLengths.
//       final coercedValueLength = fieldValue?.length ?? 0;
//       if (maxFieldLengths.containsKey(fieldsEntry.key) == false) {
//         maxFieldLengths[fieldsEntry.key] = coercedValueLength;
//       }

//       if (coercedValueLength > maxFieldLengths[fieldsEntry.key]) {
//         maxFieldLengths[fieldsEntry.key] = coercedValueLength;
//       }
//     }

//     rows.add(WorksheetRowModel(
//       rowId: rowId,
//       cells: cells,
//     ));
//   }

//   return existingWorksheet.copyWith(
//     rows: rows,
//     headers: displayedFields.entries.map((entry) {
//       return WorksheetHeaderModel(
//           uid: entry.key,
//           title: entry.value.name,
//           maxFieldLength: maxFieldLengths[entry.key] ?? 0);
//     }).toList(),
//   );
// }
