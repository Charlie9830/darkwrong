import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/presentation/fixture_creator/FixtureTextField.dart';
import 'package:flutter/material.dart';

typedef void FieldUpdatedToExistingValueCallback(
    String fieldId, FieldValueKey valueKey);
typedef void FieldUpdatedToNewValueCallback(String fieldId, String value);

class FixtureTextFieldsList extends StatelessWidget {
  final List<FieldModel> fields;
  final FieldValuesStore fieldValues;
  final FieldUpdatedToExistingValueCallback onUpdatedToExistingValue;
  final FieldUpdatedToNewValueCallback onUpdatedToNewValue;

  const FixtureTextFieldsList(
      {Key key,
      this.fields,
      this.fieldValues,
      this.onUpdatedToExistingValue,
      this.onUpdatedToNewValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
          shrinkWrap: true,
      children: fields.map((item) {
        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(item.name, style: Theme.of(context).textTheme.caption),
            ),
            Expanded(
                child: FixtureTextField(
              key: Key(item.uid),
              options: fieldValues.getFieldContents(item.uid).values.toList(),
              onExistingOptionSubmitted: (valueKey) =>
                  onUpdatedToExistingValue(item.uid, valueKey),
              onNewOptionSubmitted: (value) =>
                  onUpdatedToNewValue(item.uid, value),
            )),
          ],
        );
      }).toList(),
    ));
  }
}
