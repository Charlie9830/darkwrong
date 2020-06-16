import 'package:darkwrong/presentation/layout_editor/DragHandle.dart';
import 'package:flutter/material.dart';

typedef void OnClickCallback(int pointerId);

typedef void OnPositionChangeCallback(
  double xDelta,
  double yDelta,
);

class DragBox extends StatelessWidget {
  final bool selected;
  final double xPos;
  final double yPos;
  final double width;
  final double height;
  final OnClickCallback onClick;
  final OnPositionChangeCallback onPositionChange;

  const DragBox({
    Key key,
    this.width,
    this.xPos,
    this.yPos,
    this.height,
    this.onPositionChange,
    this.onClick,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              width: width - dragHandleWidth,
              height: height - dragHandleHeight,
              child: Listener(
                onPointerDown: (pointerEvent) {
                  onClick?.call(pointerEvent.original.pointer);
                },
                onPointerMove: (pointerEvent) {
                  if (pointerEvent.down) {
                    onPositionChange?.call(
                        pointerEvent.localDelta.dx, pointerEvent.localDelta.dy);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).accentColor,
                          width: 2.0,
                          style:
                              selected ? BorderStyle.solid : BorderStyle.none)),
                ),
              )),
        ],
      ),
    );
  }
}
