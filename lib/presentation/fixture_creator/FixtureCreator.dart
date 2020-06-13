import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/presentation/fixture_creator/FixtureCreatorButtonsPanel.dart';
import 'package:darkwrong/presentation/fixture_creator/FixtureTextField.dart';
import 'package:darkwrong/view_models/FixtureCreatorViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FixtureCreator extends StatefulWidget {
  final FixtureCreatorViewModel viewModel;
  const FixtureCreator({Key key, this.viewModel}) : super(key: key);

  @override
  _FixtureCreatorState createState() => _FixtureCreatorState();
}

class _FixtureCreatorState extends State<FixtureCreator> {
  TextEditingController _multiplierController;
  Map<String, TextEditingController> _fieldControllers;
  Map<String, FocusNode> _fieldFocusNodes;
  FocusNode _multiplierFocusNode;
  FocusNode _addButtonFocusNode;

  @override
  void initState() {
    _fieldControllers = Map<String, TextEditingController>.fromEntries(widget
        .viewModel.fields
        .map((field) => MapEntry(field.uid, TextEditingController())));

    _multiplierController = TextEditingController(text: '1');

    _fieldFocusNodes = Map<String, FocusNode>.fromEntries(widget
        .viewModel.fields
        .map((field) => MapEntry(field.uid, FocusNode())));

    _fieldFocusNodes.values.first?.requestFocus();

    _multiplierFocusNode = FocusNode();

    _addButtonFocusNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKey: _handleKeyPress,
      child: Container(
          child: Column(
        children: [
          Expanded(
            child: ListView(
                children: _buildFixtureTextFields(
                    context, widget.viewModel.fieldValues)),
          ),
          FixtureCreatorButtonsPanel(
            multiplierController: _multiplierController,
            multiplierFocusNode: _multiplierFocusNode,
            addButtonFocusNode: _addButtonFocusNode,
            onCancelButtonPressed: () {
              throw UnimplementedError();
            },
            onAddButtonPressed: _handleAddButtonPressed,
          ),
        ],
      )),
    );
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
            focusNode: _fieldFocusNodes[field.uid],
            controller: _getTextController(field.uid),
            options: fieldValues.getFieldContents(field.uid).values.toList(),
          )),
        ],
      );
    }).toList();
  }

  bool _handleKeyPress(FocusNode focusNode, RawKeyEvent rawKey) {
    if (rawKey is RawKeyDownEvent) {
      if (rawKey.logicalKey == LogicalKeyboardKey.enter ||
          rawKey.logicalKey == LogicalKeyboardKey.numpadEnter) {
        if (_addButtonFocusNode.hasFocus) {
          if (widget.viewModel.isPersistent) {
            // Pass Focus to first Field.
            _fieldFocusNodes.values.first?.requestFocus();
            return false;
          } else {
            // Do nothing as the widget will be getting demounted.
            return false;
          }
        }

        if (_multiplierFocusNode.hasFocus) {
          // Multiplier Entry has focus. So pass to Add Button.
          _addButtonFocusNode.requestFocus();
          return false;
        }

        // Determine which Field has Focus (if any).
        final focusNodes = _fieldFocusNodes.values.toList();
        final currentFieldFocusNode =
            focusNodes.firstWhere((node) => node.hasFocus == true);

        if (currentFieldFocusNode == null) {
          return false;
        }

        final currentIndex = focusNodes.indexOf(currentFieldFocusNode);
        final canTraverseNext = currentIndex < focusNodes.length - 1;

        if (canTraverseNext) {
          // Traverse to next Field.
          focusNodes[currentIndex + 1]?.requestFocus();
        } else {
          // Traverse to multiplier Field.
          _multiplierFocusNode.requestFocus();
        }
      }
    }

    return false;
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
      _fieldControllers.forEach((key, value) => value?.dispose());
    }

    _multiplierController?.dispose();

    if (_fieldFocusNodes != null) {
      for (var node in _fieldFocusNodes.values) {
        node.dispose();
      }
    }

    _multiplierFocusNode?.dispose();

    _addButtonFocusNode?.dispose();
    super.dispose();
  }
}
