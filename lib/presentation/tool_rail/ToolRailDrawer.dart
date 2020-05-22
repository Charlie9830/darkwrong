import 'package:flutter/material.dart';

class ToolRailDrawer extends StatelessWidget {
  final Widget child;
  const ToolRailDrawer({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      child: child,
    );
  }
}
