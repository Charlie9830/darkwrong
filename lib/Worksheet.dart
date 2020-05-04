import 'package:darkwrong/Cell.dart';
import 'package:darkwrong/FastRow.dart';
import 'package:darkwrong/FastTable.dart';
import 'package:darkwrong/Field.dart';
import 'package:darkwrong/Fixture.dart';
import 'package:darkwrong/TableHeader.dart';
import 'package:darkwrong/view_models/WorksheetViewModel.dart';
import 'package:flutter/material.dart';

class Worksheet extends StatelessWidget {
  final WorksheetViewModel viewModel;

  const Worksheet({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FastTable(
          headers: viewModel.fields.entries.map((field) {
            return TableHeader(
              Text(field.value.name),
              key: Key(field.key),
              width: viewModel.maxFieldLengths[field.key] * 8.0,
            );
          }).toList(),
          rows: viewModel.fixtures.map((fixture) {
            return FastRow(
              key: Key(fixture.uid),
              children: fixture.fieldValues.entries.map((entry) {
                return Cell(
                  entry.value.value,
                );
              }).toList(),
            );
          }).toList(),
        );
  }
}