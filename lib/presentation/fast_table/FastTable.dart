import 'package:darkwrong/presentation/fast_table/Cell.dart';
import 'package:darkwrong/presentation/fast_table/CellSelectionProvider.dart';
import 'package:darkwrong/presentation/fast_table/ColumnWidthsProvider.dart';
import 'package:darkwrong/presentation/fast_table/FastRow.dart';
import 'package:darkwrong/presentation/fast_table/TableHeader.dart';
import 'package:flutter/services.dart';
import 'package:quiver/core.dart' show hash2;
import 'package:flutter/material.dart';

typedef void CellSelectionChangedCallback(Set<CellIndex> indexes);
typedef void CellValueChangedCallback(String newValue,
    CellChangeData activeCell, List<CellChangeData> otherCells);

class FastTable extends StatefulWidget {
  final List<FastRow> rows;
  final List<TableHeader> headers;
  final TraversalDirection cellTraverseDirection;
  final CellSelectionChangedCallback onSelectionChanged;
  final CellValueChangedCallback onCellValueChanged;
  FastTable(
      {Key key,
      this.rows,
      this.headers,
      this.cellTraverseDirection = TraversalDirection.down,
      this.onCellValueChanged,
      this.onSelectionChanged})
      : super(key: key);

  @override
  _FastTableState createState() => _FastTableState();
}

class _FastTableState extends State<FastTable> {
  FocusNode _focusNode;
  ScrollController _scrollController;
  CellSelectionConstraint _selectionConstraint = CellSelectionConstraint.zero();
  TextEditingController _openCellTextController;
  bool _isActiveCellOpen = false;
  bool _isShiftKeyDown = false;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.requestFocus();

    _openCellTextController = TextEditingController();

    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _columnWidths = widget.headers.map((item) => item.width).toList();

    return Focus(
      focusNode: _focusNode,
      onKey: _handleOnKey,
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
                controller: _scrollController,
                itemCount: widget.rows.length,
                itemBuilder: (context, index) {
                  return CellSelectionProvider(
                    isActiveCellOpen: _isActiveCellOpen,
                    openCellTextController: _openCellTextController,
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

  bool _handleOnKey(FocusNode focusNode, RawKeyEvent rawKey) {
    _setShiftState(rawKey);

    if (rawKey is RawKeyDownEvent) {
      // Arrow Key Presses.
      _handleArrowKeysPress(rawKey);

      // Enter Press
      if (_enterDown(rawKey)) {
        if (_isActiveCellOpen == false) {
          // User wants to open the cell and edit the existing Value.
          // Extract the value from the Cells being passed through (Is this dodgy?).
          final initialText = widget.rows[_selectionConstraint.anchor.rowIndex]
              .children[_selectionConstraint.anchor.columnIndex].text;
          _openActiveCell(initialText);
        } else {
          // User has concluded editing and wants to Commit value.
          _commitValue(_openCellTextController.text, _selectionConstraint);
          _traverseActiveCell(widget.cellTraverseDirection);
        }
      }

      // Backspace Press
      else if (_backspaceDown(rawKey)) {
        if (_isActiveCellOpen == false) {
          _openActiveCell('');
        }
      }

      // Valid Character Press (User started typing a new Value)
      else if (rawKey.logicalKey.keyLabel != null) {
        if (_isActiveCellOpen == false) {
          // User wants to Open cell with a fresh value. ie: They have just started typing the new Value.
          _openActiveCell(rawKey.logicalKey.keyLabel);
        }
      }

      // Escape key
      else if (_escapeDown(rawKey)) {
        if (_isActiveCellOpen == true) {
          // Revert Field.
          _revertActiveCell();
        }
      }
    }

    return true;
  }

  void _commitValue(
      String newValue, CellSelectionConstraint selectionConstraint) {
    _focusNode.requestFocus();
    setState(() {
      _isActiveCellOpen = false;
    });

    _notifyCellValueChanges(newValue, selectionConstraint.anchor,
        selectionConstraint.getAllPossibleIndexes());
  }

  void _traverseActiveCell(TraversalDirection direction) {
    final current = _selectionConstraint.anchor;
    switch (direction) {
      case TraversalDirection.up:
        if (_canTraverseUp(current)) {
          setState(() {
            _selectionConstraint =
                CellSelectionConstraint.singleExclusive(current.movedUp());
          });
        }
        break;
      case TraversalDirection.right:
        if (_canTraverseRight(current)) {
          setState(() {
            _selectionConstraint =
                CellSelectionConstraint.singleExclusive(current.movedRight());
          });
        }
        break;
      case TraversalDirection.down:
        if (_canTraverseDown(current)) {
          setState(() {
            _selectionConstraint =
                CellSelectionConstraint.singleExclusive(current.movedDown());
          });
        }
        break;
      case TraversalDirection.left:
        if (_canTraverseLeft(current)) {
          setState(() {
            _selectionConstraint =
                CellSelectionConstraint.singleExclusive(current.movedLeft());
          });
        }
        break;
    }
  }

  void _handleArrowKeysPress(RawKeyDownEvent rawKey) {
    if (_isActiveCellOpen == false) {
      // Arrow Down
      if (rawKey.logicalKey == LogicalKeyboardKey.arrowDown &&
          _canTraverseDown(_selectionConstraint.anchor)) {
        setState(() {
          _selectionConstraint = CellSelectionConstraint.singleExclusive(
              _selectionConstraint.anchor.movedDown());
        });

        return;
      }

      // Arrow Up
      if (rawKey.logicalKey == LogicalKeyboardKey.arrowUp &&
          _canTraverseUp(_selectionConstraint.anchor)) {
        setState(() {
          _selectionConstraint = CellSelectionConstraint.singleExclusive(
              _selectionConstraint.anchor.movedUp());
        });

        return;
      }

      // Arrow Left
      if (rawKey.logicalKey == LogicalKeyboardKey.arrowLeft &&
          _canTraverseLeft(_selectionConstraint.anchor)) {
        setState(() {
          _selectionConstraint = CellSelectionConstraint.singleExclusive(
              _selectionConstraint.anchor.movedLeft());
        });

        return;
      }

      // Arrow Right
      if (rawKey.logicalKey == LogicalKeyboardKey.arrowRight &&
          _canTraverseRight(_selectionConstraint.anchor)) {
        setState(() {
          _selectionConstraint = CellSelectionConstraint.singleExclusive(
              _selectionConstraint.anchor.movedRight());
        });

        return;
      }
    }
  }

  bool _canTraverseDown(CellIndex current) {
    return current.rowIndex < widget.rows.length - 1;
  }

  bool _canTraverseUp(CellIndex current) {
    return current.rowIndex > 0;
  }

  bool _canTraverseLeft(CellIndex current) {
    return current.columnIndex > 0;
  }

  bool _canTraverseRight(CellIndex current) {
    return current.columnIndex < widget.headers.length - 1;
  }

  void _revertActiveCell() {
    _focusNode.requestFocus();
    setState(() {
      _isActiveCellOpen = false;
    });
  }

  bool _escapeDown(RawKeyDownEvent rawKey) {
    return rawKey.logicalKey == LogicalKeyboardKey.escape;
  }

  bool _backspaceDown(RawKeyDownEvent rawKey) {
    return rawKey.logicalKey == LogicalKeyboardKey.backspace;
  }

  bool _enterDown(RawKeyDownEvent rawKey) {
    return rawKey.logicalKey == LogicalKeyboardKey.enter ||
        rawKey.logicalKey == LogicalKeyboardKey.numpadEnter;
  }

  void _openActiveCell(String initialText) {
    _openCellTextController.text = initialText;
    setState(() {
      _isActiveCellOpen = true;
    });
  }

  void _handleCellClicked(CellIndex index) {
    if (_isShiftKeyDown == false && index != _selectionConstraint.anchor) {
      // Exclusive Selection.
      // Commit existing value if shifting focus from another open cell.
      if (_isActiveCellOpen) {
        _commitValue(_openCellTextController.text, _selectionConstraint);
      }

      // Re anchor to new Cell.
      final newConstraint = CellSelectionConstraint.singleExclusive(index);
      setState(() {
        _selectionConstraint = newConstraint;
        _isActiveCellOpen = false;
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

  void _notifyCellValueChanges(
      String newValue, CellIndex anchor, Set<CellIndex> selectedCellIndex) {
    if (widget.onCellValueChanged == null) {
      return;
    }

    final activeCellChange = CellChangeData(
      index: anchor,
      id: _lookupCellId(anchor),
    );

    final otherCells = selectedCellIndex.toSet()..remove(anchor);
    final otherCellChangeData = otherCells
        .map((item) => CellChangeData(index: item, id: _lookupCellId(item)))
        .toList();

    widget.onCellValueChanged(newValue, activeCellChange, otherCellChangeData);
  }

  CellId _lookupCellId(CellIndex index) {
    return widget.rows[index.rowIndex].children[index.columnIndex].id;
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

  void _setShiftState(RawKeyEvent rawKey) {
    if (rawKey is RawKeyDownEvent) {
      if (rawKey.logicalKey == LogicalKeyboardKey.shiftLeft ||
          rawKey.logicalKey == LogicalKeyboardKey.shiftRight) {
        if (_isShiftKeyDown == false) {
          setState(() {
            _isShiftKeyDown = true;
          });
          return;
        }
      }
    }

    if (rawKey is RawKeyUpEvent) {
      if (rawKey.logicalKey == LogicalKeyboardKey.shiftLeft ||
          rawKey.logicalKey == LogicalKeyboardKey.shiftRight) {
        if (_isShiftKeyDown == true) {
          setState(() {
            _isShiftKeyDown = false;
          });
          return;
        }
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _openCellTextController.dispose();
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

class CellChangeData {
  final CellIndex index;
  final CellId id;

  CellChangeData({
    @required this.index,
    @required this.id,
  });
}
