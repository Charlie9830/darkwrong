import 'package:darkwrong/models/WorksheetCell.dart';
import 'package:flutter/foundation.dart';

class WorksheetRowModel {
  final String rowId;
  final Map<String, WorksheetCellModel> cells;

  WorksheetRowModel({
    @required this.rowId,
    this.cells,
  });

  WorksheetRowModel copyWith({
    String rowId,
    Map<String, WorksheetCellModel> cells,
  }) {
    return WorksheetRowModel(
      rowId: rowId ?? this.rowId,
      cells: cells ?? this.cells,
    );
  }
}
