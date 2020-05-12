import 'package:darkwrong/constants.dart';
import 'package:darkwrong/keys.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:redux/redux.dart';

void navigationMiddleware(
    Store<AppState> store, dynamic action, NextDispatcher next) {
  if (action is SelectFieldVisibility &&
      action.selectedFieldId != allFieldFilterId) {
    homescreenScaffoldKey.currentState?.openDrawer();
  }

  next(action);
}
