import 'package:darkwrong/presentation/tool_rail/ToolRail.dart';
import 'package:flutter/material.dart';

class ToolOptionPressedCallbackProvider extends InheritedWidget {
  final Widget child;
  final OnToolOptionPressedCallback callback;

  ToolOptionPressedCallbackProvider({Key key, this.child, this.callback }) : super(key: key, child: child);

  static ToolOptionPressedCallbackProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ToolOptionPressedCallbackProvider>();
  }

  @override
  bool updateShouldNotify( ToolOptionPressedCallbackProvider oldWidget) {
    return oldWidget.callback != callback;
  }
}