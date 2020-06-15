import 'package:darkwrong/presentation/layout_editor/DragContainer.dart';
import 'package:darkwrong/presentation/layout_editor/DragHandle.dart';
import 'package:darkwrong/util/getUid.dart';
import 'package:flutter/material.dart';

class LayoutCanvas extends StatefulWidget {
  LayoutCanvas({Key key}) : super(key: key);

  @override
  _LayoutCanvasState createState() => _LayoutCanvasState();
}

class _LayoutCanvasState extends State<LayoutCanvas> {
  Map<String, LayoutObject> _layoutObjects = {};
  String _selectedObjectId = '';

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._buildObjects(),
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

  List<Widget> _buildObjects() {
    return _layoutObjects.values.map((item) {
      final isSelected = item.uid == _selectedObjectId;
      final child = Container(color: Colors.pink);

      return Positioned(
          top: isSelected ? item.yPos - dragHandleHeight / 2 : item.yPos,
          left: isSelected ? item.xPos - dragHandleWidth / 2 : item.xPos,
          width: isSelected ? item.width + dragHandleWidth : item.width,
          height: isSelected ? item.height + dragHandleHeight : item.height,
          child: DragContainer(
            child: child,
            selected: isSelected,
            height: item.height + dragHandleHeight,
            width: item.width + dragHandleWidth,
            onPositionChange: (xPosDelta, yPosDelta) =>
                _handlePositionChange(item.uid, xPosDelta, yPosDelta),
            onSizeChange: (widthDelta, heightDelta, xPosDelta, yPosDelta) =>
                _handleSizeChange(
                    item.uid, widthDelta, heightDelta, xPosDelta, yPosDelta),
            onSelected: () {
              if (isSelected == false) {
                setState(() {
                  _selectedObjectId = item.uid;
                });
              }
            },
          ));
    }).toList();
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

  void _handleSizeChange(String uid, double widthDelta, double heightDelta,
      double xPosDelta, double yPosDelta) {
    final newMap = Map<String, LayoutObject>.from(_layoutObjects);
    final item = newMap[uid];
    newMap[uid] = item.copyWith(
      width: item.width + widthDelta,
      height: item.height + heightDelta,
      xPos: item.xPos + xPosDelta,
      yPos: item.yPos + yPosDelta,
    );

    setState(() {
      _layoutObjects = newMap;
    });
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
