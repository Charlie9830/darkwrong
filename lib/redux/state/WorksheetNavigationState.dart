import 'package:darkwrong/constants.dart';

class WorksheetNavigationState {
  final String selectedLeftRailTool;
  final bool isLeftRailPersistent;
  final int fieldsAndValuesEditorTabIndex;
  final String selectedFieldId;

  WorksheetNavigationState({
    this.selectedLeftRailTool,
    this.isLeftRailPersistent,
    this.fieldsAndValuesEditorTabIndex,
    this.selectedFieldId,
  });

  WorksheetNavigationState.initial()
      : selectedLeftRailTool = WorksheetToolOptions.noSelection,
        isLeftRailPersistent = false,
        fieldsAndValuesEditorTabIndex = 0,
        selectedFieldId = '';

  WorksheetNavigationState copyWith({
    String selectedLeftRailTool,
    bool isLeftRailPersistent,
    int fieldsAndValuesEditorTabIndex,
    String selectedFieldId,
  }) {
    return WorksheetNavigationState(
      selectedLeftRailTool: selectedLeftRailTool ?? this.selectedLeftRailTool,
      isLeftRailPersistent: isLeftRailPersistent ?? this.isLeftRailPersistent,
      fieldsAndValuesEditorTabIndex: fieldsAndValuesEditorTabIndex ?? this.fieldsAndValuesEditorTabIndex,
      selectedFieldId: selectedFieldId ?? this.selectedFieldId,
    );
  }
}
