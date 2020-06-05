import 'package:darkwrong/presentation/fast_table/CellSelectionProvider.dart';
import 'package:darkwrong/presentation/fast_table/ColumnWidthsProvider.dart';
import 'package:darkwrong/presentation/fast_table/FastRow.dart';
import 'package:darkwrong/presentation/fast_table/TableHeader.dart';
import 'package:quiver/core.dart' show hash2;
import 'package:flutter/material.dart';

typedef void CellSelectionChangedCallback(Set<CellIndex> indexes);

class FastTable extends StatefulWidget {
  final List<FastRow> rows;
  final List<TableHeader> headers;
  final CellSelectionChangedCallback onSelectionChanged;
  FastTable({Key key, this.rows, this.headers, this.onSelectionChanged})
      : super(key: key);

  @override
  _FastTableState createState() => _FastTableState();
}

class _FastTableState extends State<FastTable> {
  FocusNode _focusNode;
  CellSelectionConstraint _selectionConstraint = CellSelectionConstraint.zero();
  bool _isShiftKeyDown = false;

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _columnWidths = widget.headers.map((item) => item.width).toList();
    return RawKeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKey: (rawKey) {
        if (_isShiftKeyDown != rawKey.isShiftPressed) {
          setState(() {
            _isShiftKeyDown = rawKey.isShiftPressed;
          });
        }
      },
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: Row(
              children: widget.headers,
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: widget.rows.length,
                itemBuilder: (context, index) {
                  return CellSelectionProvider(
                    onCellClicked: _handleCellClicked,
                    selectionConstraint: _selectionConstraint,
                    child: ColumnWidthsProvider(
                      key: widget.rows[index].key,
                      widths: _columnWidths,
                      child: widget.rows[index],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  void _handleCellClicked(CellIndex index) {
    if (_isShiftKeyDown == false) {
      // Exclusive Selection.
      final newConstraint = CellSelectionConstraint.singleExclusive(index);
      setState(() {
        _selectionConstraint = newConstraint;
      });

      _notifyCellSelections(newConstraint.getAllPossibleIndexes());
      return;
    }

    if (index.columnIndex == _selectionConstraint.upperLeft.columnIndex &&
        index.rowIndex == _selectionConstraint.upperLeft.rowIndex) {
      // Do nothing.
      return;
    }

    final newConstraint = _selectionConstraint.copyWith(b: index);
    setState(() {
      _selectionConstraint = newConstraint;
    });

    _notifyCellSelections(newConstraint.getAllPossibleIndexes());
  }

  void _notifyCellSelections(Set<CellIndex> cellIndexes) {
    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged(cellIndexes);
    }
  }
}

class BorderState {
  final bool top;
  final bool right;
  final bool bottom;
  final bool left;

  BorderState({
    this.top = false,
    this.right = false,
    this.bottom = false,
    this.left = false,
  });
}

class CellIndex {
  final int columnIndex;
  final int rowIndex;

  const CellIndex({@required this.columnIndex, @required this.rowIndex});

  const CellIndex.zero()
      : columnIndex = 0,
        rowIndex = 0;

  operator ==(Object o) {
    return o is CellIndex &&
        o.columnIndex == columnIndex &&
        o.rowIndex == rowIndex;
  }

  @override
  int get hashCode => hash2(columnIndex, rowIndex);
}

class CellSelectionConstraint {
  final CellIndex upperLeft;
  final CellIndex lowerRight;

  CellSelectionConstraint({CellIndex a, CellIndex b})
      : upperLeft = _getUpperLeft(a, b),
        lowerRight = _getLowerRight(a, b);

  const CellSelectionConstraint.zero()
      : upperLeft = const CellIndex.zero(),
        lowerRight = const CellIndex.zero();

  CellSelectionConstraint.singleExclusive(CellIndex cellIndex)
      : upperLeft = cellIndex,
        lowerRight = cellIndex;

  CellSelectionConstraint copyWith({
    CellIndex a,
    CellIndex b,
  }) {
    return CellSelectionConstraint(
        a: a ?? this.upperLeft, b: b ?? this.lowerRight);
  }

  BorderState getBorderState(CellIndex cellIndex) {
    bool top = false;
    bool right = false;
    bool left = false;
    bool bottom = false;

    // Top
    if (cellIndex.rowIndex == upperLeft.rowIndex) {
      top = true;
    }

    // Right
    if (cellIndex.columnIndex == lowerRight.columnIndex) {
      right = true;
    }

    // Bottom
    if (cellIndex.rowIndex == lowerRight.rowIndex) {
      bottom = true;
    }

    // Left
    if (cellIndex.columnIndex == upperLeft.columnIndex) {
      left = true;
    }

    return BorderState(top: top, right: right, bottom: bottom, left: left);
  }

  bool satisfiesConstraints(CellIndex cellIndex) {
    return _withinBounds(upperLeft.columnIndex, lowerRight.columnIndex,
            cellIndex.columnIndex) && // Hit test X Axis.
        _withinBounds(upperLeft.rowIndex, lowerRight.rowIndex,
            cellIndex.rowIndex); // Hit test Y Axis
  }

  bool _withinBounds(int lower, int upper, int point) {
    return point >= lower && point <= upper;
  }

  Set<CellIndex> getAllPossibleIndexes() {
    final returnSet = <CellIndex>{};

    if (upperLeft == lowerRight) {
      // Single selection.
      return <CellIndex>{
        CellIndex(
            columnIndex: upperLeft.columnIndex, rowIndex: upperLeft.rowIndex)
      };
    }

    final rows = _buildRange(upperLeft.rowIndex, lowerRight.rowIndex);
    final columns = _buildRange(upperLeft.columnIndex, lowerRight.columnIndex);

    for (var rowIndex in rows) {
      returnSet.addAll(columns.map((columnIndex) =>
          CellIndex(columnIndex: columnIndex, rowIndex: rowIndex)));
    }

    return returnSet;
  }

  List<int> _buildRange(int from, int to) {
    return List<int>.generate((to - from) + 1, (index) => from + index);
  }

  static CellIndex _getUpperLeft(CellIndex a, CellIndex b) {
    if (a.columnIndex <= b.columnIndex && a.rowIndex <= b.rowIndex) {
      return a;
    } else {
      return b;
    }
  }

  static CellIndex _getLowerRight(CellIndex a, CellIndex b) {
    if (a.columnIndex >= b.columnIndex && a.rowIndex >= b.rowIndex) {
      return a;
    } else {
      return b;
    }
  }
}
