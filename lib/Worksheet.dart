import 'package:darkwrong/Cell.dart';
import 'package:darkwrong/FastRow.dart';
import 'package:darkwrong/FastTable.dart';
import 'package:darkwrong/TableHeader.dart';
import 'package:darkwrong/view_models/WorksheetViewModel.dart';
import 'package:flutter/material.dart';

class Worksheet extends StatelessWidget {
  final WorksheetViewModel viewModel;

  const Worksheet({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FastTable(
      headers: viewModel.data.headers
          .map((item) => TableHeader(Text(item.title),
              key: Key(item.uid), width: item.maxFieldLength * 8.0))
          .toList(),
      rows: viewModel.data.rows
          .map((row) => FastRow(
                key: Key(row.rowId),
                children: row.cells.map(
                  (cell) {
                    final isSelected =
                        viewModel.data.selectedCells.containsKey(cell.cellId);
                    return Cell(cell.value,
                        key: Key(cell.cellId),
                        isSelected: isSelected,
                        onClick: isSelected
                            ? () => viewModel.onCellDeselect(
                                row.rowId, cell.columnId, cell.cellId)
                            : () => viewModel.onCellSelect(
                                row.rowId, cell.columnId, cell.cellId));
                  },
                ).toList(),
              ))
          .toList(),
    );
  }
}
