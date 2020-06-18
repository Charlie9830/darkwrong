import 'package:darkwrong/presentation/layout_editor/DragHandle.dart';
import 'package:flutter/material.dart';

enum DragHandlePosition {
  topLeft,
  topCenter,
  topRight,
  middleRight,
  bottomRight,
  bottomCenter,
  bottomLeft,
  middleLeft,
}

typedef void OnSizeChangeCallback(double widthDelta, double heightDelta,
    double xPosDelta, double yPosDelta, int pointerId);

typedef void OnHandleDragged(double deltaX, double deltaY, double pointerXPos,
    double pointerYPos, DragHandlePosition position, int pointerId);

typedef void OnDragHandlesDragStartCallback(DragHandlePosition handlePosition, int pointerId);

class DragHandles extends StatelessWidget {
  final bool selected;
  final double xPos;
  final double yPos;
  final double width;
  final double height;
  final OnSizeChangeCallback onSizeChange;
  final OnDragHandlesDragStartCallback onDragStart;
  final OnDragDoneCallback onDragDone;
  final OnHandleDragged onDrag;

  const DragHandles({
    Key key,
    this.width,
    this.xPos,
    this.yPos,
    this.height,
    this.onSizeChange,
    this.onDrag,
    this.onDragDone,
    this.onDragStart,
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
        onDragDone: _handleDragDone,
        onDragStart: (pointerId) => _handleDragStart(DragHandlePosition.topLeft, pointerId),
      ),
    );

    final topCenter = Positioned(
        top: 0,
        left: width / 2 - dragHandleWidth / 2,
        child: DragHandle(
          selected: selected,
          onDrag: _handleTopCenterDrag,
          onDragDone: _handleDragDone,
          onDragStart: (pointerId) => _handleDragStart(DragHandlePosition.topCenter, pointerId),
        ));

    final topRight = Positioned(
      top: 0,
      left: width - dragHandleWidth,
      child: DragHandle(
        selected: selected,
        onDrag: _handleTopRightDrag,
        onDragDone: _handleDragDone,
        onDragStart: (pointerId) => _handleDragStart(DragHandlePosition.topRight, pointerId),
      ),
    );

    final middleRight = Positioned(
        top: height / 2 - dragHandleHeight / 2,
        left: width - dragHandleWidth,
        child: DragHandle(
          selected: selected,
          onDrag: _handleMiddleRightDrag,
          onDragDone: _handleDragDone,
          onDragStart: (pointerId) => _handleDragStart(DragHandlePosition.middleRight, pointerId),
        ));

    final bottomRight = Positioned(
      top: height - dragHandleHeight,
      left: width - dragHandleWidth,
      child: DragHandle(
        selected: selected,
        onDrag: _handleBottomRightDrag,
        onDragDone: _handleDragDone,
        onDragStart: (pointerId) => _handleDragStart(DragHandlePosition.bottomRight, pointerId),
      ),
    );

    final bottomCenter = Positioned(
      top: height - dragHandleHeight,
      left: width / 2 - dragHandleWidth / 2,
      child: DragHandle(
        selected: selected,
        onDrag: _handleBottomCenterDrag,
        onDragDone: _handleDragDone,
        onDragStart: (pointerId) => _handleDragStart(DragHandlePosition.bottomCenter, pointerId),
      ),
    );

    final bottomLeft = Positioned(
      top: height - dragHandleHeight,
      left: 0,
      child: DragHandle(
        selected: selected,
        onDrag: _handleBottomLeftDrag,
        onDragDone: _handleDragDone,
        onDragStart: (pointerId) => _handleDragStart(DragHandlePosition.bottomLeft, pointerId),
      ),
    );

    final middleLeft = Positioned(
      top: height / 2 - dragHandleHeight / 2,
      left: 0,
      child: DragHandle(
        selected: selected,
        onDrag: _handleMiddleLeftDrag,
        onDragDone: _handleDragDone,
        onDragStart: (pointerId) => _handleDragStart(DragHandlePosition.middleLeft, pointerId),
      ),
    );

    return Container(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
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

  void _handleDragStart(DragHandlePosition position, int pointerId) {
    onDragStart?.call(position, pointerId);
  }

  void _handleDragDone(int pointerId) {
    onDragDone?.call(pointerId);
  }

  void _handleTopLeftDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, pointerXPos, pointerYPos,
        DragHandlePosition.topLeft, pointerId);

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

  void _handleTopCenterDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, pointerXPos, pointerYPos,
        DragHandlePosition.topCenter, pointerId);

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

  void _handleTopRightDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, pointerXPos, pointerYPos,
        DragHandlePosition.topRight, pointerId);

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

  void _handleMiddleRightDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, pointerXPos, pointerYPos,
        DragHandlePosition.middleRight, pointerId);

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

  void _handleBottomRightDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, pointerXPos, pointerYPos,
        DragHandlePosition.bottomRight, pointerId);

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

  void _handleBottomCenterDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, pointerXPos, pointerYPos,
        DragHandlePosition.bottomCenter, pointerId);

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

  void _handleBottomLeftDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, pointerXPos, pointerYPos,
        DragHandlePosition.bottomLeft, pointerId);

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

  void _handleMiddleLeftDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, pointerXPos, pointerYPos,
        DragHandlePosition.middleLeft, pointerId);

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
