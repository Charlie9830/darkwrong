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
      width: width,
      duration: drawerMoveDuration,
      curve: Curves.easeInCubic,
      child: Material(
        color: Theme.of(context).colorScheme.background,
        elevation: 1,
        child: child,
      ),
    );
  }
}
