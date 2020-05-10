import 'package:darkwrong/models/SelectedCell.dart';
import 'package:darkwrong/models/WorksheetCell.dart';
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
    // return state.copyWith(
    //   rows: Map<String, WorksheetRowModel>.from(state.rows)
    //     ..updateAll((rowKey, rowValue) {
    //       if (action.fixtureUpdates.containsKey(rowKey) == false) {
    //         return rowValue;
    //       }

    //       final fixture = action.fixtureUpdates[rowKey];

    //       return rowValue.copyWith(
    //           cells: Map<String, WorksheetCellModel>.from(rowValue.cells)
    //             ..updateAll((cellKey, cellValue) {
    //               // If current cell Value doesn't equal fixture value, return a new Cell otherwise return existing.
    //               final fixtureValue =
    //                   fixture.getValue(cellValue.columnId).value;

    //               if (cellValue.value != fixtureValue) {
    //                 return cellValue.copyWith(
    //                     value: fixtureValue);
    //               } else {
    //                 return cellValue;
    //               }
    //             }));
    //     }),
    // );
  }

  return state;
}