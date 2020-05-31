import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/field_values/FieldValue.dart';
import 'package:darkwrong/presentation/field_editor/FieldSelector.dart';
import 'package:darkwrong/view_models/FieldAndValuesEditorViewModel.dart';
import 'package:flutter/material.dart';

class ValuesEditor extends StatelessWidget {
  final FieldAndValuesEditorViewModel viewModel;

  const ValuesEditor({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String selectedFieldId = viewModel.selectedFieldId;
    final Iterable<FieldModel> fields =
        viewModel.fieldViewModels.map((vm) => vm.data);
    final List<FieldValue> values =
        selectedFieldId == null || selectedFieldId == ''
            ? <FieldValue>[]
            : viewModel.fieldValues
                .getFieldContents(selectedFieldId)
                .values
                .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: FieldSelector(
            selectedValue: fields.firstWhere(
                (item) => item.uid == viewModel.selectedFieldId,
                orElse: () => null),
            options: fields.toList(),
          ),
        ),
        Expanded(
          child: Card(
            child: Text('Coming Soon'),
          ),
        ),
      ],
    );
  }
}
