import 'package:darkwrong/models/SelectedCell.dart';
import 'package:darkwrong/models/WorksheetHeader.dart';
import 'package:darkwrong/models/WorksheetRow.dart';

class WorksheetState {
  final Map<String, WorksheetRowModel> rows;
  final Map<String, WorksheetHeaderModel> headers;
  final Map<String, SelectedCellModel> selectedCells;

  WorksheetState({
    this.rows,
    this.headers,
    this.selectedCells,
  });

  WorksheetState.initial() :
  rows = <String, WorksheetRowModel>{},
  headers = <String, WorksheetHeaderModel>{},
  selectedCells = <String, SelectedCellModel>{};

  WorksheetState copyWith({
    Map<String, WorksheetRowModel> rows,
    Map<String, WorksheetHeaderModel> headers,
    Map<String, SelectedCellModel> selectedCells,
  }) {
    return WorksheetState(
      rows: rows ?? this.rows,
      headers: headers ?? this.headers,
      selectedCells: selectedCells ?? this.selectedCells,
    );
  }
}