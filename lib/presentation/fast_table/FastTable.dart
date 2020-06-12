import 'package:darkwrong/enums.dart';
import 'package:darkwrong/presentation/fast_table/CellChangeData.dart';
import 'package:darkwrong/presentation/fast_table/CellId.dart';
import 'package:darkwrong/presentation/fast_table/CellIndex.dart';
import 'package:darkwrong/presentation/fast_table/CellSelectionConstraint.dart';
import 'package:darkwrong/presentation/fast_table/CellSelectionProvider.dart';
import 'package:darkwrong/presentation/fast_table/CellTextEditingController.dart';
import 'package:darkwrong/presentation/fast_table/ColumnWidthsProvider.dart';
import 'package:darkwrong/presentation/fast_table/FastRow.dart';
import 'package:darkwrong/presentation/fast_table/TableHeader.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

typedef void CellSelectionChangedCallback(Set<CellId> ids);
typedef void CellValueChangedCallback(
    String newValue,
    CellChangeData activeCell,
    List<CellChangeData> otherCells,
    CellSelectionDirectionality directionality);

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
  CellTextEditingController _openCellTextController;
  bool _isActiveCellOpen = false;
  bool _isShiftKeyDown = false;
  bool _isControlDown = false;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.requestFocus();

    _openCellTextController = CellTextEditingController();

    _scrollController = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _columnWidths = widget.headers.map((item) => item.width).toList();

    return Listener(
      onPointerDown: (_) {
        if (_isActiveCellOpen == false) {
          _focusNode.requestFocus();
        }
      },
      child: Focus(
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
      ),
    );
  }

  void clearSelections() {
    setState(() {
      _selectionConstraint = CellSelectionConstraint.zero();
      _isActiveCellOpen = false;
    });
  }

  bool _handleOnKey(FocusNode focusNode, RawKeyEvent rawKey) {
    _setShiftState(rawKey);
    _setControlState(rawKey);

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

    _notifyCellValueChanges(
        newValue,
        selectionConstraint.anchor,
        selectionConstraint.getAllPossibleIndexes(),
        selectionConstraint.getSelectionDirectionality());
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
    if (rawKey.logicalKey == LogicalKeyboardKey.arrowRight) {
      if (_canTraverseRight(anchor)) {
        updateConstraint(anchor.movedRight());
        return;
      }

      if (!_selectionConstraint.isSingleExclusive) {
        // Shrink down to Exclusive Selection.
        updateConstraint(anchor);
        return;
      }
    }

    // Naked Arrow Left.
    if (rawKey.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (_canTraverseLeft(anchor)) {
        updateConstraint(anchor.movedLeft());
        return;
      }

      if (!_selectionConstraint.isSingleExclusive) {
        // Shrink down to Exclusive Selection.
        updateConstraint(anchor);
        return;
      }
    }

    // Naked Arrow Up.
    if (rawKey.logicalKey == LogicalKeyboardKey.arrowUp) {
      if (_canTraverseUp(anchor)) {
        updateConstraint(anchor.movedUp());
        return;
      }

      if (!_selectionConstraint.isSingleExclusive) {
        // Shrink down to Exclusive Selection.
        updateConstraint(anchor);
        return;
      }
    }

    // Naked Arrow Down.
    if (rawKey.logicalKey == LogicalKeyboardKey.arrowDown) {
      if (_canTraverseDown(anchor)) {
        updateConstraint(anchor.movedDown());
        return;
      }

      if (!_selectionConstraint.isSingleExclusive) {
        // Shrink down to Exclusive Selection.
        updateConstraint(anchor);
        return;
      }
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
    final RelativeAnchorLocation anchorLocation =
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
      if (anchorLocation == RelativeAnchorLocation.centered &&
          _canTraverseUp(anchor)) {
        updateConstraint(anchor.movedUp());
        return;
      }

      if (anchorLocation == RelativeAnchorLocation.bottomRight &&
          _canTraverseUp(topLeft)) {
        updateConstraint(topLeft.movedUp());
        return;
      }

      if (anchorLocation == RelativeAnchorLocation.bottomLeft &&
          _canTraverseUp(topRight)) {
        updateConstraint(topRight.movedUp());
        return;
      }

      // Shrinking.
      if (anchorLocation == RelativeAnchorLocation.topRight) {
        updateConstraint(bottomLeft.movedUp());
        return;
      }

      if (anchorLocation == RelativeAnchorLocation.topLeft) {
        updateConstraint(bottomRight.movedUp());
        return;
      }
    }

    // Arrow Down
    if (key == LogicalKeyboardKey.arrowDown) {
      // Expanding
      if (anchorLocation == RelativeAnchorLocation.centered &&
          _canTraverseDown(anchor)) {
        updateConstraint(anchor.movedDown());
        return;
      }

      if (anchorLocation == RelativeAnchorLocation.topRight &&
          _canTraverseDown(bottomLeft)) {
        updateConstraint(bottomLeft.movedDown());
        return;
      }

      if (anchorLocation == RelativeAnchorLocation.topLeft &&
          _canTraverseDown(bottomRight)) {
        updateConstraint(bottomRight.movedDown());
        return;
      }

      // Shrinking.
      if (anchorLocation == RelativeAnchorLocation.bottomRight) {
        updateConstraint(topLeft.movedDown());
        return;
      }

      if (anchorLocation == RelativeAnchorLocation.bottomLeft) {
        updateConstraint(topRight.movedDown());
        return;
      }
    }

    // Arrow Left
    if (key == LogicalKeyboardKey.arrowLeft) {
      // Expanding
      if (anchorLocation == RelativeAnchorLocation.centered &&
          _canTraverseLeft(anchor)) {
        updateConstraint(anchor.movedLeft());
        return;
      }

      if (anchorLocation == RelativeAnchorLocation.topRight &&
          _canTraverseLeft(bottomLeft)) {
        updateConstraint(bottomLeft.movedLeft());
        return;
      }

      if (anchorLocation == RelativeAnchorLocation.bottomRight &&
          _canTraverseLeft(topLeft)) {
        updateConstraint(topLeft.movedLeft());
        return;
      }

      // Shrinking.
      if (anchorLocation == RelativeAnchorLocation.topLeft) {
        updateConstraint(bottomRight.movedLeft());
        return;
      }
      if (anchorLocation == RelativeAnchorLocation.bottomLeft) {
        updateConstraint(topRight.movedLeft());
        return;
      }
    }

    // Arrow Right
    if (key == LogicalKeyboardKey.arrowRight) {
      // Expansion
      if (anchorLocation == RelativeAnchorLocation.centered &&
          _canTraverseRight(anchor)) {
        updateConstraint(anchor.movedRight());
        return;
      }
      if (anchorLocation == RelativeAnchorLocation.topLeft &&
          _canTraverseRight(bottomRight)) {
        updateConstraint(bottomRight.movedRight());
        return;
      }
      if (anchorLocation == RelativeAnchorLocation.bottomLeft &&
          _canTraverseRight(topRight)) {
        updateConstraint(topRight.movedRight());
        return;
      }

      // Shrinking.
      if (anchorLocation == RelativeAnchorLocation.topRight) {
        updateConstraint(bottomLeft.movedRight());
        return;
      }

      if (anchorLocation == RelativeAnchorLocation.bottomRight) {
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
    if (_isControlDown == true && index != _selectionConstraint.anchor) {
      if (_selectionConstraint.satisfiesConstraints(index)) {
        // Selection was made inside existing constraints. Just Adjust contraints to Match clicked cell.
        setState(() {
          _selectionConstraint =
              _selectionConstraint.adjustWith(incoming: index);
        });
        return;
      } else {
        if (_selectionConstraint.foreignIndexes.contains(index)) {
          // Remove cell from foreignIndexes.
          setState(() {
            _selectionConstraint =
                _selectionConstraint.withRemovedForeignIndex(index);
          });
        } else {
          // Add cell to foreignIndexes.
          setState(() {
            _selectionConstraint =
                _selectionConstraint.withAddedForeignIndex(index);
          });
        }
      }

      return;
    }

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
      String newValue,
      CellIndex anchor,
      Set<CellIndex> selectedCellIndexes,
      CellSelectionDirectionality directionality) {
    if (widget.onCellValueChanged == null) {
      return;
    }

    final activeCellChange = CellChangeData(
      index: anchor,
      id: _lookupCellId(anchor),
    );

    final otherCells = selectedCellIndexes.toSet()..remove(anchor);
    final otherCellChangeData = otherCells
        .map((item) => CellChangeData(index: item, id: _lookupCellId(item)))
        .toList()
          ..sort();

    widget.onCellValueChanged(
        newValue, activeCellChange, otherCellChangeData, directionality);
  }

  CellId _lookupCellId(CellIndex index) {
    return widget.rows[index.rowIndex].children[index.columnIndex].id;
  }

  void _notifyCellSelections(Set<CellIndex> cellIndexes) {
    if (widget.onSelectionChanged != null) {
      widget.onSelectionChanged(
          cellIndexes.map((index) => _lookupCellId(index)).toSet());
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

  void _setControlState(RawKeyEvent rawKey) {
    // TODO: Quering for LogicalKeyboardKey.controlLeft or Right is almost certainly leaving out MacOSX users pressing the Apple Command key.
    if (rawKey is RawKeyDownEvent) {
      if (rawKey.logicalKey == LogicalKeyboardKey.controlLeft ||
          rawKey.logicalKey == LogicalKeyboardKey.controlRight) {
        if (_isControlDown == false) {
          setState(() {
            _isControlDown = true;
          });
          return;
        }
      }
    }

    if (rawKey is RawKeyUpEvent) {
      if (rawKey.logicalKey == LogicalKeyboardKey.controlLeft ||
          rawKey.logicalKey == LogicalKeyboardKey.controlRight) {
        if (_isControlDown == true) {
          setState(() {
            _isControlDown = false;
          });
          return;
        }
      }
    }
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
