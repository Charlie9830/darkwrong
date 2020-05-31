import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/models/field_values/FieldValue.dart';
import 'package:darkwrong/models/field_values/InstrumentNameValue.dart';
import 'package:darkwrong/presentation/fast_table/Cell.dart';
import 'package:darkwrong/presentation/fast_table/FastRow.dart';
import 'package:darkwrong/presentation/fast_table/FastTable.dart';
import 'package:darkwrong/presentation/fast_table/TableHeader.dart';
import 'package:darkwrong/presentation/field_editor/FieldSelector.dart';
import 'package:darkwrong/util/getCellId.dart';
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
                    )),
        ),
      ],
    );
  }
}

class _ValueTable extends StatelessWidget {
  final FieldModel field;
  final FieldValuesStore fieldValues;

  const _ValueTable({Key key, this.field, this.fieldValues}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return field.type == FieldType.instrumentName
        ? _InstrumentNameTable(
            field: field,
            values: _getInstrumentNameValues(field, fieldValues),
          )
        : Text('Please select Instrument Name');
  }

  List<InstrumentNameValue> _getInstrumentNameValues(
      FieldModel field, FieldValuesStore fieldValues) {
    return fieldValues
        .getFieldContents(field.uid)
        .values
        .cast<InstrumentNameValue>()
        .toList();
  }
}

const _valueColumnName = "Value";
const _shortNameColumnName = "Short name";
const _noteColumnName = "Note";
const _typeColumnName = "Type";

class _InstrumentNameTable extends StatelessWidget {
  final FieldModel field;
  final List<InstrumentNameValue> values;

  const _InstrumentNameTable({Key key, this.field, this.values})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FastTable(
      headers: [
        TableHeader(Text(_valueColumnName), width: 100),
        TableHeader(Text(_shortNameColumnName), width: 50),
        TableHeader(Text(_noteColumnName), width: 200),
        TableHeader(Text(_typeColumnName), width: 50)
      ],
      rows: values.map(
        (item) => FastRow(
          key: ValueKey(item.key),
          children: <Cell>[
            Cell(item.asText,
                key: Key(getCellId(item.key.toString(), _valueColumnName))),
            Cell(item.shortValue,
                key: Key(getCellId(item.key.toString(), _shortNameColumnName))),
            Cell(item.note,
                key: Key(getCellId(item.key.toString(), _noteColumnName))),
            Cell(item.instrumentType.toString(),
                key: Key(getCellId(item.key.toString(), _typeColumnName)))
          ],
        ),
      ).toList(),
    );
  }
}
