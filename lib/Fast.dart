import 'package:darkwrong/main.dart';
import 'package:flutter/material.dart';

class Fast extends StatelessWidget {
  final List<Fixture> fixtures;
  final MaxColumnLengths maxColumnLengths;
  Fast({Key key, this.fixtures, this.maxColumnLengths}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double multiplier = 8.0;
    return ListView.builder(
        itemCount: fixtures.length,
        itemBuilder: (context, index) {
          final fixture = fixtures[index];
          return FastRow(
            key: Key(fixture.uid),
            children: [
              Cell(fixture.unitNumber, width: maxColumnLengths.unitNumber * multiplier),
              Cell(fixture.position, width: maxColumnLengths.position * multiplier),
              Cell(fixture.instrumentType, width: maxColumnLengths.instrumentType * multiplier),
              Cell(fixture.wattage, width: maxColumnLengths.wattage * multiplier),
              Cell(fixture.multicoreName, width: maxColumnLengths.multicoreName * multiplier),
              Cell(fixture.multicoreNumber, width: maxColumnLengths.multicoreNumber * multiplier),
              Cell(fixture.uid, width: 400),
            ],
          );
        });
  }
}

class FastRow extends StatelessWidget {
  final List<Widget> children;

  FastRow({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
          child: SizedBox.fromSize(
            size: Size.fromHeight(48),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.caption,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: children,
              ),
            )),
    );
  }
}

class Cell extends StatelessWidget {
  final String text;
  final double width;

  const Cell(this.text, {Key key, this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final coercedWidth = width > 48.0 ? width : 48.0;
    return SizedBox(
      width: coercedWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          VerticalDivider(),
        ],
      ),
    );
  }
}
