import 'package:darkwrong/CellIndexProvider.dart';
import 'package:darkwrong/ColumnWidthsProvider.dart';
import 'package:flutter/material.dart';

class Cell extends StatelessWidget {
  final String text;

  const Cell(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _getWidth(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          VerticalDivider(),
        ],
      ),
    );
  }

  double _getWidth(BuildContext context) {
    final index = CellIndexProvider.of(context).index;
    final width = ColumnWidthsProvider.of(context).widths[index];

    return width > 48.0 ? width : 48.0;
  }
}