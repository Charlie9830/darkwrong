import 'package:darkwrong/presentation/fast_table/Cell.dart';
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
    return FastTable(
      headers: viewModel.state.headers.values
          .map((item) => TableHeader(Text(item.title),
              key: Key(item.uid), width: 120.0/* item.maxFieldLength * 8.0 */))
          .toList(),
      rows: viewModel.state.rows.values
          .map((row) => FastRow(
                key: Key(row.rowId),
                children: row.cells.values.map(
                  (cell) {
                    final isSelected =
                        viewModel.state.selectedCells.containsKey(cell.cellId);
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
