import 'package:darkwrong/redux/reducers/FixtureStateReducer.dart';
import 'package:darkwrong/redux/reducers/WorksheetStateReducer.dart';
import 'package:darkwrong/redux/state/AppState.dart';

AppState appStateReducer(AppState state, dynamic action) {
  return state.copyWith(
    fixtureState: fixtureStateReducer(state.fixtureState, action),
    worksheet: worksheetStateReducer(state.worksheet, action),
  );
}
