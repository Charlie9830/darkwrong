import 'package:darkwrong/presentation/layout_editor/DragBoxLayer.dart';
import 'package:darkwrong/presentation/layout_editor/DragHandle.dart';
import 'package:darkwrong/presentation/layout_editor/DragHandles.dart';
import 'package:darkwrong/util/getUid.dart';
import 'package:flutter/material.dart';

const Map<DragHandlePosition, DragHandlePosition> _opposingDragHandles = {
  DragHandlePosition.topLeft: DragHandlePosition.bottomRight,
  DragHandlePosition.topCenter: DragHandlePosition.bottomCenter,
  DragHandlePosition.topRight: DragHandlePosition.bottomLeft,
  DragHandlePosition.middleRight: DragHandlePosition.middleLeft,
  DragHandlePosition.bottomRight: DragHandlePosition.topLeft,
  DragHandlePosition.bottomCenter: DragHandlePosition.topCenter,
  DragHandlePosition.bottomLeft: DragHandlePosition.topRight,
  DragHandlePosition.middleLeft: DragHandlePosition.middleRight,
};

const Map<DragHandlePosition, DragHandlePosition>
    _verticallyOpposingDragHandles = {
  DragHandlePosition.topLeft: DragHandlePosition.bottomLeft,
  DragHandlePosition.topCenter: DragHandlePosition.bottomCenter,
  DragHandlePosition.topRight: DragHandlePosition.bottomRight,
  DragHandlePosition.middleRight: DragHandlePosition.middleRight,
  DragHandlePosition.bottomRight: DragHandlePosition.topRight,
  DragHandlePosition.bottomCenter: DragHandlePosition.topCenter,
  DragHandlePosition.bottomLeft: DragHandlePosition.topLeft,
  DragHandlePosition.middleLeft: DragHandlePosition.middleLeft,
};

const Map<DragHandlePosition, DragHandlePosition>
    _horizontallyOpposingDragHandles = {
  DragHandlePosition.topLeft: DragHandlePosition.topRight,
  DragHandlePosition.topCenter: DragHandlePosition.topCenter,
  DragHandlePosition.topRight: DragHandlePosition.topLeft,
  DragHandlePosition.middleRight: DragHandlePosition.middleLeft,
  DragHandlePosition.bottomRight: DragHandlePosition.bottomLeft,
  DragHandlePosition.bottomCenter: DragHandlePosition.bottomCenter,
  DragHandlePosition.bottomLeft: DragHandlePosition.bottomRight,
  DragHandlePosition.middleLeft: DragHandlePosition.middleRight,
};

class LayoutCanvas extends StatefulWidget {
  LayoutCanvas({Key key}) : super(key: key);

  @override
  _LayoutCanvasState createState() => _LayoutCanvasState();
}

const double _minWidth = 20.0;
const double _minHeight = 20.0;

class _LayoutCanvasState extends State<LayoutCanvas> {
  Map<String, LayoutElementModel> _layoutElements = {};
  Set<String> _selectedBlockIds = {};
  int _lastPointerId;
  DragHandlePosition _logicalDragHandle;

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
              onSizeChange: (widthDelta, heightDelta, xPosDelta, yPosDelta,
                  blockId, pointerId) {
                _handleSizeChange(blockId, widthDelta, heightDelta, xPosDelta,
                    yPosDelta, pointerId);
              },
              onDragBoxClick: (blockId, pointerId) {
                setState(() {
                  _selectedBlockIds = <String>{blockId};
                  _lastPointerId = pointerId;
                });
              },
              onDragHandleDragged: _handleDragHandleDragged,
              onResizeDone: _handleResizeDone,
              onResizeStart: _handleResizeStart,
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Column(
                children: [
                  Text(_logicalDragHandle
                          .toString()
                          ?.replaceAll('DragHandlePosition.', '') ??
                      'Null'),
                  Text(_currentBlockWidth.round().toString() ?? ''),
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
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () {
                      _handleDragHandleDragged(-50, 0, 0, 0,
                          DragHandlePosition.middleLeft, 1, 'helloworld');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () {
                      _handleDragHandleDragged(50, 0, 0, 0,
                          DragHandlePosition.middleLeft, 1, 'helloworld');
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
                              )
                            });
                          _selectedBlockIds = <String>{uid};
                          _logicalDragHandle = null;
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
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    color: item.uid.hashCode.isEven
                        ? Colors.deepOrange
                        : Colors.deepPurple)),
          ));
    }));
  }

  void _handleResizeDone(int pointerId) {
    setState(() {
      _logicalDragHandle = null;
    });
  }

  void _handleResizeStart(
      DragHandlePosition position, int pointerId, String blockId) {
    final object = _layoutElements[blockId];

    setState(() {
      _lastPointerId = pointerId;
    });
  }

  double _getOpposingSideXPos(
      LayoutElementModel object, DragHandlePosition handlePosition) {
    if (handlePosition == DragHandlePosition.topLeft ||
        handlePosition == DragHandlePosition.middleLeft ||
        handlePosition == DragHandlePosition.bottomLeft) {
      return object.xPos + object.width;
    }

    if (handlePosition == DragHandlePosition.topRight ||
        handlePosition == DragHandlePosition.middleRight ||
        handlePosition == DragHandlePosition.bottomRight) {
      return object.xPos;
    }

    return null;
  }

  double _getManipulatingSideXPos(LayoutElementModel object, double deltaX,
      DragHandlePosition manipulatingHandle) {
    if (manipulatingHandle == DragHandlePosition.topLeft ||
        manipulatingHandle == DragHandlePosition.middleLeft ||
        manipulatingHandle == DragHandlePosition.bottomLeft) {
      return object.xPos + deltaX;
    }

    if (manipulatingHandle == DragHandlePosition.topRight ||
        manipulatingHandle == DragHandlePosition.middleRight ||
        manipulatingHandle == DragHandlePosition.bottomRight) {
      return object.xPos + deltaX + object.width;
    }

    return null;
  }

  bool _getDidFlipOverX(LayoutElementModel object, double deltaX,
      DragHandlePosition manipulatingHandle) {
    final double opposingXPos =
        _getOpposingSideXPos(object, manipulatingHandle);
    final double manipulatingSideXPos =
        _getManipulatingSideXPos(object, deltaX, manipulatingHandle);

    if (manipulatingHandle == DragHandlePosition.topLeft ||
        manipulatingHandle == DragHandlePosition.middleLeft ||
        manipulatingHandle == DragHandlePosition.bottomLeft) {
      return manipulatingSideXPos > opposingXPos;
    }

    if (manipulatingHandle == DragHandlePosition.topRight ||
        manipulatingHandle == DragHandlePosition.middleRight ||
        manipulatingHandle == DragHandlePosition.bottomRight) {
      return manipulatingSideXPos < opposingXPos;
    }

    return false;
  }

  DragHandlePosition _getNextDragHandle(
    DragHandlePosition currentHandle,
    bool isXAxisFlipping,
    bool isYAxisFlipping,
  ) {
    if (!isXAxisFlipping && !isYAxisFlipping) {
      // No Flip
      return currentHandle;
    }

    if (isXAxisFlipping && !isYAxisFlipping) {
      // Horizontal Flip
      return _horizontallyOpposingDragHandles[currentHandle];
    }

    if (!isXAxisFlipping && isYAxisFlipping) {
      // Vertical Flip
      return _verticallyOpposingDragHandles[currentHandle];
    }

    if (isXAxisFlipping && isYAxisFlipping) {
      // Dual Axis Flip
      return _opposingDragHandles[currentHandle];
    }

    return currentHandle;
  }

  void _handleDragHandleDragged(
      double deltaX,
      double deltaY,
      double pointerXPos,
      double pointerYPos,
      DragHandlePosition physicalHandle,
      int pointerId,
      String blockId) {
    final existing = _layoutElements[blockId];
    final isFlippingLeftToRight =
        existing.leftEdge + deltaX > existing.rightEdge;
    final isFlippingRightToLeft =
        existing.rightEdge + deltaX < existing.leftEdge;
    final isFlippingTopToBottom =
        existing.topEdge + deltaY > existing.bottomEdge;
    final isFlippingBottomToTop =
        existing.bottomEdge + deltaY < existing.topEdge;

    final currentLogicalHandle = _logicalDragHandle ?? physicalHandle;

    switch (currentLogicalHandle) {
      // Top Left.
      case DragHandlePosition.topLeft:
        final updatedElement = existing.combinedWith(
            xComponent: isFlippingLeftToRight
                ? _applyLeftCrossoverUpdate(existing, deltaX)
                : _applyLeftNormalUpdate(existing, deltaX),
            yComponent: isFlippingTopToBottom
                ? _applyTopCrossoverUpdate(existing, deltaY)
                : _applyTopNormalUpdate(existing, deltaY));

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(blockId, (_) => updatedElement);
          _logicalDragHandle = _getNextDragHandle(currentLogicalHandle,
              isFlippingLeftToRight, isFlippingTopToBottom);
          _lastPointerId = pointerId;
        });
        break;

      // Top Center.
      case DragHandlePosition.topCenter:
        final updatedElement = existing.combinedWith(
            yComponent: isFlippingTopToBottom
                ? _applyTopCrossoverUpdate(existing, deltaY)
                : _applyTopNormalUpdate(existing, deltaY));

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(blockId, (_) => updatedElement);
          _logicalDragHandle = isFlippingTopToBottom
              ? _opposingDragHandles[currentLogicalHandle]
              : currentLogicalHandle;
          _lastPointerId = pointerId;
        });
        break;

      // Top Right.
      case DragHandlePosition.topRight:
        final updatedElement = existing.combinedWith(
            xComponent: isFlippingRightToLeft
                ? _applyRightCrossoverUpdate(existing, deltaX)
                : _applyRightNormalUpdate(existing, deltaX),
            yComponent: isFlippingTopToBottom
                ? _applyTopCrossoverUpdate(existing, deltaY)
                : _applyTopNormalUpdate(existing, deltaY));
                
        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(blockId, (_) => updatedElement);
          _logicalDragHandle = _getNextDragHandle(currentLogicalHandle,
              isFlippingRightToLeft, isFlippingTopToBottom);
          _lastPointerId = pointerId;
        });
        break;

      // Middle Right.
      case DragHandlePosition.middleRight:
        final updatedElement = existing.combinedWith(
          xComponent: isFlippingRightToLeft
              ? _applyRightCrossoverUpdate(existing, deltaX)
              : _applyRightNormalUpdate(existing, deltaX),
        );

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(blockId, (_) => updatedElement);
          _logicalDragHandle = isFlippingRightToLeft
              ? _opposingDragHandles[currentLogicalHandle]
              : currentLogicalHandle;
          _lastPointerId = pointerId;
        });
        break;

      // Bottom Right.
      case DragHandlePosition.bottomRight:
        final updatedElement = existing.combinedWith(
            xComponent: isFlippingRightToLeft
                ? _applyRightCrossoverUpdate(existing, deltaX)
                : _applyRightNormalUpdate(existing, deltaX),
            yComponent: isFlippingBottomToTop
                ? _applyBottomCrossoverUpdate(existing, deltaY)
                : _applyBottomNormalUpdate(existing, deltaY));

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(blockId, (_) => updatedElement);
          _logicalDragHandle = _getNextDragHandle(currentLogicalHandle,
              isFlippingRightToLeft, isFlippingBottomToTop);
          _lastPointerId = pointerId;
        });
        break;

      // Bottom Center.
      case DragHandlePosition.bottomCenter:
        final updatedElement = existing.combinedWith(
          yComponent: isFlippingBottomToTop
              ? _applyBottomCrossoverUpdate(existing, deltaY)
              : _applyBottomNormalUpdate(existing, deltaY),
        );

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(blockId, (_) => updatedElement);
          _logicalDragHandle = isFlippingBottomToTop
              ? _opposingDragHandles[currentLogicalHandle]
              : currentLogicalHandle;
          _lastPointerId = pointerId;
        });

        break;

      // Bottom Left.
      case DragHandlePosition.bottomLeft:
        final updatedElement = existing.combinedWith(
            xComponent: isFlippingLeftToRight
                ? _applyLeftCrossoverUpdate(existing, deltaX)
                : _applyLeftNormalUpdate(existing, deltaX),
            yComponent: isFlippingBottomToTop
                ? _applyBottomCrossoverUpdate(existing, deltaY)
                : _applyBottomNormalUpdate(existing, deltaY));

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(blockId, (_) => updatedElement);
          _logicalDragHandle = _getNextDragHandle(currentLogicalHandle,
              isFlippingLeftToRight, isFlippingBottomToTop);
          _lastPointerId = pointerId;
        });
        break;

      // Middle Left.
      case DragHandlePosition.middleLeft:
        final updatedElement = existing.combinedWith(
          xComponent: isFlippingLeftToRight
              ? _applyLeftCrossoverUpdate(existing, deltaX)
              : _applyLeftNormalUpdate(existing, deltaX),
        );

        setState(() {
          _layoutElements =
              Map<String, LayoutElementModel>.from(_layoutElements)
                ..update(
                  blockId,
                  (_) => updatedElement,
                );
          _logicalDragHandle = isFlippingLeftToRight
              ? _opposingDragHandles[currentLogicalHandle]
              : currentLogicalHandle;
          _lastPointerId = pointerId;
        });
        break;
    }
  }

  LayoutElementModel _applyTopNormalUpdate(
      LayoutElementModel existing, double deltaY) {
    final updatedElement = existing.copyWith(
      height: existing.height + _invertSign(deltaY),
      yPos: existing.yPos + deltaY,
    );
    return updatedElement;
  }

  LayoutElementModel _applyTopCrossoverUpdate(
      LayoutElementModel existing, double deltaY) {
    final pointerPos = existing.topEdge + deltaY;
    final difference = pointerPos - existing.bottomEdge;
    final updatedElement = existing.copyWith(
      height: difference,
      yPos: existing.bottomEdge,
    );
    return updatedElement;
  }

  LayoutElementModel _applyLeftNormalUpdate(
      LayoutElementModel existing, double deltaX) {
    final updatedElement = existing.copyWith(
      width: existing.width + _invertSign(deltaX),
      xPos: existing.xPos + deltaX,
    );
    return updatedElement;
  }

  LayoutElementModel _applyLeftCrossoverUpdate(
      LayoutElementModel existing, double deltaX) {
    final pointerPos = existing.leftEdge + deltaX;
    final difference = pointerPos - existing.rightEdge;
    final updatedElement = existing.copyWith(
      width: difference,
      xPos: existing.rightEdge,
    );
    return updatedElement;
  }

  LayoutElementModel _applyBottomNormalUpdate(
      LayoutElementModel existing, double deltaY) {
    final updatedElement = existing.copyWith(
      height: existing.height + deltaY,
      yPos: existing.yPos,
    );
    return updatedElement;
  }

  LayoutElementModel _applyRightNormalUpdate(
      LayoutElementModel existing, double deltaX) {
    final updatedElement = existing.copyWith(
      width: existing.width + deltaX,
      xPos: existing.xPos,
    );
    return updatedElement;
  }

  LayoutElementModel _applyBottomCrossoverUpdate(
      LayoutElementModel existing, double deltaY) {
    final updatedElement = existing.copyWith(
      height: existing.topEdge - existing.yPos + _invertSign(deltaY),
      yPos: existing.yPos + deltaY,
    );
    return updatedElement;
  }

  LayoutElementModel _applyRightCrossoverUpdate(
      LayoutElementModel existing, double deltaX) {
    final updatedElement = existing.copyWith(
      width: existing.leftEdge - existing.xPos + _invertSign(deltaX),
      xPos: existing.xPos + deltaX,
    );
    return updatedElement;
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

  void _handleSizeChange(
    String uid,
    double widthDelta,
    double heightDelta,
    double xPosDelta,
    double yPosDelta,
    int pointerId,
  ) {
    // final newMap = Map<String, LayoutObject>.from(_layoutObjects);
    // final item = newMap[uid];
    // final xPos = item.xPos + xPosDelta;
    // final yPos = item.yPos + yPosDelta;
    // final width = item.width + widthDelta;
    // final height = item.height + heightDelta;

    // newMap[uid] = item.copyWith(
    //   width: width.abs(),
    //   height: height.abs(),
    //   xPos: xPos,
    //   yPos: yPos,
    // );

    // setState(() {
    //   _layoutObjects = newMap;
    //   _lastPointerId = pointerId;
    // });
  }
}

class LayoutBlock extends StatelessWidget {
  final String id;
  final Widget child;
  final double xPos;
  final double yPos;
  final double width;
  final double height;

  const LayoutBlock({
    Key key,
    @required this.id,
    this.xPos,
    this.yPos,
    this.width,
    this.height,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class LayoutElementModel {
  final String uid;
  final double xPos;
  final double yPos;
  final double width;
  final double height;
  final Color color;

  LayoutElementModel({
    this.uid,
    this.xPos,
    this.yPos,
    this.width,
    this.height,
    this.color,
  });

  LayoutElementModel copyWith({
    String uid,
    double xPos,
    double yPos,
    double width,
    double height,
    Color color,
  }) {
    return LayoutElementModel(
      uid: uid ?? this.uid,
      xPos: xPos ?? this.xPos,
      yPos: yPos ?? this.yPos,
      width: width ?? this.width,
      height: height ?? this.height,
      color: color ?? this.color,
    );
  }

  LayoutElementModel combinedWith({
    LayoutElementModel xComponent,
    LayoutElementModel yComponent,
  }) {
    return copyWith(
      xPos: xComponent?.xPos ?? this.xPos,
      yPos: yComponent?.yPos ?? this.yPos,
      width: xComponent?.width ?? this.width,
      height: yComponent?.height ?? this.height,
    );
  }

  double get leftEdge => xPos;
  double get rightEdge => xPos + width;
  double get topEdge => yPos;
  double get bottomEdge => yPos + height;

  double get renderWidth => width; // width.clamp(16.0, double.maxFinite);
  double get renderHeight => height; //height.clamp(16.0, double.maxFinite);

  Rect getRectangle() {
    return Rect.fromPoints(Offset(0, 0), Offset(width, height));
  }
}
