import 'package:darkwrong/presentation/layout_editor/DragHandle.dart';
import 'package:flutter/material.dart';

typedef void OnSizeChangeCallback(
    double widthDelta, double heightDelta, double xPosDelta, double yPosDelta, int pointerId);

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
  final OnSizeChangeCallback onSizeChange;
  final OnPositionChangeCallback onPositionChange;

  const DragBox({
    Key key,
    this.width,
    this.xPos,
    this.yPos,
    this.height,
    this.onSizeChange,
    this.onPositionChange,
    this.onClick,
    this.selected = false,
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

    final topCenter = Positioned(
        top: 0,
        left: width / 2 - dragHandleWidth / 2,
        child: DragHandle(selected: selected, onDrag: _handleTopCenterDrag));

    final topRight = Positioned(
      top: 0,
      left: width - dragHandleWidth,
      child: DragHandle(
        selected: selected,
        onDrag: _handleTopRightDrag,
      ),
    );

    final middleRight = Positioned(
        top: height / 2 - dragHandleHeight / 2,
        left: width - dragHandleWidth,
        child: DragHandle(
          selected: selected,
          onDrag: _handleMiddleRightDrag,
        ));

    final bottomRight = Positioned(
      top: height - dragHandleHeight,
      left: width - dragHandleWidth,
      child: DragHandle(
        selected: selected,
        onDrag: _handleBottomRightDrag,
      ),
    );

    final bottomCenter = Positioned(
      top: height - dragHandleHeight,
      left: width / 2 - dragHandleWidth / 2,
      child: DragHandle(
        selected: selected,
        onDrag: _handleBottomCenterDrag,
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

    final middleLeft = Positioned(
      top: height / 2 - dragHandleHeight / 2,
      left: 0,
      child: DragHandle(
        selected: selected,
        onDrag: _handleMiddleLeftDrag,
      ),
    );

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
          topLeft,
          topCenter,
          topRight,
          middleRight,
          bottomRight,
          bottomCenter,
          bottomLeft,
          middleLeft,
        ],
      ),
    );
  }

  void _handleTopLeftDrag(double deltaX, double deltaY, int pointerId) {
    final double widthDelta = _invertSign(deltaX);
    final double heightDelta = _invertSign(deltaY);
    final double xPosDelta = deltaX;
    final double yPosDelta = deltaY;

    onSizeChange(
      widthDelta,
      heightDelta,
      xPosDelta,
      yPosDelta,
      pointerId,
    );
  }

  void _handleTopCenterDrag(double deltaX, double deltaY, int pointerId) {
    final double widthDelta = 0;
    final double heightDelta = _invertSign(deltaY);
    final double xPosDelta = 0;
    final double yPosDelta = deltaY;

    onSizeChange(
      widthDelta,
      heightDelta,
      xPosDelta,
      yPosDelta,
      pointerId,
    );
  }

  void _handleTopRightDrag(double deltaX, double deltaY, int pointerId) {
    final double widthDelta = deltaX;
    final double heightDelta = _invertSign(deltaY);
    final double xPosDelta = 0;
    final double yPosDelta = deltaY;

    onSizeChange(
      widthDelta,
      heightDelta,
      xPosDelta,
      yPosDelta,
      pointerId,
    );
  }

  void _handleMiddleRightDrag(double deltaX, double deltaY, int pointerId) {
    final double widthDelta = deltaX;
    final double heightDelta = 0;
    final double xPosDelta = 0;
    final double yPosDelta = 0;

    onSizeChange(
      widthDelta,
      heightDelta,
      xPosDelta,
      yPosDelta,
      pointerId,
    );
  }

  void _handleBottomRightDrag(double deltaX, double deltaY, int pointerId) {
    final double widthDelta = deltaX;
    final double heightDelta = deltaY;
    final double xPosDelta = 0;
    final double yPosDelta = 0;

    onSizeChange(
      widthDelta,
      heightDelta,
      xPosDelta,
      yPosDelta,
      pointerId,
    );
  }

  void _handleBottomCenterDrag(double deltaX, double deltaY, int pointerId) {
    final double widthDelta = 0;
    final double heightDelta = deltaY;
    final double xPosDelta = 0;
    final double yPosDelta = 0;

    onSizeChange(
      widthDelta,
      heightDelta,
      xPosDelta,
      yPosDelta,
      pointerId,
    );
  }

  void _handleBottomLeftDrag(double deltaX, double deltaY, int pointerId) {
    final double widthDelta = _invertSign(deltaX);
    final double heightDelta = deltaY;
    final double xPosDelta = deltaX;
    final double yPosDelta = 0;

    onSizeChange(
      widthDelta,
      heightDelta,
      xPosDelta,
      yPosDelta,
      pointerId,
    );
  }

  void _handleMiddleLeftDrag(double deltaX, double deltaY, int pointerId) {
    final double widthDelta = _invertSign(deltaX);
    final double heightDelta = 0;
    final double xPosDelta = deltaX;
    final double yPosDelta = 0;

    onSizeChange(
      widthDelta,
      heightDelta,
      xPosDelta,
      yPosDelta,
      pointerId,
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
