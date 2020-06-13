import 'package:darkwrong/presentation/fixture_creator/FixtureCreatorMultiplier.dart';
import 'package:flutter/material.dart';

class FixtureCreatorButtonsPanel extends StatelessWidget {
  final TextEditingController multiplierController;
  final FocusNode multiplierFocusNode;
  final FocusNode addButtonFocusNode;
  final dynamic onAddButtonPressed;
  final dynamic onCancelButtonPressed;

  const FixtureCreatorButtonsPanel(
      {Key key,
      this.multiplierController,
      this.onAddButtonPressed,
      this.onCancelButtonPressed,
      this.multiplierFocusNode,
      this.addButtonFocusNode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: FixtureCreatorMultiplier(
            controller: multiplierController,
            focusNode: multiplierFocusNode,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlineButton(
              child: Text('Cancel'),
              onPressed: onCancelButtonPressed,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: RaisedButton(
                child: Text('Add'),
                onPressed: onAddButtonPressed,
                focusNode: addButtonFocusNode,
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
