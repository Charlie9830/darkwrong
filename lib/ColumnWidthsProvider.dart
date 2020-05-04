import 'package:flutter/material.dart';

class ColumnWidthsProvider extends InheritedWidget {
  final Widget child;
  final List<double> widths;

  ColumnWidthsProvider({Key key, this.child, this.widths }) : super(key: key, child: child);

  static ColumnWidthsProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ColumnWidthsProvider>();
  }

  @override
  bool updateShouldNotify( ColumnWidthsProvider oldWidget) {
    return oldWidget.widths != widths;
  }
}