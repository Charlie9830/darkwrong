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
    // Adjusts the Selection Constraints based on which Arrow Key was pressed and if the Shift key was down at the time.
    // If no shift key is down we re anchor the Cell towards the direction of pressed arrow (If Travsersal is possible).
    // If the shift key is down we adjust the size of the Selection constraint based on which side of the Anchor the selection contraint extends from.
    // Eg if the selection box extends to the right of the Anchor and a Right arrow is pressed, we Expand the box (if Traversal is Possible), if the box extends to the left
    // of the Anchor, we shrink the constraint.

    if (_isActiveCellOpen == true) {
      return;
    }

    final CellIndex anchor = _selectionConstraint.anchor;
    if (rawKey.isShiftPressed) {
      // Shift + Arrow Key
      _handleShiftArrowKeysPressed(rawKey, anchor);
      return;
    }

    final updateConstraint = (CellIndex incoming) {
      setState(() {
        _selectionConstraint = CellSelectionConstraint.singleExclusive(
          incoming,
        );
      });
    };

    // Naked Arrow Right.
    if (rawKey.logicalKey == LogicalKeyboardKey.arrowRight &&
        _canTraverseRight(anchor)) {
      updateConstraint(anchor.movedRight());
      return;
    }

    // Naked Arrow Left.
    if (rawKey.logicalKey == LogicalKeyboardKey.arrowLeft &&
        _canTraverseLeft(anchor)) {
      updateConstraint(anchor.movedLeft());
      return;
    }

    // Naked Arrow Up.
    if (rawKey.logicalKey == LogicalKeyboardKey.arrowUp &&
        _canTraverseUp(anchor)) {
      updateConstraint(anchor.movedUp());
      return;
    }

    // Naked Arrow Down.
    if (rawKey.logicalKey == LogicalKeyboardKey.arrowDown &&
        _canTraverseDown(anchor)) {
      updateConstraint(anchor.movedDown());
      return;
    }
  }

  void _handleShiftArrowKeysPressed(
    RawKeyDownEvent rawKey,
    CellIndex anchor,
  ) {
    final CellIndex topLeft = _selectionConstraint.topLeft;
    final CellIndex topRight = _selectionConstraint.topRight;
    final CellIndex bottomRight = _selectionConstraint.bottomRight;
    final CellIndex bottomLeft = _selectionConstraint.bottomLeft;
    final _RelativeAnchorLocation anchorLocation =
        _selectionConstraint.getRelativeAnchorLocation();
    final key = rawKey.logicalKey;

    final updateConstraint = (CellIndex incoming) {
      setState(() {
        _selectionConstraint = _selectionConstraint.adjustWith(
          incoming: incoming,
        );
      });
    };

    // Arrow Up
    if (key == LogicalKeyboardKey.arrowUp) {
      // Expanding
      if (anchorLocation == _RelativeAnchorLocation.centered &&
          _canTraverseUp(anchor)) {
        updateConstraint(anchor.movedUp());
        return;
      }

      if (anchorLocation == _RelativeAnchorLocation.bottomRight &&
          _canTraverseUp(topLeft)) {
        updateConstraint(topLeft.movedUp());
        return;
      }

      if (anchorLocation == _RelativeAnchorLocation.bottomLeft &&
          _canTraverseUp(topRight)) {
        updateConstraint(topRight.movedUp());
        return;
      }

      // Shrinking.
      if (anchorLocation == _RelativeAnchorLocation.topRight) {
        updateConstraint(bottomLeft.movedUp());
        return;
      }

      if (anchorLocation == _RelativeAnchorLocation.topLeft) {
        updateConstraint(bottomRight.movedUp());
        return;
      }
    }

    // Arrow Down
    if (key == LogicalKeyboardKey.arrowDown) {
      // Expanding
      if (anchorLocation == _RelativeAnchorLocation.centered &&
          _canTraverseDown(anchor)) {
        updateConstraint(anchor.movedDown());
        return;
      }

      if (anchorLocation == _RelativeAnchorLocation.topRight &&
          _canTraverseDown(bottomLeft)) {
        updateConstraint(bottomLeft.movedDown());
        return;
      }

      if (anchorLocation == _RelativeAnchorLocation.topLeft &&
          _canTraverseDown(bottomRight)) {
        updateConstraint(bottomRight.movedDown());
        return;
      }

      // Shrinking.
      if (anchorLocation == _RelativeAnchorLocation.bottomRight) {
        updateConstraint(topLeft.movedDown());
        return;
      }

      if (anchorLocation == _RelativeAnchorLocation.bottomLeft) {
        updateConstraint(topRight.movedDown());
        return;
      }
    }

    // Arrow Left
    if (key == LogicalKeyboardKey.arrowLeft) {
      // Expanding
      if (anchorLocation == _RelativeAnchorLocation.centered &&
          _canTraverseLeft(anchor)) {
        updateConstraint(anchor.movedLeft());
        return;
      }

      if (anchorLocation == _RelativeAnchorLocation.topRight &&
          _canTraverseLeft(bottomLeft)) {
        updateConstraint(bottomLeft.movedLeft());
        return;
      }

      if (anchorLocation == _RelativeAnchorLocation.bottomRight &&
          _canTraverseLeft(topLeft)) {
        updateConstraint(topLeft.movedLeft());
        return;
      }

      // Shrinking.
      if (anchorLocation == _RelativeAnchorLocation.topLeft) {
        updateConstraint(bottomRight.movedLeft());
        return;
      }
      if (anchorLocation == _RelativeAnchorLocation.bottomLeft) {
        updateConstraint(topRight.movedLeft());
        return;
      }
    }

    // Arrow Right
    if (key == LogicalKeyboardKey.arrowRight) {
      // Expansion
      if (anchorLocation == _RelativeAnchorLocation.centered &&
          _canTraverseRight(anchor)) {
        updateConstraint(anchor.movedRight());
        return;
      }
      if (anchorLocation == _RelativeAnchorLocation.topLeft &&
          _canTraverseRight(bottomRight)) {
        updateConstraint(bottomRight.movedRight());
        return;
      }
      if (anchorLocation == _RelativeAnchorLocation.bottomLeft &&
          _canTraverseRight(topRight)) {
        updateConstraint(topRight.movedRight());
        return;
      }

      // Shrinking.
      if (anchorLocation == _RelativeAnchorLocation.topRight) {
        updateConstraint(bottomLeft.movedRight());
        return;
      }

      if (anchorLocation == _RelativeAnchorLocation.bottomRight) {
        updateConstraint(topLeft.movedRight());
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
        .toList()
          ..sort();

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

enum _RelativeAnchorLocation {
  topLeft,
  topRight,
  bottomRight,
  bottomLeft,
  centered
}

class CellSelectionConstraint {
  final CellIndex topLeft;
  final CellIndex bottomRight;
  final CellIndex anchor;

  CellIndex get bottomLeft => CellIndex(
      columnIndex: topLeft.columnIndex, rowIndex: bottomRight.rowIndex);
  CellIndex get topRight => CellIndex(
      columnIndex: bottomRight.columnIndex, rowIndex: topLeft.rowIndex);

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

  _RelativeAnchorLocation getRelativeAnchorLocation() {
    if (topLeft == bottomRight && topLeft == anchor) {
      // Single Exclusive.
      return _RelativeAnchorLocation.centered;
    }

    if (topLeft == anchor) {
      return _RelativeAnchorLocation.topLeft;
    }

    if (bottomRight == anchor) {
      return _RelativeAnchorLocation.bottomRight;
    }

    if (topRight == anchor) {
      return _RelativeAnchorLocation.topRight;
    } else {
      return _RelativeAnchorLocation.bottomLeft;
    }
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
}

class CellChangeData implements Comparable {
  final CellIndex index;
  final CellId id;

  CellChangeData({
    @required this.index,
    @required this.id,
  });

  @override
  int compareTo(other) {
    if (other is CellChangeData) {
      if (other.index.rowIndex != this.index.rowIndex) {
        return this.index.rowIndex - other.index.rowIndex;
      }

      return this.index.columnIndex - other.index.columnIndex;
    }

    throw FormatException('Other is not of type CellChangeData');
  }
}
