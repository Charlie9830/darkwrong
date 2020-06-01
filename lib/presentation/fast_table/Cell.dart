import 'package:flutter/material.dart';

typedef void CellContentsChangedCallback(String newValue);

class Cell extends StatefulWidget {
  final String text;
  final bool isSelected;
  final dynamic onClick;
  final CellContentsChangedCallback onChanged;

  const Cell(this.text,
      {Key key, this.isSelected = false, this.onClick, this.onChanged})
      : super(key: key);

  @override
  _CellState createState() => _CellState();
}

class _CellState extends State<Cell> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        if (widget.onClick != null) widget.onClick();
      },
      child: GestureDetector(
        onDoubleTap: () {
          setState(() {
            open = true;
          });
        },
        child: SizedBox(
          width: _getWidth(context),
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(
              color: Colors.red,
              width: 2.0,
              style: widget.isSelected ? BorderStyle.solid : BorderStyle.none,
            )),
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
                VerticalDivider(),
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
      onSubmitted: (_) => _handleSubmit(),
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
