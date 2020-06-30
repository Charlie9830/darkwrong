import 'dart:math';
import 'package:vector_math/vector_math_64.dart' hide Colors;

import 'package:darkwrong/presentation/layout_editor/DragBoxLayer.dart';
import 'package:darkwrong/presentation/layout_editor/LayoutBlock.dart';
import 'package:darkwrong/presentation/layout_editor/LayoutElementModel.dart';
import 'package:darkwrong/presentation/layout_editor/DragHandles.dart';
import 'package:darkwrong/presentation/layout_editor/ResizeModifers.dart';
import 'package:darkwrong/presentation/layout_editor/RotateHandle.dart';
import 'package:darkwrong/presentation/layout_editor/consts.dart';
import 'package:darkwrong/presentation/layout_editor/rotatePoint.dart';
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
                    child: Text('Thinner'),
                    onPressed: () {
                      setState(() {
                        _layoutElements = Map<String, LayoutElementModel>.from(
                            _layoutElements
                              ..update(
                                  'helloworld',
                                  (existing) => existing.copyWith(
                                      width: existing.width - 100)));
                      });
                    },
                  ),
                  OutlineButton(
                    child: Text('Fatter'),
                    onPressed: () {
                      setState(() {
                        _layoutElements =
                            Map<String, LayoutElementModel>.from(_layoutElements
                              ..update(
                                'helloworld',
                                (existing) {
                                  return existing.copyWith(
                                    width: existing.width + 100,
                                    //xPos: existing.xPos - 50,
                                  );
                                },
                              ));
                      });
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
                                xPos: 600,
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
            debugRenderXPos: item.debugRenderXPos,
            debugRenderYPos: item.debugRenderYPos,
            height: item.renderHeight,
            width: item.renderWidth,
            rotation: item.rotation,
            child: Transform(
              transform: Matrix4.identity()
                ..translate(item.width / 2, item.height / 2)
                ..rotateZ(item.rotation)
                ..translate(item.width / 2 * -1, item.height / 2 * -1),
              origin: Offset(0, 0),
              child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: item.uid.hashCode.isEven
                          ? Colors.deepOrange
                          : Colors.deepPurple),
                  child: Text(
                    'Box',
                    textScaleFactor: 2.0,
                  )),
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
      _pointerPosition = Point(100.0, 100.0);
    });
  }

  void _handleRotateStart(int pointerId, String blockId) {
    final existing = _layoutElements[blockId];

    final rectangle = existing.rectangle;
    final nakedPoint = Point(0, existing.height / 2 + rotateHandleTotalHeight);
    final rotatedPoint = rotatePoint(nakedPoint, existing.rotation);
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
    // final rawDelta = Point(rawDeltaX, rawDeltaY);
    // final rotatedDelta = _rotatePoint(rawDelta, existing.rotation);
    // final deltaX = rotatedDelta.x;
    // final deltaY = rotatedDelta.y * -1;

    // print('Raw: (${rawDeltaX.round()}, ${rawDeltaY.round()})   Rotated: (${deltaX.round()}, ${deltaY.round()}) ');

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

          _pointerPosition = Point(existing.rectangle.topRight.dx + deltaX,
              existing.rectangle.topRight.dy + deltaY);
        });
        break;

      // Middle Right.
      case ResizeHandleLocation.middleRight:
        final updatedElement = existing.combinedWith(
          xComponent: isFlippingRightToLeft
              ? applyRightCrossoverUpdate(existing, deltaX)
              : applyRightNormalUpdate(existing, deltaX),
        );

        // final originalMatrix = Matrix4.identity()
        //   ..translate(existing.width / 2, existing.height / 2)
        //   ..rotateZ(existing.rotation)
        //   ..translate(existing.width / 2 * -1, existing.height / 2 * -1);
        final newMatrix = Matrix4.identity()
          ..translate(updatedElement.width / 2, updatedElement.height / 2)
          ..rotateZ(existing.rotation)
          ..translate(
              updatedElement.width / 2 * -1, updatedElement.height / 2 * -1);

        setState(() {
          _pointerPosition =
              Point(_pointerPosition.x + deltaX, _pointerPosition.y + deltaY);
        });

        final dimensionChangeVector = Vector3(
            updatedElement.width - existing.width,
            updatedElement.height - existing.height,
            0);

        // Represents the Transformation that would have been applied to the existing Shape.
        final Matrix4 existingElementMatrix = Matrix4.identity()
          ..translate(existing.width / 2, existing.height / 2)
          ..rotateZ(existing.rotation)
          ..translate(
              existing.width / 2 * -1, existing.height / 2 * -1);

        // Represents the Transformation that Will be applied to the updated Shape.
        final Matrix4 updatedElementMatrix = Matrix4.identity()
          ..translate(updatedElement.width / 2, updatedElement.height / 2)
          ..rotateZ(existing.rotation)
          ..translate(
              updatedElement.width / 2 * -1, updatedElement.height / 2 * -1);

        // Pass the DimensionChangeVector through both Matrices.
        final existingTransformedVector = existingElementMatrix.transformed3(dimensionChangeVector);
        final updatedTransformedVector = updatedElementMatrix.transformed3(dimensionChangeVector);

        // Find the X and Y Difference. Use these to offset the xPos and yPos of the shape ahead of the transformation.
        final xPosDelta = existingTransformedVector.x - updatedTransformedVector.x;
        final yPosDelta = existingTransformedVector.y - updatedTransformedVector.y;

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(
                    blockId,
                    (_) => updatedElement.copyWith(
                          xPos: updatedElement.xPos + xPosDelta,
                          yPos: updatedElement.yPos + yPosDelta,
                        ));
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
