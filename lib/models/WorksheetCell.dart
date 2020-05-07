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
}