import 'package:darkwrong/models/WorksheetCell.dart';
import 'package:darkwrong/presentation/fast_table/Cell.dart';
import 'package:darkwrong/presentation/fast_table/CellId.dart';
import 'package:darkwrong/presentation/fast_table/CellIndex.dart';
import 'package:darkwrong/presentation/fast_table/FastRow.dart';
import 'package:darkwrong/presentation/fast_table/FastTable.dart';
import 'package:darkwrong/presentation/fast_table/TableHeader.dart';
import 'package:darkwrong/view_models/WorksheetViewModel.dart';
import 'package:flutter/material.dart';

class Worksheet extends StatelessWidget {
  final WorksheetViewModel viewModel;

  const Worksheet({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int rowIndex = 0;
    return FastTable(
      onCellValueChanged: viewModel.onCellValueChanged,
      onSelectionChanged: viewModel.onCellSelectionChanged,
      headers: viewModel.state.headers.values
          .map((item) => TableHeader(Text(item.title),
              key: Key(item.uid), width: 120.0 /* item.maxFieldLength * 8.0 */))
          .toList(),
      rows: viewModel.state.rows.values.map((row) {
        return FastRow(
          key: Key(row.rowId),
          yIndex:
              rowIndex++, // You call rowIndex - 1 below. Making these lines of Code order sensitive.
          children: _mapCells(row.cells.values, rowIndex - 1),
        );
      }).toList(),
    );
  }

  List<Cell> _mapCells(Iterable<WorksheetCellModel> cells, int rowIndex) {
    int columnIndex = 0;
    return cells.map((cell) {
      return Cell(
        cell.value,
        key: Key(cell.cellId),
        id: CellId(columnId: cell.columnId, rowId: cell.rowId),
        index: CellIndex(columnIndex: columnIndex++, rowIndex: rowIndex),
      );
    }).toList();
  }
}
