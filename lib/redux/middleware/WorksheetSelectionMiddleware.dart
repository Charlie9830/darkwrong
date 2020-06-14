import 'package:darkwrong/keys.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:redux/redux.dart';

void worksheetSelectionMiddleware(
    Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is RemoveWorksheetRows) {
    _clearSelections();
  }

  if (action is AddWorksheetRows) {
    _clearSelections();
  }

  next(action);
}

void _clearSelections() {
  worksheetTableKey.currentState?.clearSelections();
}
