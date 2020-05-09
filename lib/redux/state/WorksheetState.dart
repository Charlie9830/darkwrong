import 'package:darkwrong/models/SelectedCell.dart';
import 'package:darkwrong/models/WorksheetHeader.dart';
import 'package:darkwrong/models/WorksheetRow.dart';

class WorksheetState {
  final List<WorksheetRowModel> rows;
  final List<WorksheetHeaderModel> headers;
  final Map<String, SelectedCellModel> selectedCells;

  WorksheetState({
    this.rows,
    this.headers,
    this.selectedCells,
  });

  WorksheetState.initial() :
  rows = [],
  headers = [],
  selectedCells = {};

  WorksheetState copyWith({
    List<WorksheetRowModel> rows,
    List<WorksheetHeaderModel> headers,
    Map<String, SelectedCellModel> selectedCells,
  }) {
    return WorksheetState(
      rows: rows ?? this.rows,
      headers: headers ?? this.headers,
      selectedCells: selectedCells ?? this.selectedCells,
    );
  }
}