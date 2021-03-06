import 'package:darkwrong/constants.dart';
import 'package:darkwrong/presentation/fast_table/CellId.dart';
import 'package:darkwrong/presentation/fast_table/CellIndex.dart';
import 'package:darkwrong/presentation/fast_table/CellSelectionProvider.dart';
import 'package:flutter/material.dart';

typedef void CellClickedCallback(int xIndex, int yIndex);
typedef void CellContentsChangedCallback(String newValue);

const double _defaultDividerWidth = 1.0;
const double _selectedDividerWidth = 1.5;

class Cell extends StatefulWidget {
  final String text;
  final CellIndex index;
  final CellId id;

  const Cell(this.text, {Key key, @required this.index, @required this.id})
      : super(key: key);

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final CellSelectionProvider cellSelectionProvider =
        CellSelectionProvider.of(context);
    final selectionConstraint = cellSelectionProvider.selectionConstraint;
    final isSelected = selectionConstraint.satisfiesConstraints(widget.index) ||
        selectionConstraint.isForeignSelection(widget.index);

    final isActive = widget.index == selectionConstraint.anchor;
    final isOpen = isActive && cellSelectionProvider.isActiveCellOpen;
    final isForeign = selectionConstraint.isForeignSelection(widget.index);
    final borderState = selectionConstraint.getBorderState(widget.index);
    final dividerColor = Theme.of(context).dividerColor;
    final borderAccentColor = Theme.of(context).accentColor;

    final backgroundColor = isActive
        ? Theme.of(context).focusColor
        : isForeign ? Theme.of(context).focusColor : null;

    return Listener(
      onPointerDown: (_) {
        if (cellSelectionProvider?.onCellClicked != null)
          cellSelectionProvider.onCellClicked(widget.index);
      },
      child: MouseRegion(
        onEnter: (pointerEvent) {
          if (pointerEvent.down) {
            cellSelectionProvider.onAdjustmentRequested(widget.index);
          }
        },
        child: SizedBox(
          width: _getWidth(context),
          height: rowHeight,
          child: Container(
            padding: EdgeInsets.only(left: 4, right: 4),
            decoration: BoxDecoration(
                color: backgroundColor,
                border: Border(
                  right: BorderSide(
                      width: borderState.right && isSelected
                          ? _selectedDividerWidth
                          : _defaultDividerWidth,
                      color: borderState.right && isSelected
                          ? borderAccentColor
                          : dividerColor),
                  bottom: BorderSide(
                      width: borderState.bottom && isSelected
                          ? _selectedDividerWidth
                          : _defaultDividerWidth,
                      color: borderState.bottom && isSelected
                          ? borderAccentColor
                          : dividerColor),
                  left: BorderSide(
                      width: borderState.left && isSelected
                          ? _selectedDividerWidth
                          : _defaultDividerWidth,
                      color: borderState.left && isSelected
                          ? borderAccentColor
                          : dividerColor),
                  top: BorderSide(
                      width: borderState.top && isSelected
                          ? _selectedDividerWidth
                          : _defaultDividerWidth,
                      color: borderState.top && isSelected
                          ? borderAccentColor
                          : dividerColor),
                )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isActive && isOpen)
                  Expanded(
                    child: _Open(
                      controller: cellSelectionProvider.openCellTextController,
                    ),
                  ),
                if (!isOpen)
                  Expanded(
                    child: Text(
                      widget.text ?? '-',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getWidth(BuildContext context) {
    // final index = CellIndexProvider.of(context).index;
    // final width = ColumnWidthsProvider.of(context).widths.elementAt(index);

    // return width > 48.0 ? width : 48.0;
    return 120.0;
  }
}

class _Open extends StatefulWidget {
  final TextEditingController controller;
  final dynamic onChanged;

  _Open({Key key, this.onChanged, this.controller}) : super(key: key);

  @override
  _OpenState createState() => _OpenState();
}

class _OpenState extends State<_Open> {
  FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.requestFocus();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      textAlignVertical: TextAlignVertical.center,
      style: Theme.of(context).textTheme.bodyText2,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.none)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(style: BorderStyle.none)),
      ),
    );
  }
}
