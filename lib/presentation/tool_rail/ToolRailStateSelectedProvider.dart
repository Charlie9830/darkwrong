import 'package:darkwrong/presentation/tool_rail/ToolRail.dart';
import 'package:flutter/material.dart';

class ToolRailStateSelectedProvider extends InheritedWidget {
  final Widget child;
  final String value;

  ToolRailStateSelectedProvider({Key key, this.child, this.value})
      : super(key: key, child: child);

  static ToolRailStateSelectedProvider of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ToolRailStateSelectedProvider>();
  }

  @override
  bool updateShouldNotify(ToolRailStateSelectedProvider oldWidget) {
    return oldWidget.value != value;
  }
}
