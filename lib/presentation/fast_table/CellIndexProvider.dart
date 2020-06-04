import 'package:flutter/material.dart';

class CellIndexProvider extends InheritedWidget {
  final Widget child;
  final int xIndex;
  final int yIndex;

  CellIndexProvider({Key key, this.child, this.xIndex, this.yIndex})
      : super(key: key, child: child);

  static CellIndexProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CellIndexProvider>();
  }

  @override
  bool updateShouldNotify(CellIndexProvider oldWidget) {
    return oldWidget.xIndex != xIndex || oldWidget.yIndex != yIndex;
  }
}
