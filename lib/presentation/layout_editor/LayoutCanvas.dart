import 'dart:math';

import 'package:darkwrong/presentation/layout_editor/DragBoxLayer.dart';
import 'package:darkwrong/presentation/layout_editor/LayoutBlock.dart';
import 'package:darkwrong/presentation/layout_editor/LayoutElementModel.dart';
import 'package:darkwrong/presentation/layout_editor/DragHandles.dart';
import 'package:darkwrong/presentation/layout_editor/ResizeModifers.dart';
import 'package:darkwrong/presentation/layout_editor/RotateHandle.dart';
import 'package:darkwrong/presentation/layout_editor/consts.dart';
import 'package:flutter/material.dart';

class LayoutCanvas extends StatefulWidget {
  LayoutCanvas({Key key}) : super(key: key);

  @override
  _LayoutCanvasState createState() => _LayoutCanvasState();
}

class _LayoutCanvasState extends State<LayoutCanvas> {
  Map<String, LayoutElementModel> _layoutElements = {};
  Set<String> _selectedBlockIds = {};
  int _lastPointerId;
  ResizeHandleLocation _logicalResizeHandle;
  Point _pointerPosition;

  double _currentBlockWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (pointerEvent) {
        if (pointerEvent.pointer > _lastPointerId) {
          // Clear Selections.
          setState(() {
            _selectedBlockIds = <String>{};
          });
        }
      },
      child: Container(
        color: Colors
            .transparent, // If a color isn't set. Hit testing for the Parent Listener stops working.
        child: Stack(
          children: [
            DragBoxLayer(
              selectedBlockIds: _selectedBlockIds,
              blocks: _buildBlocks(),
              onPositionChange: (xPosDelta, yPosDelta, blockId) {
                _handlePositionChange(blockId, xPosDelta, yPosDelta);
              },
              onDragBoxClick: (blockId, pointerId) {
                setState(() {
                  _selectedBlockIds = <String>{blockId};
                  _lastPointerId = pointerId;
                });
              },
              onDragHandleDragged: _handleResizeHandleDragged,
              onResizeDone: _handleResizeDone,
              onResizeStart: _handleResizeStart,
              onRotateStart: _handleRotateStart,
              onRotate: _handleRotate,
              onRotateDone: _handleRotateDone,
            ),
            Positioned(
                left: _pointerPosition?.x ?? 0,
                top: _pointerPosition?.y ?? 0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purpleAccent,
                  ),
                  width: 8,
                  height: 8,
                )),
            Positioned(
              top: 20,
              left: 20,
              child: Column(
                children: [
                  Text(_logicalResizeHandle
                          .toString()
                          ?.replaceAll('DragHandlePosition.', '') ??
                      'Null'),
                  Text(_currentBlockWidth.round().toString() ?? ''),
                  Text(
                      'Pointer Pos: (${_pointerPosition?.x?.round() ?? null}, ${_pointerPosition?.y?.round() ?? null})')
                ],
              ),
            ),
            Positioned(
              top: 200,
              left: 600,
              child: Container(
                height: 700,
                width: 2,
                color: Colors.blueAccent,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                children: [
                  OutlineButton(
                    child: Text('Start'),
                    onPressed: () {
                      _handleRotateStart(1000, 'helloworld');
                    },
                  ),
                  OutlineButton(
                    child: Text('Bump'),
                    onPressed: () {
                      _handleRotate(15, 15, 'helloworld', 1000);
                    },
                  ),
                  OutlineButton(
                      child: Text('Reset'),
                      onPressed: () {
                        setState(() {
                          final uid = "helloworld";
                          _layoutElements = <String, LayoutElementModel>{}
                            ..addAll({
                              uid: LayoutElementModel(
                                uid: uid,
                                height: 100,
                                width: 100,
                                xPos: 500,
                                yPos: 200,
                                rotation: 0,
                              )
                            });
                          _selectedBlockIds = <String>{uid};
                          _logicalResizeHandle = null;
                        });
                      }),
                  RaisedButton(
                    child: Text('New'),
                    onPressed: () {
                      setState(() {});
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Map<String, LayoutBlock> _buildBlocks() {
    return Map<String, LayoutBlock>.fromEntries(
        _layoutElements.values.map((item) {
      return MapEntry(
          item.uid,
          LayoutBlock(
            id: item.uid,
            xPos: item.xPos,
            yPos: item.yPos,
            height: item.renderHeight,
            width: item.renderWidth,
            rotation: item.rotation,
            child: Transform(
              transform: Matrix4.rotationZ(item.rotation),
              alignment: Alignment.center,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: item.uid.hashCode.isEven
                          ? Colors.deepOrange
                          : Colors.deepPurple)),
            ),
          ));
    }));
  }

  void _handleResizeDone(int pointerId) {
    setState(() {
      _logicalResizeHandle = null;
    });
  }

  void _handleResizeStart(
      ResizeHandleLocation position, int pointerId, String blockId) {
    setState(() {
      _lastPointerId = pointerId;
    });
  }

  void _handleRotateStart(int pointerId, String blockId) {
    final existing = _layoutElements[blockId];

    final rectangle = existing.rectangle;
    final nakedPoint = Point(0, existing.height / 2 + rotateHandleTotalHeight);
    final rotatedPoint = _rotatePoint(nakedPoint, existing.rotation);
    final screenSpacePoint = Point(rotatedPoint.x + rectangle.center.dx,
        rotatedPoint.y + rectangle.center.dy);
        
    setState(() {
      _lastPointerId = pointerId;
      _pointerPosition = screenSpacePoint;
    });
  }

  void _handleRotateDone(String blockId, int pointerId) {
    setState(() {
      _pointerPosition = null;
    });
  }

  Point _rotatePoint(Point existing, double radians) {
    return Point((existing.x * cos(radians)) + (existing.y * sin(radians)),
        (existing.x * sin(radians)) + (existing.y * -1 * cos(radians)));
  }

  void _handleRotate(
      double deltaX, double deltaY, String blockId, int pointerId) {
    final existing = _layoutElements[blockId];
    final center = existing.rectangle.center;

    final pointerPos =
        Point(_pointerPosition.x + deltaX, _pointerPosition.y + deltaY);
    final rotation =
        atan2((pointerPos.y - center.dy), (pointerPos.x - center.dx)) +
            (pi / 2);

    final updatedElement = existing.copyWith(rotation: rotation);

    setState(() {
      _layoutElements = Map<String, LayoutElementModel>.from(_layoutElements)
        ..update(blockId, (_) => updatedElement);
      _lastPointerId = pointerId;
      _pointerPosition = pointerPos;
    });
  }

  ResizeHandleLocation _getOpposingResizeHandle(
    ResizeHandleLocation currentHandle,
    bool isXAxisFlipping,
    bool isYAxisFlipping,
  ) {
    if (!isXAxisFlipping && !isYAxisFlipping) {
      // No Flip
      return currentHandle;
    }

    if (isXAxisFlipping && !isYAxisFlipping) {
      // Horizontal Flip
      return horizontallyOpposingResizeHandles[currentHandle];
    }

    if (!isXAxisFlipping && isYAxisFlipping) {
      // Vertical Flip
      return verticallyOpposingResizeHandles[currentHandle];
    }

    if (isXAxisFlipping && isYAxisFlipping) {
      // Dual Axis Flip
      return opposingResizeHandles[currentHandle];
    }

    return currentHandle;
  }

  void _handleResizeHandleDragged(double deltaX, double deltaY,
      ResizeHandleLocation physicalHandle, int pointerId, String blockId) {
    final existing = _layoutElements[blockId];

    final isFlippingLeftToRight =
        existing.leftEdge + deltaX > existing.rightEdge;
    final isFlippingRightToLeft =
        existing.rightEdge + deltaX < existing.leftEdge;
    final isFlippingTopToBottom =
        existing.topEdge + deltaY > existing.bottomEdge;
    final isFlippingBottomToTop =
        existing.bottomEdge + deltaY < existing.topEdge;

    final currentLogicalHandle = _logicalResizeHandle ?? physicalHandle;

    switch (currentLogicalHandle) {
      // Top Left.
      case ResizeHandleLocation.topLeft:
        final updatedElement = existing.combinedWith(
            xComponent: isFlippingLeftToRight
                ? applyLeftCrossoverUpdate(existing, deltaX)
                : applyLeftNormalUpdate(existing, deltaX),
            yComponent: isFlippingTopToBottom
                ? applyTopCrossoverUpdate(existing, deltaY)
                : applyTopNormalUpdate(existing, deltaY));

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(blockId, (_) => updatedElement);
          _logicalResizeHandle = _getOpposingResizeHandle(currentLogicalHandle,
              isFlippingLeftToRight, isFlippingTopToBottom);
          _lastPointerId = pointerId;
        });
        break;

      // Top Center.
      case ResizeHandleLocation.topCenter:
        final updatedElement = existing.combinedWith(
            yComponent: isFlippingTopToBottom
                ? applyTopCrossoverUpdate(existing, deltaY)
                : applyTopNormalUpdate(existing, deltaY));

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(blockId, (_) => updatedElement);
          _logicalResizeHandle = isFlippingTopToBottom
              ? opposingResizeHandles[currentLogicalHandle]
              : currentLogicalHandle;
          _lastPointerId = pointerId;
        });
        break;

      // Top Right.
      case ResizeHandleLocation.topRight:
        final updatedElement = existing.combinedWith(
            xComponent: isFlippingRightToLeft
                ? applyRightCrossoverUpdate(existing, deltaX)
                : applyRightNormalUpdate(existing, deltaX),
            yComponent: isFlippingTopToBottom
                ? applyTopCrossoverUpdate(existing, deltaY)
                : applyTopNormalUpdate(existing, deltaY));

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(blockId, (_) => updatedElement);
          _logicalResizeHandle = _getOpposingResizeHandle(currentLogicalHandle,
              isFlippingRightToLeft, isFlippingTopToBottom);
          _lastPointerId = pointerId;
        });
        break;

      // Middle Right.
      case ResizeHandleLocation.middleRight:
        final updatedElement = existing.combinedWith(
          xComponent: isFlippingRightToLeft
              ? applyRightCrossoverUpdate(existing, deltaX)
              : applyRightNormalUpdate(existing, deltaX),
        );

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(blockId, (_) => updatedElement);
          _logicalResizeHandle = isFlippingRightToLeft
              ? opposingResizeHandles[currentLogicalHandle]
              : currentLogicalHandle;
          _lastPointerId = pointerId;
        });
        break;

      // Bottom Right.
      case ResizeHandleLocation.bottomRight:
        final updatedElement = existing.combinedWith(
            xComponent: isFlippingRightToLeft
                ? applyRightCrossoverUpdate(existing, deltaX)
                : applyRightNormalUpdate(existing, deltaX),
            yComponent: isFlippingBottomToTop
                ? applyBottomCrossoverUpdate(existing, deltaY)
                : applyBottomNormalUpdate(existing, deltaY));

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(blockId, (_) => updatedElement);
          _logicalResizeHandle = _getOpposingResizeHandle(currentLogicalHandle,
              isFlippingRightToLeft, isFlippingBottomToTop);
          _lastPointerId = pointerId;
        });
        break;

      // Bottom Center.
      case ResizeHandleLocation.bottomCenter:
        final updatedElement = existing.combinedWith(
          yComponent: isFlippingBottomToTop
              ? applyBottomCrossoverUpdate(existing, deltaY)
              : applyBottomNormalUpdate(existing, deltaY),
        );

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(blockId, (_) => updatedElement);
          _logicalResizeHandle = isFlippingBottomToTop
              ? opposingResizeHandles[currentLogicalHandle]
              : currentLogicalHandle;
          _lastPointerId = pointerId;
        });

        break;

      // Bottom Left.
      case ResizeHandleLocation.bottomLeft:
        final updatedElement = existing.combinedWith(
            xComponent: isFlippingLeftToRight
                ? applyLeftCrossoverUpdate(existing, deltaX)
                : applyLeftNormalUpdate(existing, deltaX),
            yComponent: isFlippingBottomToTop
                ? applyBottomCrossoverUpdate(existing, deltaY)
                : applyBottomNormalUpdate(existing, deltaY));

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(blockId, (_) => updatedElement);
          _logicalResizeHandle = _getOpposingResizeHandle(currentLogicalHandle,
              isFlippingLeftToRight, isFlippingBottomToTop);
          _lastPointerId = pointerId;
        });
        break;

      // Middle Left.
      case ResizeHandleLocation.middleLeft:
        final updatedElement = existing.combinedWith(
          xComponent: isFlippingLeftToRight
              ? applyLeftCrossoverUpdate(existing, deltaX)
              : applyLeftNormalUpdate(existing, deltaX),
        );

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(
                  blockId,
                  (_) => updatedElement,
                );
          _logicalResizeHandle = isFlippingLeftToRight
              ? opposingResizeHandles[currentLogicalHandle]
              : currentLogicalHandle;
          _lastPointerId = pointerId;
        });
        break;
    }
  }

  void _handlePositionChange(String uid, double xPosDelta, double yPosDelta) {
    final newMap = Map<String, LayoutElementModel>.from(_layoutElements);
    newMap[uid] = newMap[uid].copyWith(
      xPos: newMap[uid].xPos + xPosDelta,
      yPos: newMap[uid].yPos + yPosDelta,
    );

    setState(() {
      _layoutElements = newMap;
    });
  }
}
