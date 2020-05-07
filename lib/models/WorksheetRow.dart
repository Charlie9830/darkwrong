import 'package:darkwrong/models/WorksheetCell.dart';
import 'package:flutter/foundation.dart';

class WorksheetRowModel {
  final String rowId;
  final List<WorksheetCellModel> cells;

  WorksheetRowModel({
    @required this.rowId,
    this.cells,
  });
}