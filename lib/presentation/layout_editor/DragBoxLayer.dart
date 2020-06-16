import 'package:darkwrong/presentation/layout_editor/DragBox.dart';
import 'package:darkwrong/presentation/layout_editor/DragHandle.dart';
import 'package:darkwrong/presentation/layout_editor/DragHandles.dart';
import 'package:darkwrong/presentation/layout_editor/LayoutCanvas.dart';
import 'package:flutter/material.dart';

typedef void OnDragBoxClickCallback(String blockId, int pointerId);

class DragBoxLayer extends StatelessWidget {
  final Map<String, LayoutBlock> blocks;
  final Set<String> selectedBlockIds;
  final dynamic onPositionChange;
  final dynamic onSizeChange;
  final OnDragBoxClickCallback onDragBoxClick;

  const DragBoxLayer({
    Key key,
    this.onSizeChange,
    this.blocks,
    this.selectedBlockIds,
    this.onDragBoxClick,
    this.onPositionChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ..._positionBlocks(),
        ..._drawDragBoxes(),
        ..._drawDragHandles(),
      ],
    );
  }

  List<Widget> _drawDragHandles() {
    return blocks.values.map((block) {
      final blockId = block.id;
      return Positioned(
        left: block.xPos - dragHandleWidth / 2,
        top: block.yPos - dragHandleHeight / 2,
        width: block.width + dragHandleWidth,
        height: block.height + dragHandleHeight,
        child: DragHandles(
          selected: selectedBlockIds.contains(blockId),
          xPos: block.xPos,
          yPos: block.yPos,
          height: block.height + dragHandleHeight,
          width: block.width + dragHandleWidth,
          onSizeChange:
              (widthDelta, heightDelta, xPosDelta, yPosDelta, pointerId) =>
                  _handleSizeChange(widthDelta, heightDelta, xPosDelta,
                      yPosDelta, blockId, pointerId),
        ),
      );
    }).toList();
  }

  List<Widget> _drawDragBoxes() {
    return blocks.values.map((block) {
      final blockId = block.id;
      return Positioned(
        left: block.xPos - dragHandleWidth / 2,
        top: block.yPos - dragHandleHeight / 2,
        width: block.width + dragHandleWidth,
        height: block.height + dragHandleHeight,
        child: DragBox(
          selected: selectedBlockIds.contains(blockId),
          xPos: block.xPos,
          yPos: block.yPos,
          height: block.height + dragHandleHeight,
          width: block.width + dragHandleWidth,
          onPositionChange: (xPosDelta, yPosDelta) =>
              _handlePositionChange(xPosDelta, yPosDelta, blockId),
          onClick: (pointerId) => onDragBoxClick?.call(blockId, pointerId),
        ),
      );
    }).toList();
  }

  void _handlePositionChange(
      double xPosDelta, double yPosDelta, String blockId) {
    onPositionChange(xPosDelta, yPosDelta, blockId);
  }

  void _handleSizeChange(double widthDelta, double heightDelta,
      double xPosDelta, double yPosDelta, String blockId, int pointerId) {
    onSizeChange(
        widthDelta, heightDelta, xPosDelta, yPosDelta, blockId, pointerId);
  }

  List<Widget> _positionBlocks() {
    return blocks.values.map((block) {
      return _positionBlock(block, block);
    }).toList();
  }

  Positioned _positionBlock(LayoutBlock block, Widget child) {
    return Positioned(
      top: block.yPos,
      left: block.xPos,
      width: block.width,
      height: block.height,
      child: child,
    );
  }
}
