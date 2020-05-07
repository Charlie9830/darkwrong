import 'package:flutter/foundation.dart';

class SelectedCellModel {
  final String rowId;
  final String columnId;

  SelectedCellModel({
    @required this.rowId,
    @required this.columnId,
  });
}