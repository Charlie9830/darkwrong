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
  bool _isActiveCellOpen = false;
  String _activeCellInitialCharacter = '';
  bool _isShiftKeyDown = false;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _columnWidths = widget.headers.map((item) => item.width).toList();
    return Focus(
      focusNode: _focusNode,
      onKey: (focusNode, rawKey) {
        print('rawKey');
        if (_isShiftKeyDown != rawKey.isShiftPressed) {
          setState(() {
            _isShiftKeyDown = rawKey.isShiftPressed;
          });
        }

        if (rawKey.logicalKey.keyLabel != null) {
          setState(() {
            _isActiveCellOpen = true;
            _activeCellInitialCharacter = rawKey.logicalKey.keyLabel;
          });
        }

        return true;
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
                    isActiveCellOpen: _isActiveCellOpen,
                    onEditingComplete: _handleCellEditingComplete,
                    activeCellInitialCharacter: _activeCellInitialCharacter,
                    onCellClicked: _handleCellClicked,
                    onAdjustmentRequested: _handleCellAdjustmentRequested,
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

  void _handleCellEditingComplete() {
    // Restore keyboard focus.
    _focusNode.requestFocus();

    // Reset Active Cell State.
    setState(() {
      _isActiveCellOpen = false;
      _activeCellInitialCharacter = '';
    });
  }

  void _handleCellClicked(CellIndex index) {
    if (_isShiftKeyDown == false) {
      // Exclusive Selection. Re Anchor.
      final newConstraint = CellSelectionConstraint.singleExclusive(index);
      setState(() {
        _selectionConstraint = newConstraint;
        _isActiveCellOpen = false;
        _activeCellInitialCharacter = '';
      });

      _notifyCellSelections(newConstraint.getAllPossibleIndexes());
      return;
    }

    // Adjust Selection Box.
    final newConstraint = _selectionConstraint.adjustWith(incoming: index);
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

  void _handleCellAdjustmentRequested(CellIndex index) {
    // Adjust Selection Box.
    final newConstraint = _selectionConstraint.adjustWith(incoming: index);
    setState(() {
      _selectionConstraint = newConstraint;
    });

    _notifyCellSelections(newConstraint.getAllPossibleIndexes());
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
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
  final CellIndex topLeft;
  final CellIndex bottomRight;
  final CellIndex anchor;

  CellSelectionConstraint({this.anchor, this.topLeft, this.bottomRight});

  const CellSelectionConstraint.zero()
      : topLeft = const CellIndex.zero(),
        bottomRight = const CellIndex.zero(),
        anchor = const CellIndex.zero();

  CellSelectionConstraint.singleExclusive(CellIndex cellIndex)
      : topLeft = cellIndex,
        bottomRight = cellIndex,
        anchor = cellIndex;

  CellSelectionConstraint adjustWith({CellIndex incoming}) {
    if (incoming == anchor) {
      // Single Exclusive.
      return CellSelectionConstraint.singleExclusive(incoming);
    }

    if (incoming.columnIndex >= anchor.columnIndex &&
        incoming.rowIndex >= anchor.rowIndex) {
      // Draw bottom Right Quadrant.
      return CellSelectionConstraint(
          bottomRight: incoming, topLeft: anchor, anchor: anchor);
    }

    if (incoming.columnIndex <= anchor.columnIndex &&
        incoming.rowIndex >= anchor.rowIndex) {
      // Draw bottom Left Quadrant.
      return CellSelectionConstraint(
        bottomRight: CellIndex(
            columnIndex: anchor.columnIndex, rowIndex: incoming.rowIndex),
        topLeft: CellIndex(
            columnIndex: incoming.columnIndex, rowIndex: anchor.rowIndex),
        anchor: anchor,
      );
    }

    if (incoming.columnIndex <= anchor.columnIndex &&
        incoming.rowIndex <= anchor.rowIndex) {
      // Draw top Left Quadrant.
      return CellSelectionConstraint(
        bottomRight: anchor,
        topLeft: incoming,
        anchor: anchor,
      );
    }

    if (incoming.columnIndex >= anchor.columnIndex &&
        incoming.rowIndex <= anchor.rowIndex) {
      // Draw top Right Quadrant
      return CellSelectionConstraint(
        bottomRight: CellIndex(
            columnIndex: incoming.columnIndex, rowIndex: anchor.rowIndex),
        topLeft: CellIndex(
            columnIndex: anchor.columnIndex, rowIndex: incoming.rowIndex),
        anchor: anchor,
      );
    }

    return CellSelectionConstraint.singleExclusive(incoming);
  }

  BorderState getBorderState(CellIndex cellIndex) {
    bool top = false;
    bool right = false;
    bool left = false;
    bool bottom = false;

    // Top
    if (cellIndex.rowIndex == topLeft.rowIndex) {
      top = true;
    }

    // Right
    if (cellIndex.columnIndex == bottomRight.columnIndex) {
      right = true;
    }

    // Bottom
    if (cellIndex.rowIndex == bottomRight.rowIndex) {
      bottom = true;
    }

    // Left
    if (cellIndex.columnIndex == topLeft.columnIndex) {
      left = true;
    }

    return BorderState(top: top, right: right, bottom: bottom, left: left);
  }

  bool satisfiesConstraints(CellIndex cellIndex) {
    return _withinBounds(topLeft.columnIndex, bottomRight.columnIndex,
            cellIndex.columnIndex) && // Hit test X Axis.
        _withinBounds(topLeft.rowIndex, bottomRight.rowIndex,
            cellIndex.rowIndex); // Hit test Y Axis
  }

  bool _withinBounds(int lower, int upper, int point) {
    return point >= lower && point <= upper;
  }

  Set<CellIndex> getAllPossibleIndexes() {
    final returnSet = <CellIndex>{};

    if (topLeft == bottomRight) {
      // Single selection.
      return <CellIndex>{
        CellIndex(columnIndex: topLeft.columnIndex, rowIndex: topLeft.rowIndex)
      };
    }

    final rows = _buildRange(topLeft.rowIndex, bottomRight.rowIndex);
    final columns = _buildRange(topLeft.columnIndex, bottomRight.columnIndex);

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
