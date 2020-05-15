import 'package:darkwrong/presentation/fixture_creator/FixtureCreatorMultiplier.dart';
import 'package:flutter/material.dart';

class FixtureCreatorButtonsPanel extends StatelessWidget {
  final dynamic onMultiplierChanged;
  final dynamic onAddButtonPressed;
  final dynamic onCancelButtonPressed;

  const FixtureCreatorButtonsPanel({Key key, this.onMultiplierChanged, this.onAddButtonPressed, this.onCancelButtonPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FixtureCreatorMultiplier(
            defaultValue: '',
            onChanged: onMultiplierChanged,
          ),
          RaisedButton(
            child: Text('Add'),
            onPressed: onAddButtonPressed,
          ),
          OutlineButton(
            child: Text('Cancel'),
            onPressed: onCancelButtonPressed,
          )
        ],
      )
    );
  }
}