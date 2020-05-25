import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/NewFixturesRequest.dart';
import 'package:darkwrong/presentation/fixture_creator/FixtureCreatorButtonsPanel.dart';
import 'package:darkwrong/presentation/fixture_creator/FixtureTextFieldsList.dart';
import 'package:darkwrong/view_models/FixtureCreatorViewModel.dart';
import 'package:flutter/material.dart';

class FixtureCreator extends StatefulWidget {
  final FixtureCreatorViewModel viewModel;
  const FixtureCreator({Key key, this.viewModel}) : super(key: key);

  @override
  _FixtureCreatorState createState() => _FixtureCreatorState();
}

class _FixtureCreatorState extends State<FixtureCreator> {
  NewFixturesRequest request = NewFixturesRequest.initial();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Expanded(
          child: FixtureTextFieldsList(
            fieldValues: widget.viewModel.fieldValues,
            fields: widget.viewModel.fields,
            onUpdatedToExistingValue: _handleFieldUpdatedToExistingValue,
            onUpdatedToNewValue: _handleFieldUpdatedToNewValue,
          ),
        ),
        FixtureCreatorButtonsPanel(
          onMultiplierChanged: (String newValue) => setState(() {
            request =
                request.copyWith(multiplier: int.parse(newValue, radix: 10));
          }),
          onAddButtonPressed: () {
            widget.viewModel.onAddButtonPressed(request);
          },
        ),
      ],
    ));
  }

  void _handleFieldUpdatedToNewValue(String fieldId, String value) {
    setState(() {
      request = request.copyWith(
        newValues: Map<String, String>.from(request.newValues)
          ..addAll(<String, String>{fieldId: value}),
        existingValueKeys:
            Map<String, FieldValueKey>.from(request.existingValueKeys)
              ..removeWhere((key, value) => key == fieldId),
      );
    });
  }

  void _handleFieldUpdatedToExistingValue(
      String fieldId, FieldValueKey valueKey) {
    setState(() {
      request = request.copyWith(
          newValues: Map<String, String>.from(request.newValues)
            ..removeWhere((key, value) => key == fieldId),
          existingValueKeys:
              Map<String, FieldValueKey>.from(request.existingValueKeys)
                ..addAll(<String, FieldValueKey>{fieldId: valueKey}));
    });
  }
}
