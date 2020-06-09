import 'package:darkwrong/containers/HomeScreenContainer.dart';
import 'package:darkwrong/presentation/fast_table/Cell.dart';
import 'package:darkwrong/presentation/fast_table/FastRow.dart';
import 'package:darkwrong/presentation/fast_table/FastTable.dart';
import 'package:darkwrong/presentation/fast_table/TableHeader.dart';
import 'package:darkwrong/redux/AppStore.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Darkwrong());
}

const columnCount = 10;
const rowCount = 15;

class Darkwrong extends StatefulWidget {
  @override
  _DarkwrongState createState() => _DarkwrongState();
}

class _DarkwrongState extends State<Darkwrong> {
  Set<CellIndex> _selectedCellIndexes = <CellIndex>{};
  Map<CellId, String> _changedCells = <CellId, String>{};

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: appStore,
        child: MaterialApp(
            title: 'Darkwrong',
            theme: ThemeData(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
              visualDensity: VisualDensity.compact,
            ),
            home: Scaffold(
              appBar: AppBar(title: Text('FastTable')),
              body: FastTable(
                onCellValueChanged:
                    (newValue, activeCellChangeData, otherCells) {
                  setState(() {
                    int enumerator = 1;
                    _changedCells = Map<CellId, String>.from(_changedCells)
                      ..addAll(Map<CellId, String>.fromEntries(otherCells.map(
                          (item) =>
                              MapEntry(item.id, '$newValue ${enumerator++}')))
                        ..addAll({activeCellChangeData.id: newValue}));
                  });
                },
                onSelectionChanged: (Set<CellIndex> cellIndexes) {
                  setState(() {
                    _selectedCellIndexes = cellIndexes;
                  });
                },
                headers: List<TableHeader>.generate(
                    columnCount,
                    (index) => TableHeader(
                          Text('Header $index'),
                          width: 120,
                        )),
                rows: List<FastRow>.generate(rowCount, (i) {
                  return FastRow(
                    yIndex: i,
                    key: Key('$i'),
                    children: List<Cell>.generate(
                      columnCount,
                      (j) {
                        final cellIndex =
                            CellIndex(columnIndex: j, rowIndex: i);
                        final cellId = CellId(rowId: '$i', columnId: '$j');
                        return Cell(
                          _changedCells.containsKey(cellId)
                              ? _changedCells[cellId]
                              : '($i, $j)',
                          index: cellIndex,
                          id: CellId(rowId: '$i', columnId: '$j'),
                        );
                      },
                    ),
                  );
                }),
              ),
            )));
  }
}
