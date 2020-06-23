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

class LayoutCanvas extends StatefulWidget {
  LayoutCanvas({Key key}) : super(key: key);

  @override
  _LayoutCanvasState createState() => _LayoutCanvasState();
}

const double _minWidth = 20.0;
const double _minHeight = 20.0;

class _LayoutCanvasState extends State<LayoutCanvas> {
  Map<String, LayoutObject> _layoutObjects = {};
  Set<String> _selectedBlockIds = {};
  int _lastPointerId;
  double _leftBoundry = 0.0;
  double _rightBoundry = 0.0;
  double _startingWidth = 0.0;
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
                      _handleDragHandleDragged(
                          -50,
                          0,
                          0,
                          0,
                          DragHandlePosition.middleLeft,
                          1,
                          'helloworld');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () {
                      _handleDragHandleDragged(
                          50,
                          0,
                          0,
                          0,
                          DragHandlePosition.middleLeft,
                          1,
                          'helloworld');
                    },
                  ),
                  OutlineButton(
                      child: Text('Reset'),
                      onPressed: () {
                        setState(() {
                          final uid = "helloworld";
                          _layoutObjects = <String, LayoutObject>{}..addAll({
                              uid: LayoutObject(
                                uid: uid,
                                height: 100,
                                width: 100,
                                xPos: 500,
                                yPos: 200,
                              )
                            });
                          _selectedBlockIds = <String>{uid};
                          _leftBoundry = 0.0;
                          _rightBoundry = 0.0;
                          _startingWidth = 0.0;
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
        _layoutObjects.values.map((item) {
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
      _leftBoundry = 0.0;
      _rightBoundry = 0.0;
      _logicalDragHandle = null;
    });
  }

  void _handleResizeStart(
      DragHandlePosition position, int pointerId, String blockId) {
    final object = _layoutObjects[blockId];

    setState(() {
      _leftBoundry = object.xPos;
      _rightBoundry = object.xPos + object.width;
      _startingWidth = object.width;
      _lastPointerId = pointerId;
    });
  }

  double _getOpposingSideXPos(
      LayoutObject object, DragHandlePosition handlePosition) {
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

  double _getManipulatingSideXPos(LayoutObject object, double deltaX,
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

  bool _getDidFlipOverX(LayoutObject object, double deltaX,
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

  void _handleDragHandleDragged(
      double deltaX,
      double deltaY,
      double pointerXPos,
      double pointerYPos,
      DragHandlePosition physicalHandle,
      int pointerId,
      String blockId) {
    final originalObject = _layoutObjects[blockId];

    final currentLogicalHandle = _logicalDragHandle ?? physicalHandle;

    if (currentLogicalHandle == DragHandlePosition.middleRight) {
      if (originalObject.xPos + originalObject.width + deltaX < _leftBoundry) {
        // Crossover Update.
        final existing = _layoutObjects[blockId];
        final updatedObject = existing.copyWith(
          width: _leftBoundry - existing.xPos + _invertSign(deltaX),
          height: existing.height,
          xPos: existing.xPos + deltaX,
          yPos: existing.yPos,
        );
        setState(() {
          _layoutObjects = Map<String, LayoutObject>.from(_layoutObjects)
            ..update(blockId, (_) => updatedObject);
          _leftBoundry = updatedObject.xPos;
          _rightBoundry = updatedObject.xPos + updatedObject.width;
          _logicalDragHandle = _opposingDragHandles[currentLogicalHandle];
          _lastPointerId = pointerId;
        });
        return;
      } else {
        // Normal Update.
        final existing = _layoutObjects[blockId];
        final updatedObject = existing.copyWith(
          width: existing.width + deltaX,
          height: existing.height,
          xPos: existing.xPos,
          yPos: existing.yPos,
        );
        setState(() {
          _layoutObjects = Map<String, LayoutObject>.from(_layoutObjects)
            ..update(
              blockId,
              (_) => updatedObject,
            );
          _leftBoundry = updatedObject.xPos;
          _rightBoundry = updatedObject.xPos + updatedObject.width;
          _logicalDragHandle = currentLogicalHandle;
          _lastPointerId = pointerId;
        });
        return;
      }
    }

    if (currentLogicalHandle == DragHandlePosition.middleLeft) {
      if (originalObject.xPos + deltaX > _rightBoundry) {
        // Crossover Update.
        final pointerPos = _leftBoundry + deltaX;
        final difference = pointerPos - _rightBoundry;
        final existing = _layoutObjects[blockId];
        final updatedObject = existing.copyWith(
          width: difference,
          height: existing.height,
          xPos: _rightBoundry,
          yPos: existing.yPos,
        );

        if (updatedObject.width.isNegative) {
          print(updatedObject.width);
        }

        setState(() {
          _layoutObjects = Map<String, LayoutObject>.from(_layoutObjects)
            ..update(
              blockId,
              (_) => updatedObject,
            );
          _leftBoundry = updatedObject.xPos;
          _rightBoundry = updatedObject.xPos + updatedObject.width;
          _logicalDragHandle = _opposingDragHandles[currentLogicalHandle];
          _lastPointerId = pointerId;
        });
        return;
      } else {
        // Normal Update.
        final existing = _layoutObjects[blockId];
        final updatedObject = existing.copyWith(
          width: existing.width + _invertSign(deltaX),
          height: existing.height,
          xPos: existing.xPos + deltaX,
          yPos: existing.yPos,
        );
        setState(() {
          _layoutObjects = Map<String, LayoutObject>.from(_layoutObjects)
            ..update(
              blockId,
              (_) => updatedObject,
            );
          _leftBoundry = updatedObject.xPos;
          _rightBoundry = updatedObject.xPos + updatedObject.width;
          _logicalDragHandle = currentLogicalHandle;
          _lastPointerId = pointerId;
        });
        return;
      }
    }
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
    final newMap = Map<String, LayoutObject>.from(_layoutObjects);
    newMap[uid] = newMap[uid].copyWith(
      xPos: newMap[uid].xPos + xPosDelta,
      yPos: newMap[uid].yPos + yPosDelta,
    );

    setState(() {
      _layoutObjects = newMap;
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

class LayoutObject {
  final String uid;
  final double xPos;
  final double yPos;
  final double width;
  final double height;
  final Color color;

  LayoutObject({
    this.uid,
    this.xPos,
    this.yPos,
    this.width,
    this.height,
    this.color,
  });

  LayoutObject copyWith({
    String uid,
    double xPos,
    double yPos,
    double width,
    double height,
    Color color,
  }) {
    return LayoutObject(
      uid: uid ?? this.uid,
      xPos: xPos ?? this.xPos,
      yPos: yPos ?? this.yPos,
      width: width ?? this.width,
      height: height ?? this.height,
      color: color ?? this.color,
    );
  }

  double get renderWidth => width; // width.clamp(16.0, double.maxFinite);
  double get renderHeight => height; //height.clamp(16.0, double.maxFinite);

  Rect getRectangle() {
    return Rect.fromPoints(Offset(0, 0), Offset(width, height));
  }
}
