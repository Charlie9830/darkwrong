import 'package:flutter/material.dart';

class CellIndexProvider extends InheritedWidget {
  final Widget child;
  final int index;

  CellIndexProvider({Key key, this.child, this.index }) : super(key: key, child: child);

  static CellIndexProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CellIndexProvider>();
  }

  @override
  bool updateShouldNotify( CellIndexProvider oldWidget) {
    return oldWidget.index != index;
  }
}