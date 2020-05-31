import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/view_models/FieldViewModel.dart';

class FieldAndValuesEditorViewModel {
  final FieldValuesStore fieldValues;
  final String selectedFieldId;
  final int tabIndex;
  final List<FieldViewModel> fieldViewModels;
  final dynamic onAddNewField;
  final dynamic onTabChanged;
  final dynamic onFieldSelect;

  FieldAndValuesEditorViewModel({
    this.fieldValues,
    this.selectedFieldId,
    this.tabIndex,
    this.fieldViewModels,
    this.onAddNewField,
    this.onTabChanged,
    this.onFieldSelect,
  });
}
