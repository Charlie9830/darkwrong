import 'package:darkwrong/models/WorksheetModel.dart';
import 'package:darkwrong/redux/state/FixtureState.dart';

class AppState {
  final FixtureState fixtureState;
  final WorksheetModel worksheet;
  
  AppState({
    this.fixtureState,
    this.worksheet,
  });

  AppState.initial()
      : fixtureState = FixtureState.initial(),
        worksheet = WorksheetModel.initial();

  AppState copyWith({
    FixtureState fixtureState,
    WorksheetModel worksheet,
  }) {
    return AppState(
      fixtureState: fixtureState ?? this.fixtureState,
      worksheet: worksheet ?? this.worksheet,
    );
  }
}
