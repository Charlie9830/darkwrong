import 'package:darkwrong/presentation/fixture_creator/FixtureCreatorMultiplier.dart';
import 'package:flutter/material.dart';

class FixtureCreatorButtonsPanel extends StatelessWidget {
  final TextEditingController multiplierController;
  final FocusNode multiplierFocusNode;
  final FocusNode addButtonFocusNode;
  final dynamic onAddButtonPressed;
  final dynamic onClearButtonPressed;

  const FixtureCreatorButtonsPanel(
      {Key key,
      this.multiplierController,
      this.onAddButtonPressed,
      this.multiplierFocusNode,
      this.onClearButtonPressed,
      this.addButtonFocusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlineButton(
          child: Text('Clear'),
          onPressed: onClearButtonPressed,
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, right: 8.0),
          child: FixtureCreatorMultiplier(
            controller: multiplierController,
            focusNode: multiplierFocusNode,
          ),
        ),
        RaisedButton(
          child: Text('Add'),
          onPressed: onAddButtonPressed,
          focusNode: addButtonFocusNode,
        ),
      ],
    ));
  }
}
