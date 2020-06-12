import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/presentation/fixture_creator/FixtureCreatorButtonsPanel.dart';
import 'package:darkwrong/presentation/fixture_creator/FixtureTextField.dart';
import 'package:darkwrong/view_models/FixtureCreatorViewModel.dart';
import 'package:flutter/material.dart';

class FixtureCreator extends StatefulWidget {
  final FixtureCreatorViewModel viewModel;
  const FixtureCreator({Key key, this.viewModel}) : super(key: key);

  @override
  _FixtureCreatorState createState() => _FixtureCreatorState();
}

class _FixtureCreatorState extends State<FixtureCreator> {
  TextEditingController _multiplierController;
  Map<String, TextEditingController> _fieldControllers;

  @override
  void initState() {
    _fieldControllers = Map<String, TextEditingController>.fromEntries(widget
        .viewModel.fields
        .map((field) => MapEntry(field.uid, TextEditingController())));

    _multiplierController = TextEditingController(text: '1');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Expanded(
          child: ListView(
              children: _buildFixtureTextFields(
                  context, widget.viewModel.fieldValues)),
        ),
        FixtureCreatorButtonsPanel(
          multiplierController: _multiplierController,
          onCancelButtonPressed: () {
            throw UnimplementedError();
          },
          onAddButtonPressed: _handleAddButtonPressed,
        ),
      ],
    ));
  }

  List<Widget> _buildFixtureTextFields(
      BuildContext context, FieldValuesStore fieldValues) {
    return widget.viewModel.fields.map((field) {
      return Row(
        children: [
          Container(
            width: 140.0,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                field.name,
                style: Theme.of(context).textTheme.caption,
                overflow: TextOverflow.clip,
                maxLines: 1,
              ),
            ),
          ),
          Expanded(
              child: FixtureTextField(
            key: Key(field.uid),
            controller: _getTextController(field.uid),
            options: fieldValues.getFieldContents(field.uid).values.toList(),
          )),
        ],
      );
    }).toList();
  }

  TextEditingController _getTextController(String fieldId) {
    if (_fieldControllers.containsKey(fieldId)) {
      return _fieldControllers[fieldId];
    }

    throw Exception(
        'Could not find a textEditingController for fieldId $fieldId.');
  }

  void _handleAddButtonPressed() {
    final Map<String, String> values =
        Map<String, String>.from(_fieldControllers.map((fieldId, controller) {
      return MapEntry(fieldId, controller.text);
    }));

    final int multiplier = int.tryParse(_multiplierController.text) ?? 1;

    widget.viewModel.onAddButtonPressed(values, multiplier);
  }

  @override
  void dispose() {
    if (_fieldControllers != null) {
      _fieldControllers.forEach((key, value) => value.dispose());
    }

    _multiplierController.dispose();
    super.dispose();
  }
}
