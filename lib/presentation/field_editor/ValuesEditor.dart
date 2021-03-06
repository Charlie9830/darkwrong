import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/models/MetadataDescriptor.dart';
import 'package:darkwrong/models/field_values/FieldValue.dart';
import 'package:darkwrong/presentation/fast_table/Cell.dart';
import 'package:darkwrong/presentation/fast_table/CellId.dart';
import 'package:darkwrong/presentation/fast_table/CellIndex.dart';
import 'package:darkwrong/presentation/fast_table/FastRow.dart';
import 'package:darkwrong/presentation/fast_table/FastTable.dart';
import 'package:darkwrong/presentation/fast_table/TableHeader.dart';
import 'package:darkwrong/presentation/field_editor/FieldSelector.dart';
import 'package:darkwrong/view_models/FieldAndValuesEditorViewModel.dart';
import 'package:flutter/material.dart';

class ValuesEditor extends StatelessWidget {
  final FieldAndValuesEditorViewModel viewModel;

  const ValuesEditor({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String selectedFieldId = viewModel.selectedFieldId;
    final FieldModel selectedField = viewModel.fieldViewModels
        .firstWhere((item) => item.data.uid == selectedFieldId,
            orElse: () => null)
        ?.data;

    final Iterable<FieldModel> fields =
        viewModel.fieldViewModels.map((vm) => vm.data);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: FieldSelector(
            selectedValue: fields.firstWhere(
                (item) => item.uid == viewModel.selectedFieldId,
                orElse: () => null),
            options: fields.toList(),
            onChanged: (field) => viewModel.onFieldSelect(field),
          ),
        ),
        Expanded(
          child: Card(
              child: selectedField == null
                  ? Text('Select a Field')
                  : _ValueTable(
                      field: selectedField,
                      fieldValues: viewModel.fieldValues,
                      onMetadataValueChanged: viewModel.onMetadataValueChanged,
                      onFieldValueChanged: viewModel.onFieldValueChanged,
                    )),
        ),
      ],
    );
  }
}

typedef void MetadataValueChangedCallback(
    FieldValueKey fieldKey, String propertyName, String newValue);
typedef void FieldValueChangedCallback(FieldValueKey fieldKey, String newValue);

class _ValueTable extends StatelessWidget {
  final FieldModel field;
  final FieldValuesStore fieldValues;
  final MetadataValueChangedCallback onMetadataValueChanged;
  final FieldValueChangedCallback onFieldValueChanged;

  const _ValueTable(
      {Key key,
      this.field,
      this.fieldValues,
      this.onMetadataValueChanged,
      this.onFieldValueChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MetadataDescriptor> descriptors =
        field.valueMetadataDescriptors.values.toList();
    final List<FieldValue> values =
        fieldValues.getFieldContents(field.uid).values.toList();
    int rowIndex = 0;
    return Text('Finish Me');
  }

  List<TableHeader> _buildDescriptorHeaders(
      List<MetadataDescriptor> descriptors) {
    return descriptors
        .map((descriptor) => TableHeader(Text(descriptor.friendlyName),
            width: descriptor.columnWidth))
        .toList();
  }
}
