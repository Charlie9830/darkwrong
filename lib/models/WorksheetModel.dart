import 'package:darkwrong/models/SelectedCell.dart';
import 'package:darkwrong/models/WorksheetHeader.dart';
import 'package:darkwrong/models/WorksheetRow.dart';

class WorksheetModel {
  final List<WorksheetRowModel> rows;
  final List<WorksheetHeaderModel> headers;
  final Map<String, SelectedCellModel> selectedCells;

  WorksheetModel({
    this.rows,
    this.headers,
    this.selectedCells,
  });

  WorksheetModel.initial() :
  rows = [],
  headers = [],
  selectedCells = {};

  WorksheetModel copyWith({
    List<WorksheetRowModel> rows,
    List<WorksheetHeaderModel> headers,
    Map<String, SelectedCellModel> selectedCells,
  }) {
    return WorksheetModel(
      rows: rows ?? this.rows,
      headers: headers ?? this.headers,
      selectedCells: selectedCells ?? this.selectedCells,
    );
  }
}