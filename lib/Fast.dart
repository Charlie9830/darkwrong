import 'package:darkwrong/main.dart';
import 'package:flutter/material.dart';

class Fast extends StatelessWidget {
  final List<Fixture> fixtures;
  Fast({Key key, this.fixtures}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: fixtures.length,
      itemBuilder: (context, index) {
        return FastRow(
          key: Key(fixtures[index].uid),
          fixture: fixtures[index],
        );
      }
    );
  }
}

class FastRow extends StatelessWidget {
  final Fixture fixture;
  FastRow({Key key, this.fixture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.fromHeight(48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(fixture.unitNumber),
          Text(fixture.position),
          Text(fixture.intrumentType),
          Text(fixture.wattage),
          Text(fixture.multicoreName),
          Text(fixture.multicoreNumber)
        ],
      )
    );
  }
}
