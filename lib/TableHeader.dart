import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  final Widget header;
  final double width;

  const TableHeader(this.header, {Key key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: width < 100 ? 100 : width,
      height: 48.0,
      child: header,
    );
  }
}