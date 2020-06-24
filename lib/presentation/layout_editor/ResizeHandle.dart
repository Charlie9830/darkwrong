import 'package:flutter/material.dart';

typedef void OnDragCallback(
    double deltaX, double deltaY, int pointerId);
typedef void OnDragDoneCallback(int pointerId);
typedef void OnDragStartCallback(int pointerId);

const double dragHandleWidth = 12.0;
const double dragHandleHeight = 12.0;

class ResizeHandle extends StatelessWidget {
  final bool selected;
  final OnDragStartCallback onDragStart;
  final OnDragCallback onDrag;
  final OnDragDoneCallback onDragDone;

  const ResizeHandle(
      {Key key,
      this.onDrag,
      this.onDragStart,
      this.selected = false,
      this.onDragDone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (pointerEvent) {
        if (pointerEvent.down) {
          onDrag?.call(
              pointerEvent.localDelta.dx,
              pointerEvent.localDelta.dy,
              pointerEvent.original.pointer);
        }
      },
      onPointerUp: (pointerEvent) {
        onDragDone?.call(pointerEvent.original.pointer);
      },
      onPointerDown: (pointerEvent) {
        onDragStart?.call(pointerEvent.original.pointer);
      },
      child: Container(
        width: dragHandleWidth,
        height: dragHandleHeight,
        decoration: selected
            ? BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Theme.of(context).accentColor, width: 2),
                color: Theme.of(context).colorScheme.onBackground,
              )
            : null,
      ),
    );
  }
}
