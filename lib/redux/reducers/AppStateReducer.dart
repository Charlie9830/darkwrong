import 'package:darkwrong/mock_data/initMockData.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/reducers/FixtureStateReducer.dart';
import 'package:darkwrong/redux/reducers/WorksheetStateReducer.dart';
import 'package:darkwrong/redux/state/AppState.dart';

AppState appStateReducer(AppState state, dynamic action) {
  if (action is InitMockData) {
    return state.copyWith(
      fixtureState: initMockData(state).fixtureState,
    );
  }

  return state.copyWith(
    fixtureState: fixtureStateReducer(state.fixtureState, action),
    worksheet: worksheetStateReducer(state.worksheetState, action),
  );
}
