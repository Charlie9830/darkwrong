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
  double _startingXPos = 0.0;
  double _startingWidth = 0.0;
  DragHandlePosition _currentDragHandle;
  DragHandlePosition _actualDragHandle;

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
              child: Text(_currentDragHandle
                      .toString()
                      ?.replaceAll('DragHandlePosition.', '') ??
                  'Null'),
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
                      child: Text('Reset'),
                      onPressed: () {
                        setState(() {
                          _layoutObjects = <String, LayoutObject>{};
                          _selectedBlockIds = <String>{};
                          _startingXPos = 0.0;
                          _startingWidth = 0.0;
                          _currentDragHandle = null;
                        });
                      }),
                  RaisedButton(
                    child: Text('New'),
                    onPressed: () {
                      setState(() {
                        final uid = getUid();
                        _layoutObjects =
                            Map<String, LayoutObject>.from(_layoutObjects)
                              ..addAll({
                                uid: LayoutObject(
                                  uid: uid,
                                  height: 100,
                                  width: 100,
                                  xPos: 25,
                                  yPos: 25,
                                )
                              });
                      });
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
      _startingXPos = 0.0;
      _currentDragHandle = null;
    });
  }

  void _handleResizeStart(
      DragHandlePosition position, int pointerId, String blockId) {
    final object = _layoutObjects[blockId];

    setState(() {
      _startingXPos = object.xPos;
      _startingWidth = object.width;
      _lastPointerId = pointerId;
      _actualDragHandle = position;
    });
  }

  void _handleDragHandleDragged(
      double deltaX,
      double deltaY,
      double pointerXPos,
      double pointerYPos,
      DragHandlePosition handlePosition,
      int pointerId,
      String blockId) {
    final object = _layoutObjects[blockId];

    final double crossOverPoint = () {
      if (_currentDragHandle == DragHandlePosition.middleRight) {
        if (_currentDragHandle == _actualDragHandle) {
          return _startingXPos;
        } else {
          return _startingXPos + _startingWidth;
        }
      }

      if (_currentDragHandle == DragHandlePosition.middleLeft) {
        if (_currentDragHandle == _actualDragHandle) {
          return _startingXPos + _startingWidth;
        } else {
          return _startingXPos;
        }
      }
    }();

    bool didFlipOver = false;

    final DragHandlePosition currentDragHandle = () {
      if (_currentDragHandle == null) {
        return handlePosition;
      }

      if (_currentDragHandle == DragHandlePosition.middleRight) {
        if (object.xPos + object.width + deltaX <= crossOverPoint) {
          didFlipOver = true;
          return DragHandlePosition.middleLeft;
        } else {
          return _currentDragHandle;
        }
      }

      if (_currentDragHandle == DragHandlePosition.middleLeft) {
        if (object.xPos + deltaX >= crossOverPoint) {
          didFlipOver = true;
          return DragHandlePosition.middleRight;
        } else {
          return _currentDragHandle;
        }
      }
    }();

    switch (currentDragHandle) {
      case DragHandlePosition.topLeft:
        // TODO: Handle this case.
        break;
      case DragHandlePosition.topCenter:
        // TODO: Handle this case.
        break;
      case DragHandlePosition.topRight:
        // TODO: Handle this case.
        break;
      case DragHandlePosition.middleRight:
        final double widthDelta = deltaX;
        final double heightDelta = 0;
        final double xPosDelta = 0;
        final double yPosDelta = 0;

        final newWidth = object.width + widthDelta;
        final newHeight = object.height + heightDelta;
        final newXPos = object.xPos + xPosDelta;
        final newYPos = object.yPos + yPosDelta;

        setState(() {
          _layoutObjects = Map<String, LayoutObject>.from(_layoutObjects)
            ..update(
              blockId,
              (existing) => existing.copyWith(
                width: newWidth.isNegative ? 0.0 : newWidth,
                height: newHeight,
                xPos: newXPos,
                yPos: newYPos,
              ),
            );
          _lastPointerId = pointerId;
          _currentDragHandle = currentDragHandle;
        });
        break;
      case DragHandlePosition.bottomRight:
        // TODO: Handle this case.
        break;
      case DragHandlePosition.bottomCenter:
        // TODO: Handle this case.
        break;
      case DragHandlePosition.bottomLeft:
        // TODO: Handle this case.
        break;
      case DragHandlePosition.middleLeft:
        final double widthDelta = _invertSign(deltaX);
        final double heightDelta = 0;
        final double xPosDelta = deltaX;
        final double yPosDelta = 0;

        final newWidth = object.width + widthDelta;
        final newHeight = object.height + heightDelta;
        final newXPos = object.xPos + xPosDelta;
        final newYPos = object.yPos + yPosDelta;

        setState(() {
          _layoutObjects = Map<String, LayoutObject>.from(_layoutObjects)
            ..update(
              blockId,
              (existing) => existing.copyWith(
                  width: newWidth.isNegative ? 0.0 : newWidth,
                  height: newHeight,
                  xPos: newXPos,
                  yPos: newYPos),
            );

          _lastPointerId = pointerId;
          _currentDragHandle = currentDragHandle;
        });
        break;

      default:
        print('Taking no action');
        break;
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
