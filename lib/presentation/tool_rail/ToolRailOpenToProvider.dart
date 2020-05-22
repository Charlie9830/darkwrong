import 'package:flutter/material.dart';

typedef void OpenToCallback(String value);

class ToolRailOpenToProvider extends InheritedWidget {
  final Widget child;
  final OpenToCallback openToCallback;

  ToolRailOpenToProvider({Key key, this.child, this.openToCallback})
      : super(key: key, child: child);

  static ToolRailOpenToProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ToolRailOpenToProvider>();
  }

  @override
  bool updateShouldNotify(ToolRailOpenToProvider oldWidget) {
    return oldWidget.openToCallback != openToCallback;
  }
}
