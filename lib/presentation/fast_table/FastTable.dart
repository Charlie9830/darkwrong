import 'package:darkwrong/presentation/fast_table/CellSelectionProvider.dart';
import 'package:darkwrong/presentation/fast_table/ColumnWidthsProvider.dart';
import 'package:darkwrong/presentation/fast_table/FastRow.dart';
import 'package:darkwrong/presentation/fast_table/TableHeader.dart';
import 'package:flutter/material.dart';

class FastTable extends StatefulWidget {
  final List<FastRow> rows;
  final List<TableHeader> headers;
  FastTable({Key key, this.rows, this.headers}) : super(key: key);

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

  void _handleCellClicked(int xIndex, int yIndex) {
    if (_isShiftKeyDown == false) {
      // Exclusive Selection.
      setState(() {
        _selectionConstraint =
            CellSelectionConstraint.singleExclusive(CellIndex(xIndex, yIndex));
      });

      return;
    }

    if (xIndex == _selectionConstraint.upperLeft.x &&
        yIndex == _selectionConstraint.upperLeft.y) {
      // Do nothing.
      return;
    }

    setState(() {
      _selectionConstraint =
          _selectionConstraint.copyWith(b: CellIndex(xIndex, yIndex));
    });
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
  final int x;
  final int y;

  const CellIndex(this.x, this.y);
  const CellIndex.zero()
      : x = 0,
        y = 0;
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
    if (cellIndex.y == upperLeft.y) {
      top = true;
    }

    // Right
    if (cellIndex.x == lowerRight.x) {
      right = true;
    }

    // Bottom
    if (cellIndex.y == lowerRight.y) {
      bottom = true;
    }

    // Left
    if (cellIndex.x == upperLeft.x) {
      left = true;
    }

    return BorderState(
      top: top,
      right: right,
      bottom: bottom,
      left: left
    );
  }

  bool satisfiesConstraints(CellIndex cellIndex) {
    return _withinBounds(
            upperLeft.x, lowerRight.x, cellIndex.x) && // Hit test X Axis.
        _withinBounds(
            upperLeft.y, lowerRight.y, cellIndex.y); // Hit test Y Axis
  }

  bool _withinBounds(int lower, int upper, int point) {
    return point >= lower && point <= upper;
  }

  static CellIndex _getUpperLeft(CellIndex a, CellIndex b) {
    if (a.x <= b.x && a.y <= b.y) {
      return a;
    } else {
      return b;
    }
  }

  static CellIndex _getLowerRight(CellIndex a, CellIndex b) {
    if (a.x >= b.x && a.y >= b.y) {
      return a;
    } else {
      return b;
    }
  }
}
