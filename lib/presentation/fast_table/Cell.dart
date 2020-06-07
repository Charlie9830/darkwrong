import 'package:darkwrong/presentation/fast_table/CellSelectionProvider.dart';
import 'package:darkwrong/presentation/fast_table/FastTable.dart';
import 'package:flutter/material.dart';

typedef void CellClickedCallback(int xIndex, int yIndex);
typedef void CellContentsChangedCallback(String newValue);

const double _defaultDividerWidth = 1.0;
const double _selectedDividerWidth = 1.5;

class Cell extends StatefulWidget {
  final String text;
  final CellIndex index;
  final CellClickedCallback onClick;
  final CellContentsChangedCallback onChanged;

  const Cell(this.text,
      {Key key, @required this.index, this.onClick, this.onChanged})
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
    final isSelected = cellSelectionProvider.selectionConstraint
        .satisfiesConstraints(widget.index);

    final isActive =
        widget.index == cellSelectionProvider.selectionConstraint.anchor;

    final isOpen = isActive && cellSelectionProvider.isActiveCellOpen;

    final borderState =
        cellSelectionProvider.selectionConstraint.getBorderState(widget.index);

    final dividerColor = Theme.of(context).dividerColor;
    final borderAccentColor = Theme.of(context).accentColor;

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
          height: 40.0,
          child: Container(
            padding: EdgeInsets.only(left: 4, right: 4),
            decoration: BoxDecoration(
                color: isActive ? Theme.of(context).colorScheme.surface : null,
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
                      text: cellSelectionProvider.activeCellInitialCharacter,
                      onChanged: (newValue) {
                        cellSelectionProvider?.onEditingComplete();
                        if (widget.onChanged != null) {
                          
                          widget.onChanged(newValue);
                        }
                      },
                    ),
                  ),
                if (!isOpen) Text(widget.text ?? '-'),
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
  final String text;
  final dynamic onChanged;

  _Open({Key key, this.text, this.onChanged}) : super(key: key);

  @override
  _OpenState createState() => _OpenState();
}

class _OpenState extends State<_Open> {
  TextEditingController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.text);
    _focusNode = FocusNode();
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onEditingComplete: () => _handleSubmit(),
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

  void _handleSubmit() {
    print('Submitting');
    _focusNode.unfocus();
    widget.onChanged(_controller.text);
  }
}

class _Closed extends StatelessWidget {
  final String text;
  const _Closed({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}
