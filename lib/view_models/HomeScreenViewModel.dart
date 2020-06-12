import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/view_models/WorksheetLeftRailViewModel.dart';

class HomeScreenViewModel {
  final Map<String, FieldModel> fields;
  final String selectedFieldFilterId;
  final bool isFixtureEditEnabled;
  final WorksheetLeftRailViewModel worksheetLeftRailViewModel;
  final dynamic onDebugButtonPressed;
  final dynamic onAddFixtureButtonPressed;
  final dynamic onFieldFilterSelect;
  final dynamic onDeleteFixtures;

  HomeScreenViewModel({
    this.selectedFieldFilterId,
    this.fields,
    this.isFixtureEditEnabled,
    this.worksheetLeftRailViewModel,
    this.onDebugButtonPressed,
    this.onAddFixtureButtonPressed,
    this.onFieldFilterSelect,
    this.onDeleteFixtures,
  });
}