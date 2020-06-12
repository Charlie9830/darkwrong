import 'package:darkwrong/constants.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/WorksheetNavigationState.dart';

WorksheetNavigationState worksheetNavigationStateReducer(
    WorksheetNavigationState state, dynamic action) {
  if (action is SetFieldsAndValuesEditorTabIndex) {
    return state.copyWith(
      fieldsAndValuesEditorTabIndex: action.index,
    );
  }

  if (action is SetFieldsAndValuesEditorSelectedFieldId) {
    return state.copyWith(
      selectedFieldId: action.fieldId,
    );
  }

  if (action is SelectWorksheetLeftTool) {
    return state.copyWith(
      selectedLeftRailTool: action.value == state.selectedLeftRailTool
          ? WorksheetToolOptions.noSelection
          : action.value,
    );
  }

  if (action is SetWorksheetLeftRailPersistence) {
    return state.copyWith(isLeftRailPersistent: action.persist);
  }

  if (action is AddNewFixtures) {
    return state.copyWith(
      selectedLeftRailTool: state.isLeftRailPersistent ? state.selectedLeftRailTool : WorksheetToolOptions.noSelection,
    );
  }

  return state;
}
