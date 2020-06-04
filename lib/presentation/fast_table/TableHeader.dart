import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  final Widget header;
  final double width;

  const TableHeader(this.header, {Key key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: Theme.of(context).dividerColor),
        )
      ),
      alignment: Alignment.center,
      width: width < 100 ? 100 : width,
      height: 40.0,
      child: header,
    );
  }
}