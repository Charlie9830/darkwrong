import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/presentation/fixture_creator/FixtureCreatorButtonsPanel.dart';
import 'package:darkwrong/presentation/fixture_creator/FixtureTextField.dart';
import 'package:darkwrong/util/KeyboardHelpers.dart';
import 'package:darkwrong/view_models/FixtureCreatorViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _defaultMultiplierControllerText = '';
const _defaultFieldControllerText = '';

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
  bool _canAdd;

  @override
  void initState() {
    _fieldControllers = Map<String, TextEditingController>.fromEntries(
        widget.viewModel.fields.map((field) => MapEntry(field.uid,
            TextEditingController(text: _defaultFieldControllerText))));

    _fieldControllers.forEach((fieldId, controller) => controller
        .addListener(() => _handleFieldControllerChange(fieldId, controller)));

    _multiplierController =
        TextEditingController(text: _defaultMultiplierControllerText);

    _fieldFocusNodes = Map<String, FocusNode>.fromEntries(widget
        .viewModel.fields
        .map((field) => MapEntry(field.uid, FocusNode())));

    if (_fieldFocusNodes.values.isNotEmpty) {
      _fieldFocusNodes.values.first?.requestFocus();
    }

    _multiplierFocusNode = FocusNode();
    _addButtonFocusNode = FocusNode();

    _canAdd = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.viewModel.fields.isEmpty) {
      return _NoFieldsFallback();
    }

    return Focus(
      autofocus: true,
      onKey: _handleKeyPress,
      child: Container(
          child: Column(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                    children: _buildFixtureTextFields(
                        context, widget.viewModel.fieldValues)),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FixtureCreatorButtonsPanel(
                multiplierController: _multiplierController,
                multiplierFocusNode: _multiplierFocusNode,
                addButtonFocusNode: _addButtonFocusNode,
                onClearButtonPressed: _handleClearButtonPressed,
                onAddButtonPressed: _canAdd ? _handleAddButtonPressed : null,
              ),
            ),
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

  void _handleClearButtonPressed() {
    for (var controller in _fieldControllers.values) {
      controller.text = _defaultFieldControllerText;
    }

    _multiplierController.text = _defaultMultiplierControllerText;

    if (_fieldFocusNodes.values.isNotEmpty) {
      _fieldFocusNodes.values.first?.requestFocus();
    }

    setState(() {
      _canAdd = false;
    });
  }

  void _handleFieldControllerChange(
      String fieldId, TextEditingController controller) {
    final newCanAdd = _fieldControllers.values
        .any((item) => item.text != null && item.text != '');

    if (newCanAdd != _canAdd) {
      setState(() {
        _canAdd = newCanAdd;
      });
    }
  }

  bool _handleKeyPress(FocusNode focusNode, RawKeyEvent rawKey) {
    if (rawKey is RawKeyDownEvent) {
      if (enterDown(rawKey)) {
        if (rawKey.isControlPressed) {
          // Control + Enter pressed. Commit value.
          _handleAddButtonPressed();
          return false;
        }

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
        final currentFieldFocusNode = focusNodes
            .firstWhere((node) => node.hasFocus == true, orElse: () => null);

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
    if (_canAdd == false) {
      return;
    }

    final Map<String, String> values =
        Map<String, String>.from(_fieldControllers.map((fieldId, controller) {
      return MapEntry(fieldId, controller.text);
    }));

    final int multiplier = int.tryParse(_multiplierController.text) ?? 1;

    widget.viewModel
        .onAddButtonPressed(values, multiplier == 0 ? 1 : multiplier);
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

class _NoFieldsFallback extends StatelessWidget {
  const _NoFieldsFallback({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('No Fields'),
    );
  }
}
