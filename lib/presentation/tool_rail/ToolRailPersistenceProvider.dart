import 'package:darkwrong/presentation/tool_rail/ToolRail.dart';
import 'package:darkwrong/presentation/tool_rail/ToolRailDrawerScaffold.dart';
import 'package:flutter/material.dart';

class ToolRailPersistenceProvider extends InheritedWidget {
  final Widget child;
  final bool isPersistent;
  final OnPersistButtonPressedCallback onPersistButtonPresed;

  ToolRailPersistenceProvider({Key key, this.child, 
  @required this.isPersistent,
  @required this.onPersistButtonPresed }) : super(key: key, child: child);

  static ToolRailPersistenceProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ToolRailPersistenceProvider>();
  }

  @override
  bool updateShouldNotify( ToolRailPersistenceProvider oldWidget) {
    return oldWidget.onPersistButtonPresed != onPersistButtonPresed || oldWidget.isPersistent != isPersistent;
  }
}