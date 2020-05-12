import 'package:darkwrong/models/Field.dart';

class HomeScreenViewModel {
  final Map<String, FieldModel> fields;
  final String selectedFieldFilterId;
  final bool isFixtureEditEnabled;
  final dynamic onDebugButtonPressed;
  final dynamic onAddFixtureButtonPressed;
  final dynamic onValueUpdate;
  final dynamic onFieldFilterSelect;
  final dynamic onDeleteFixtures;

  HomeScreenViewModel({
    this.selectedFieldFilterId,
    this.fields,
    this.isFixtureEditEnabled,
    this.onDebugButtonPressed,
    this.onAddFixtureButtonPressed,
    this.onValueUpdate,
    this.onFieldFilterSelect,
    this.onDeleteFixtures,
  });
}