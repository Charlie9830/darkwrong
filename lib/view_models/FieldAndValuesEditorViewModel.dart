import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/presentation/field_editor/ValuesEditor.dart';
import 'package:darkwrong/view_models/FieldViewModel.dart';

class FieldAndValuesEditorViewModel {
  final FieldValuesStore fieldValues;
  final String selectedFieldId;
  final int tabIndex;
  final List<FieldViewModel> fieldViewModels;
  final dynamic onAddNewField;
  final dynamic onTabChanged;
  final dynamic onFieldSelect;
  final MetadataValueChangedCallback onMetadataValueChanged;

  FieldAndValuesEditorViewModel({
    this.fieldValues,
    this.selectedFieldId,
    this.tabIndex,
    this.fieldViewModels,
    this.onAddNewField,
    this.onTabChanged,
    this.onFieldSelect,
    this.onMetadataValueChanged,
  });
}
