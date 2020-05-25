import 'package:darkwrong/redux/state/FixtureState.dart';
import 'package:darkwrong/redux/state/WorksheetNavigationState.dart';
import 'package:darkwrong/redux/state/WorksheetState.dart';

class AppState {
  final FixtureState fixtureState;
  final WorksheetState worksheetState;
  final WorksheetNavigationState worksheetNavState;
  
  AppState({
    this.fixtureState,
    this.worksheetState,
    this.worksheetNavState,
  });

  AppState.initial()
      : fixtureState = FixtureState.initial(),
        worksheetState = WorksheetState.initial(),
        worksheetNavState = WorksheetNavigationState.initial();

  AppState copyWith({
    FixtureState fixtureState,
    WorksheetState worksheet,
    WorksheetNavigationState worksheetNavState,
  }) {
    return AppState(
      fixtureState: fixtureState ?? this.fixtureState,
      worksheetState: worksheet ?? this.worksheetState,
      worksheetNavState: worksheetNavState ?? this.worksheetNavState,
    );
  }
}
