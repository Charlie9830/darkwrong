import 'package:darkwrong/redux/state/FixtureState.dart';
import 'package:darkwrong/redux/state/WorksheetState.dart';

class AppState {
  final FixtureState fixtureState;
  final WorksheetState worksheetState;
  
  AppState({
    this.fixtureState,
    this.worksheetState,
  });

  AppState.initial()
      : fixtureState = FixtureState.initial(),
        worksheetState = WorksheetState.initial();

  AppState copyWith({
    FixtureState fixtureState,
    WorksheetState worksheet,
  }) {
    return AppState(
      fixtureState: fixtureState ?? this.fixtureState,
      worksheetState: worksheet ?? this.worksheetState,
    );
  }
}
