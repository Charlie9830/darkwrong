import 'package:flutter/material.dart';

typedef void OnDragCallback(double deltaX, double deltaY, int pointerId);

const double dragHandleWidth = 12.0;
const double dragHandleHeight = 12.0;

class DragHandle extends StatelessWidget {
  final bool selected;
  final OnDragCallback onDrag;

  const DragHandle({Key key, this.onDrag, this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: (pointerEvent) {
        if (pointerEvent.down) {
          onDrag?.call(pointerEvent.localDelta.dx, pointerEvent.localDelta.dy,
              pointerEvent.original.pointer);
        }
      },
      onPointerDown: (pointerEvent) {
        // Dispatch a fake onDrag Call. This triggers an update to the _lastPointerId property opf the LayoutCanvas State whicb makes it possible to
        // infer the difference between a Canvas Click and an Layout Block Click.
        onDrag?.call(0, 0, pointerEvent.original.pointer);
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
