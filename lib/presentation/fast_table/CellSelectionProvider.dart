import 'package:darkwrong/presentation/fast_table/FastTable.dart';
import 'package:flutter/material.dart';

typedef void CellClickedCallback(int xIndex, int yIndex);
typedef void IsCellSelectedCallback(int xIndex, int yIndex);

class CellSelectionProvider extends InheritedWidget {
  final Widget child;
  final CellClickedCallback onCellClicked;
  final CellSelectionConstraint selectionConstraint;

  CellSelectionProvider(
      {Key key, this.child, this.onCellClicked, this.selectionConstraint})
      : super(key: key, child: child);

  static CellSelectionProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CellSelectionProvider>();
  }

  @override
  bool updateShouldNotify(CellSelectionProvider oldWidget) {
    return oldWidget.onCellClicked != onCellClicked ||
        oldWidget.selectionConstraint != selectionConstraint;
  }
}
