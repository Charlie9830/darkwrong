import 'package:darkwrong/Field.dart';
import 'package:darkwrong/Fixture.dart';

class WorksheetViewModel {
  final Map<String, FieldModel> fields;
  final List<FixtureModel> fixtures;
  final Map<String, int> maxFieldLengths;

  WorksheetViewModel({
    this.fields,
    this.fixtures,
    this.maxFieldLengths,
  });
}