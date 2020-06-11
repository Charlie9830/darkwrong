import 'package:darkwrong/containers/HomeScreenContainer.dart';
import 'package:darkwrong/enums.dart';
import 'package:darkwrong/presentation/fast_table/Cell.dart';
import 'package:darkwrong/presentation/fast_table/CellChangeData.dart';
import 'package:darkwrong/presentation/fast_table/CellId.dart';
import 'package:darkwrong/presentation/fast_table/CellIndex.dart';
import 'package:darkwrong/presentation/fast_table/FastRow.dart';
import 'package:darkwrong/presentation/fast_table/FastTable.dart';
import 'package:darkwrong/presentation/fast_table/TableHeader.dart';
import 'package:darkwrong/redux/AppStore.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:darkwrong/util/valueEnumerators.dart';
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
                onCellValueChanged: _handleCellValueChanged,
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

  void _handleCellValueChanged(
      String newValue,
      CellChangeData activeCellChangeData,
      List<CellChangeData> otherCells,
      CellSelectionDirectionality directionality) {
    final cleanValue = newValue.replaceAll(RegExp(r'\+\+|\-\-/g'), '');

    if (otherCells.isEmpty) {
      // Single Update.
      setState(() {
        _changedCells = Map<CellId, String>.from(_changedCells)
          ..update(activeCellChangeData.id, (value) => cleanValue,
              ifAbsent: () => cleanValue);
      });
      return;
    }

    if (directionality == CellSelectionDirectionality.none) {
      // Value enumeration unavailable.
      final changedCells = Map<CellId, String>.from(_changedCells);
      changedCells[activeCellChangeData.id] = cleanValue;

      changedCells
          .addEntries(otherCells.map((item) => MapEntry(item.id, cleanValue)));

      setState(() {
        _changedCells = changedCells;
      });
    }

    if (directionality == CellSelectionDirectionality.leftToRight ||
        directionality == CellSelectionDirectionality.topToBottom) {
      final changes = [activeCellChangeData, ...otherCells];
      final changedCells = Map<CellId, String>.from(_changedCells);

      int count = 1;
      for (var change in changes) {
        final value = needsEnumeration(newValue)
            ? enumerateValue(newValue, count++)
            : newValue;

        changedCells[change.id] = value;
      }

      setState(() {
        _changedCells = changedCells;
      });
      return;
    }

    if (directionality == CellSelectionDirectionality.rightToLeft ||
        directionality == CellSelectionDirectionality.bottomToTop) {
      final changes = [...otherCells, activeCellChangeData].reversed;
      final changedCells = Map<CellId, String>.from(_changedCells);

      int count = 1;
      for (var change in changes) {
        final value = needsEnumeration(newValue)
            ? enumerateValue(newValue, count++)
            : newValue;

        changedCells[change.id] = value;
      }

      setState(() {
        _changedCells = changedCells;
      });
      return;
    }
  }
}
