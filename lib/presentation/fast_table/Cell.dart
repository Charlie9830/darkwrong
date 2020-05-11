import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  final String text;
  final bool isSelected;
  final dynamic onClick;

  const Cell(this.text, {Key key, this.isSelected, this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coercedText = text == null || text == '' ? '-' : text;
    return GestureDetector(
      onTap: onClick,
      child: SizedBox(
        width: _getWidth(context),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.red,
            width: 2.0,
            style: isSelected ? BorderStyle.solid : BorderStyle.none,
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(coercedText),
              VerticalDivider(),
            ],
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
