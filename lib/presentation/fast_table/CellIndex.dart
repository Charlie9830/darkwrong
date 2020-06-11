import 'package:meta/meta.dart';
import 'package:quiver/core.dart' show hash2;

class CellIndex {
  final int columnIndex;
  final int rowIndex;

  const CellIndex({@required this.columnIndex, @required this.rowIndex});

  const CellIndex.zero()
      : columnIndex = 0,
        rowIndex = 0;

  CellIndex movedLeft() {
    return CellIndex(
      columnIndex: columnIndex - 1,
      rowIndex: rowIndex,
    );
  }

  CellIndex movedRight() {
    return CellIndex(
      columnIndex: columnIndex + 1,
      rowIndex: rowIndex,
    );
  }

  CellIndex movedDown() {
    return CellIndex(
      columnIndex: columnIndex,
      rowIndex: rowIndex + 1,
    );
  }

  CellIndex movedUp() {
    return CellIndex(
      columnIndex: columnIndex,
      rowIndex: rowIndex - 1,
    );
  }

  operator ==(Object o) {
    return o is CellIndex &&
        o.columnIndex == columnIndex &&
        o.rowIndex == rowIndex;
  }

  @override
  int get hashCode => hash2(columnIndex, rowIndex);
}