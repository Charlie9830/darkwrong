import 'package:darkwrong/enums.dart';
import 'package:darkwrong/presentation/field_editor/FieldEncodingSelector.dart';
import 'package:darkwrong/presentation/field_editor/FieldListTile.dart';
import 'package:darkwrong/view_models/FieldAndValuesEditorViewModel.dart';
import 'package:flutter/material.dart';

class FieldEditor extends StatelessWidget {
  final FieldAndValuesEditorViewModel viewModel;
  final String editingFieldId;
  final dynamic onFieldEditingStart;
  final dynamic onFieldEditingComplete;

  const FieldEditor(
      {Key key,
      this.viewModel,
      this.editingFieldId,
      this.onFieldEditingStart,
      this.onFieldEditingComplete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _AddFieldControl(
            onAddNewField: viewModel.onAddNewField,
          ),
        )),
        Expanded(
          child: Card(
            child: ListView(
                children: viewModel.fieldViewModels
                    .map((vm) => FieldListTile(
                          key: Key(vm.data.uid),
                          open: vm.data.uid == editingFieldId,
                          enabled: editingFieldId == '' ||
                              vm.data.uid == editingFieldId,
                          fieldName: vm.data.name,
                          fieldEncoding: vm.data.encoding,
                          onDeletePressed: vm.onDeletePressed,
                          onEditPressed: () => onFieldEditingStart(vm.data.uid),
                          onViewValuesPressed: vm.onViewValuesPressed,
                          onEditingComplete: (request) {
                            onFieldEditingComplete();
                            vm.onChanged(request);
                          },
                        ))
                    .toList()),
          ),
        )
      ],
    );
  }
}

class _AddFieldControl extends StatefulWidget {
  final dynamic onAddNewField;

  _AddFieldControl({
    this.onAddNewField,
  });

  @override
  __AddFieldControlState createState() => __AddFieldControlState();
}

class __AddFieldControlState extends State<_AddFieldControl> {
  TextEditingController _fieldNameController;
  ValueEncoding _selectedEncoding;

  @override
  void initState() {
    _fieldNameController = TextEditingController();
    _selectedEncoding = ValueEncoding.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _fieldNameController,
          decoration: InputDecoration(hintText: 'Field Name'),
        ),
        FieldEncodingSelector(
          selectedValue: _selectedEncoding,
          onChanged: (value) => setState(() {
            _selectedEncoding = value;
          }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RaisedButton(
                child: Text('Add'),
                onPressed: () {
                  widget.onAddNewField(
                      _fieldNameController.text, _selectedEncoding);
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
