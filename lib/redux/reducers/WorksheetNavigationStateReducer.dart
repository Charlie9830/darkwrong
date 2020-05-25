import 'package:darkwrong/constants.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/WorksheetNavigationState.dart';

WorksheetNavigationState worksheetNavigationStateReducer(
    WorksheetNavigationState state, dynamic action) {
  if (action is SelectWorksheetLeftTool) {
    return state.copyWith(
      selectedLeftRailTool: action.value == state.selectedLeftRailTool
          ? WorksheetToolOptions.noSelection
          : action.value,
    );
  }

  if (action is SetWorksheetLeftRailPersistence) {
    return state.copyWith(
      isLeftRailPersistent: action.persist
    );
  }

  return state;
}