import 'package:darkwrong/presentation/fast_table/FastTable.dart';
import 'package:flutter/material.dart';

typedef void CellClickedCallback(CellIndex index);
typedef void CellSelectionAdjustmentCallback(CellIndex index);
typedef void IsCellSelectedCallback(int xIndex, int yIndex);

class CellSelectionProvider extends InheritedWidget {
  final Widget child;
  final bool isActiveCellOpen;
  final String activeCellInitialCharacter;
  final dynamic onEditingComplete;
  final CellClickedCallback onCellClicked;
  final CellSelectionAdjustmentCallback onAdjustmentRequested;
  final CellSelectionConstraint selectionConstraint;

  CellSelectionProvider(
      {Key key,
      this.child,
      this.onEditingComplete,
      this.isActiveCellOpen,
      this.activeCellInitialCharacter,
      this.onCellClicked,
      this.onAdjustmentRequested,
      this.selectionConstraint})
      : super(key: key, child: child);

  static CellSelectionProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CellSelectionProvider>();
  }

  @override
  bool updateShouldNotify(CellSelectionProvider oldWidget) {
    return oldWidget.selectionConstraint != selectionConstraint ||
        oldWidget.isActiveCellOpen != isActiveCellOpen ||
        oldWidget.activeCellInitialCharacter != activeCellInitialCharacter ||
        oldWidget.onEditingComplete != onEditingComplete;
  }
}
