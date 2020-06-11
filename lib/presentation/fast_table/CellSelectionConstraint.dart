import 'package:darkwrong/enums.dart';
import 'package:darkwrong/presentation/fast_table/BorderState.dart';
import 'package:darkwrong/presentation/fast_table/CellIndex.dart';


class CellSelectionConstraint {
  final CellIndex topLeft;
  final CellIndex bottomRight;
  final CellIndex anchor;
  final Set<CellIndex> foreignIndexes;

  CellIndex get bottomLeft => CellIndex(
      columnIndex: topLeft.columnIndex, rowIndex: bottomRight.rowIndex);
  CellIndex get topRight => CellIndex(
      columnIndex: bottomRight.columnIndex, rowIndex: topLeft.rowIndex);

  CellSelectionConstraint({
    this.anchor,
    this.topLeft,
    this.bottomRight,
    this.foreignIndexes = const <CellIndex>{},
  });

  const CellSelectionConstraint.zero()
      : topLeft = const CellIndex.zero(),
        bottomRight = const CellIndex.zero(),
        anchor = const CellIndex.zero(),
        foreignIndexes = const <CellIndex>{};

  CellSelectionConstraint.singleExclusive(CellIndex cellIndex)
      : topLeft = cellIndex,
        bottomRight = cellIndex,
        anchor = cellIndex,
        foreignIndexes = const <CellIndex>{};

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

  CellSelectionConstraint withAddedForeignIndex(CellIndex foreignIndex) {
    return _copyWith(
      foreignIndexes: Set<CellIndex>.from(foreignIndexes)..add(foreignIndex),
    );
  }

  CellSelectionConstraint withRemovedForeignIndex(CellIndex foreignIndex) {
    return _copyWith(
      foreignIndexes: Set<CellIndex>.from(foreignIndexes)..remove(foreignIndex),
    );
  }

  CellSelectionConstraint _copyWith({
    CellIndex topLeft,
    CellIndex bottomRight,
    CellIndex anchor,
    Set<CellIndex> foreignIndexes,
  }) {
    return CellSelectionConstraint(
      topLeft: topLeft ?? this.topLeft,
      bottomRight: bottomRight ?? this.bottomRight,
      anchor: anchor ?? this.anchor,
      foreignIndexes: foreignIndexes ?? this.foreignIndexes,
    );
  }

  bool get isSingleExclusive =>
      topLeft == anchor && anchor == bottomRight && foreignIndexes.isEmpty;

  CellSelectionDirectionality getSelectionDirectionality() {
    if (isSingleExclusive) {
      return CellSelectionDirectionality.none;
    }

    if (foreignIndexes.isNotEmpty) {
      // Cell Selection direction is undefined with foreign indexes present.
      return CellSelectionDirectionality.none;
    }

    if (topLeft.rowIndex == bottomRight.rowIndex) {
      // Single row Selection.
      return anchor == topLeft
          ? CellSelectionDirectionality.leftToRight
          : CellSelectionDirectionality.rightToLeft;
    }

    if (topLeft.columnIndex == bottomRight.columnIndex) {
      // Single Column Selection.
      return anchor == topLeft
          ? CellSelectionDirectionality.topToBottom
          : CellSelectionDirectionality.bottomToTop;
    }

    return CellSelectionDirectionality.none;
  }

  bool isForeignSelection(CellIndex index) {
    return foreignIndexes.contains(index);
  }

  RelativeAnchorLocation getRelativeAnchorLocation() {
    if (topLeft == bottomRight && topLeft == anchor) {
      // Single Exclusive.
      return RelativeAnchorLocation.centered;
    }

    if (topLeft == anchor) {
      return RelativeAnchorLocation.topLeft;
    }

    if (bottomRight == anchor) {
      return RelativeAnchorLocation.bottomRight;
    }

    if (topRight == anchor) {
      return RelativeAnchorLocation.topRight;
    } else {
      return RelativeAnchorLocation.bottomLeft;
    }
  }

  BorderState getBorderState(CellIndex cellIndex) {
    if (isForeignSelection(cellIndex)) {
      return BorderState();
    }

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

    if (topLeft == bottomRight && foreignIndexes.isEmpty) {
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

    return returnSet..addAll(foreignIndexes);
  }

  List<int> _buildRange(int from, int to) {
    return List<int>.generate((to - from) + 1, (index) => from + index);
  }
}
