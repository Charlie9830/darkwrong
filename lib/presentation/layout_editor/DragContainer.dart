import 'package:darkwrong/presentation/layout_editor/DragHandle.dart';
import 'package:flutter/material.dart';

typedef void OnSizeChangeCallback(
    double widthDelta, double heightDelta, double xPosDelta, double yPosDelta);

typedef void OnSelectedCallback();

typedef void OnPositionChangeCallback(
  double xDelta,
  double yDelta,
);

class DragContainer extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final bool selected;
  final OnSelectedCallback onSelected;
  final OnSizeChangeCallback onSizeChange;
  final OnPositionChangeCallback onPositionChange;
  const DragContainer({
    Key key,
    this.child,
    this.width,
    this.height,
    this.onSizeChange,
    this.onPositionChange,
    this.selected = false,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topLeft = Positioned(
      top: 0,
      left: 0,
      child: DragHandle(
        selected: selected,
        onDrag: _handleTopLeftDrag,
      ),
    );

    final topRight = Positioned(
      top: 0,
      left: width - dragHandleWidth,
      child: DragHandle(
        selected: selected,
        onDrag: _handleTopRightDrag,
      ),
    );

    final bottomRight = Positioned(
      top: height - dragHandleHeight,
      left: width - dragHandleWidth,
      child: DragHandle(
        selected: selected,
        onDrag: _handleBottomRightDrag,
      ),
    );

    final bottomLeft = Positioned(
      top: height - dragHandleHeight,
      left: 0,
      child: DragHandle(
        selected: selected,
        onDrag: _handleBottomLeftDrag,
      ),
    );

    return Container(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned(
            top: dragHandleHeight / 2,
            bottom: dragHandleHeight / 2,
            left: dragHandleWidth / 2,
            right: dragHandleWidth / 2,
            child: Listener(
              onPointerDown: (pointerEvent) {
                if (selected == false) {
                  onSelected?.call();
                }
              },
              onPointerMove: (pointerEvent) {
                if (pointerEvent.down) {
                  onPositionChange?.call(
                      pointerEvent.delta.dx, pointerEvent.delta.dy);
                }
              },
              child: Container(
                padding: selected ? EdgeInsets.all(8) : EdgeInsets.zero,
                decoration: selected
                    ? BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).accentColor))
                    : null,
                child: child,
              ),
            ),
          ),
          topLeft,
          topRight,
          bottomRight,
          bottomLeft,
        ],
      ),
    );
  }

  void _handleTopLeftDrag(double deltaX, double deltaY) {
    final double widthDelta = _invertSign(deltaX);
    final double heightDelta = _invertSign(deltaY);
    final double xPosDelta = deltaX;
    final double yPosDelta = deltaY;

    onSizeChange(
      widthDelta,
      heightDelta,
      xPosDelta,
      yPosDelta,
    );
  }

  void _handleTopRightDrag(double deltaX, double deltaY) {
    final double widthDelta = deltaX;
    final double heightDelta = _invertSign(deltaY);
    final double xPosDelta = 0;
    final double yPosDelta = deltaY;

    onSizeChange(
      widthDelta,
      heightDelta,
      xPosDelta,
      yPosDelta,
    );
  }

  void _handleBottomRightDrag(double deltaX, double deltaY) {
    final double widthDelta = deltaX;
    final double heightDelta = deltaY;
    final double xPosDelta = 0;
    final double yPosDelta = 0;

    onSizeChange(
      widthDelta,
      heightDelta,
      xPosDelta,
      yPosDelta,
    );
  }

  void _handleBottomLeftDrag(double deltaX, double deltaY) {
    final double widthDelta = _invertSign(deltaX);
    final double heightDelta = deltaY;
    final double xPosDelta = deltaX;
    final double yPosDelta = 0;

    onSizeChange(
      widthDelta,
      heightDelta,
      xPosDelta,
      yPosDelta,
    );
  }

  double _invertSign(double value) {
    if (value == value.sign) {
      return value;
    }

    if (value.sign == -1.0) {
      return value.abs();
    } else {
      return 0 - value.abs();
    }
  }
}
