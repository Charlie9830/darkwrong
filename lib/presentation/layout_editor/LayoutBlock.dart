import 'package:flutter/material.dart';

class LayoutBlock extends StatelessWidget {
  final String id;
  final Widget child;
  final double xPos;
  final double yPos;
  final double width;
  final double height;
  final double rotation;
  final double debugRenderXPos;
  final double debugRenderYPos;

  const LayoutBlock({
    Key key,
    @required this.id,
    this.xPos,
    this.yPos,
    this.width,
    this.height,
    this.child,
    this.rotation,
    this.debugRenderXPos,
    this.debugRenderYPos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
