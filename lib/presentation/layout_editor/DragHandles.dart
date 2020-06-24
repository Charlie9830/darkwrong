import 'package:darkwrong/presentation/layout_editor/ResizeHandle.dart';
import 'package:flutter/material.dart';

enum ResizeHandleLocation {
  topLeft,
  topCenter,
  topRight,
  middleRight,
  bottomRight,
  bottomCenter,
  bottomLeft,
  middleLeft,
}

typedef void OnHandleDragged(
    double deltaX, double deltaY, ResizeHandleLocation position, int pointerId);

typedef void OnDragHandlesDragStartCallback(
    ResizeHandleLocation handlePosition, int pointerId);

class DragHandles extends StatelessWidget {
  final bool selected;
  final double xPos;
  final double yPos;
  final double width;
  final double height;
  final OnDragHandlesDragStartCallback onDragStart;
  final OnDragDoneCallback onDragDone;
  final OnHandleDragged onDrag;

  const DragHandles({
    Key key,
    this.width,
    this.xPos,
    this.yPos,
    this.height,
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
      child: ResizeHandle(
        selected: selected,
        onDrag: _handleTopLeftDrag,
        onDragDone: _handleDragDone,
        onDragStart: (pointerId) =>
            _handleDragStart(ResizeHandleLocation.topLeft, pointerId),
      ),
    );

    final topCenter = Positioned(
        top: 0,
        left: width / 2 - dragHandleWidth / 2,
        child: ResizeHandle(
          selected: selected,
          onDrag: _handleTopCenterDrag,
          onDragDone: _handleDragDone,
          onDragStart: (pointerId) =>
              _handleDragStart(ResizeHandleLocation.topCenter, pointerId),
        ));

    final topRight = Positioned(
      top: 0,
      left: width - dragHandleWidth,
      child: ResizeHandle(
        selected: selected,
        onDrag: _handleTopRightDrag,
        onDragDone: _handleDragDone,
        onDragStart: (pointerId) =>
            _handleDragStart(ResizeHandleLocation.topRight, pointerId),
      ),
    );

    final middleRight = Positioned(
        top: height / 2 - dragHandleHeight / 2,
        left: width - dragHandleWidth,
        child: ResizeHandle(
          selected: selected,
          onDrag: _handleMiddleRightDrag,
          onDragDone: _handleDragDone,
          onDragStart: (pointerId) =>
              _handleDragStart(ResizeHandleLocation.middleRight, pointerId),
        ));

    final bottomRight = Positioned(
      top: height - dragHandleHeight,
      left: width - dragHandleWidth,
      child: ResizeHandle(
        selected: selected,
        onDrag: _handleBottomRightDrag,
        onDragDone: _handleDragDone,
        onDragStart: (pointerId) =>
            _handleDragStart(ResizeHandleLocation.bottomRight, pointerId),
      ),
    );

    final bottomCenter = Positioned(
      top: height - dragHandleHeight,
      left: width / 2 - dragHandleWidth / 2,
      child: ResizeHandle(
        selected: selected,
        onDrag: _handleBottomCenterDrag,
        onDragDone: _handleDragDone,
        onDragStart: (pointerId) =>
            _handleDragStart(ResizeHandleLocation.bottomCenter, pointerId),
      ),
    );

    final bottomLeft = Positioned(
      top: height - dragHandleHeight,
      left: 0,
      child: ResizeHandle(
        selected: selected,
        onDrag: _handleBottomLeftDrag,
        onDragDone: _handleDragDone,
        onDragStart: (pointerId) =>
            _handleDragStart(ResizeHandleLocation.bottomLeft, pointerId),
      ),
    );

    final middleLeft = Positioned(
      top: height / 2 - dragHandleHeight / 2,
      left: 0,
      child: ResizeHandle(
        selected: selected,
        onDrag: _handleMiddleLeftDrag,
        onDragDone: _handleDragDone,
        onDragStart: (pointerId) =>
            _handleDragStart(ResizeHandleLocation.middleLeft, pointerId),
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

  void _handleDragStart(ResizeHandleLocation position, int pointerId) {
    onDragStart?.call(position, pointerId);
  }

  void _handleDragDone(int pointerId) {
    onDragDone?.call(pointerId);
  }

  void _handleTopLeftDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, ResizeHandleLocation.topLeft, pointerId);
  }

  void _handleTopCenterDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, ResizeHandleLocation.topCenter, pointerId);
  }

  void _handleTopRightDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, ResizeHandleLocation.topRight, pointerId);
  }

  void _handleMiddleRightDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, ResizeHandleLocation.middleRight, pointerId);
  }

  void _handleBottomRightDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, ResizeHandleLocation.bottomRight, pointerId);
  }

  void _handleBottomCenterDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, ResizeHandleLocation.bottomCenter, pointerId);
  }

  void _handleBottomLeftDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, ResizeHandleLocation.bottomLeft, pointerId);
  }

  void _handleMiddleLeftDrag(double deltaX, double deltaY, double pointerXPos,
      double pointerYPos, int pointerId) {
    onDrag?.call(deltaX, deltaY, ResizeHandleLocation.middleLeft, pointerId);
  }
}
