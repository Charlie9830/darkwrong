import 'package:darkwrong/presentation/fast_table/CellIndex.dart';
import 'package:flutter/foundation.dart';

class WorksheetCellModel {
  final String cellId;
  final String rowId;
  final String columnId;
  final String value;
  final CellIndex index;

  WorksheetCellModel({
    @required this.cellId,
    @required this.index,
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
      index: index ?? this.index,
      rowId: rowId ?? this.rowId,
      columnId: columnId ?? this.columnId,
      value: value ?? this.value,
    );
  }
}
