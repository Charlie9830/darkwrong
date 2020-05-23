import 'package:flutter/material.dart';

class ToolRailBase extends StatelessWidget {
  final Widget child;
  final double width;
  final Duration drawerMoveDuration;
  const ToolRailBase(
      {Key key,
      @required this.child,
      @required this.width,
      @required this.drawerMoveDuration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: Alignment.topCenter,
      width: width,
      duration: drawerMoveDuration,
      child: Material(
        elevation: 1,
        child: child,
      ),
    );
  }
}
