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

const columnCount = 4;
const rowCount = 4;

class Darkwrong extends StatefulWidget {
  @override
  _DarkwrongState createState() => _DarkwrongState();
}

class _DarkwrongState extends State<Darkwrong> {
  Set<CellId> _selectedCells = <CellId>{};

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
                onSelectionChanged: (List<CellId> cellIds) {
                  setState(() {
                    _selectedCells = cellIds.toSet();
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
                        final cellId = CellId(rowId: '$i', columnId: '$j');
                        return Cell('($i, $j)',
                            active: _selectedCells.contains(cellId),
                            id: cellId);
                      },
                    ),
                  );
                }),
              ),
            )));
  }
}
