import 'package:darkwrong/presentation/layout_editor/DragBoxLayer.dart';
import 'package:darkwrong/util/getUid.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DragBoxLayer(
          selectedBlockIds: _selectedBlockIds,
          blocks: _buildBlocks(),
          onPositionChange: (xPosDelta, yPosDelta, blockId) {
            _handlePositionChange(blockId, xPosDelta, yPosDelta);
          },
          onSizeChange:
              (widthDelta, heightDelta, xPosDelta, yPosDelta, blockId) {
            _handleSizeChange(
                blockId, widthDelta, heightDelta, xPosDelta, yPosDelta);
          },
          onDragBoxClick: (blockId) {
            setState(() {
              _selectedBlockIds = <String>{blockId};
            });
          },
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: RaisedButton(
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
            ))
      ],
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
            height: item.height,
            width: item.width,
            child: Container(
                color: item.uid.hashCode.isEven
                    ? Colors.deepOrange
                    : Colors.deepPurple),
          ));
    }));
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
  ) {
    final newMap = Map<String, LayoutObject>.from(_layoutObjects);
    final item = newMap[uid];
    final shouldClampWidth =
        _shouldClamp(_minWidth, double.maxFinite, item.width + widthDelta);
    final shouldClampHeight =
        _shouldClamp(_minHeight, double.maxFinite, item.height + heightDelta);
    final xPos = shouldClampWidth ? item.xPos : item.xPos + xPosDelta;
    final yPos = shouldClampHeight ? item.yPos : item.yPos + yPosDelta;

    newMap[uid] = item.copyWith(
      width: shouldClampWidth ? item.width : item.width + widthDelta,
      height: shouldClampHeight ? item.height : item.height + heightDelta,
      xPos: xPos,
      yPos: yPos,
    );

    setState(() {
      _layoutObjects = newMap;
    });
  }

  bool _shouldClamp(double min, double max, double value) {
    return !(value > min && value < max);
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
}
