import 'package:darkwrong/presentation/fast_table/CellIndex.dart';
import 'package:flutter/foundation.dart';

class WorksheetCellModel {
  final String cellId;
  final String rowId;
  final String columnId;
  final String value;

  WorksheetCellModel({
    @required this.cellId,
    this.rowId,
    this.columnId,
    this.value = '',
  });

  WorksheetCellModel copyWith({
    String cellId,
    CellIndex index,
    String rowId,
    String columnId,
    String value,
  }) {
    return WorksheetCellModel(
      cellId: cellId ?? this.cellId,
      rowId: rowId ?? this.rowId,
      columnId: columnId ?? this.columnId,
      value: value ?? this.value,
    );
  }
}
