import 'package:darkwrong/presentation/fast_table/CellIndexProvider.dart';
import 'package:darkwrong/presentation/fast_table/CellSelectionProvider.dart';
import 'package:darkwrong/presentation/fast_table/FastTable.dart';
import 'package:flutter/material.dart';

typedef void CellClickedCallback(int xIndex, int yIndex);
typedef void CellContentsChangedCallback(String newValue);

class Cell extends StatefulWidget {
  final String text;
  final CellClickedCallback onClick;
  final CellContentsChangedCallback onChanged;

  const Cell(this.text, {Key key, this.onClick, this.onChanged})
      : super(key: key);

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    final CellIndexProvider cellIndexProvider = CellIndexProvider.of(context);
    final CellSelectionProvider cellSelectionProvider =
        CellSelectionProvider.of(context);
    final isSelected = cellSelectionProvider.selectionConstraint
        .satisfiesConstraints(CellIndex(
      cellIndexProvider.xIndex,
      cellIndexProvider.yIndex,
    ));

    return Listener(
      onPointerDown: (_) {
        if (cellSelectionProvider?.onCellClicked != null)
          cellSelectionProvider.onCellClicked(
              cellIndexProvider.xIndex, cellIndexProvider.yIndex);
      },
      child: GestureDetector(
        onDoubleTap: () {
          setState(() {
            open = true;
          });
        },
        child: SizedBox(
          width: _getWidth(context),
          height: 40.0,
          child: Container(
            padding: EdgeInsets.only(left: 4, right: 4),
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).colorScheme.surface : null,
              border: Border(
                  right: BorderSide(color: Theme.of(context).dividerColor),
                  bottom: BorderSide(color: Theme.of(context).dividerColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (open)
                  Expanded(
                    child: _Open(
                      text: widget.text,
                      onChanged: (newValue) {
                        setState(() {
                          open = false;
                        });
                        if (widget.onChanged != null) {
                          widget.onChanged(newValue);
                        }
                      },
                    ),
                  ),
                if (!open) Text(widget.text ?? '-'),
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
  __OpenState createState() => __OpenState();
}

class __OpenState extends State<_Open> {
  TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: true,
      onEditingComplete: () => _handleSubmit(),
    );
  }

  void _handleSubmit() {
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
