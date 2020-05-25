import 'package:darkwrong/presentation/tool_rail/ToolRailDrawerScaffold.dart';
import 'package:flutter/material.dart';

class ToolRailController extends InheritedWidget {
  final Widget child;
  final bool persistent;
  final bool open;
  final double drawerClosedWidth;
  final double drawerOpenedWidth;
  final Duration drawerMoveDuration;
  final PersistButtonPressedCallback onPersistButtonPressed;

  ToolRailController({
    Key key,
    this.persistent,
    this.open,
    this.drawerClosedWidth,
    this.drawerOpenedWidth,
    this.drawerMoveDuration,
    this.onPersistButtonPressed,
    this.child,
  }) : super(key: key, child: child);

  static ToolRailController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ToolRailController>();
  }

  @override
  bool updateShouldNotify(ToolRailController oldWidget) {
    return oldWidget.persistent != persistent ||
        oldWidget.open != open ||
        oldWidget.drawerClosedWidth != drawerClosedWidth ||
        oldWidget.drawerOpenedWidth != drawerOpenedWidth ||
        oldWidget.drawerMoveDuration != drawerMoveDuration ||
        oldWidget.onPersistButtonPressed != onPersistButtonPressed;
  }
}
