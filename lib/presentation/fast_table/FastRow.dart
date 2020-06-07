import 'package:darkwrong/constants.dart';
import 'package:darkwrong/presentation/fast_table/Cell.dart';
import 'package:flutter/material.dart';

class FastRow extends StatelessWidget {
  final List<Cell> children;
  final int yIndex;

  FastRow({Key key, this.yIndex, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox.fromSize(
          size: Size.fromHeight(rowHeight),
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyText2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: children,
            ),
          )),
    );
  }
}
