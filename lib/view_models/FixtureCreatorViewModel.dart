import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValuesStore.dart';

class FixtureCreatorViewModel {
  final FieldValuesStore fieldValues;
  final List<FieldModel> fields;
  final dynamic onAddButtonPressed;

  FixtureCreatorViewModel({
    this.fieldValues,
    this.fields,
    this.onAddButtonPressed,
  });

}