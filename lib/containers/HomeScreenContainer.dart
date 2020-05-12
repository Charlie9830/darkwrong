import 'package:darkwrong/models/FieldValue.dart';
import 'package:darkwrong/redux/actions/AsyncActions.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:darkwrong/screens/HomeScreen.dart';
import 'package:darkwrong/view_models/HomeScreenViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HomeScreenContainer extends StatelessWidget {
  const HomeScreenContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeScreenViewModel>(
      builder: (context, viewModel) {
        return HomeScreen(
          viewModel: viewModel,
        );
      },
      converter: (Store<AppState> store) {
        return HomeScreenViewModel(
          fields: store.state.fixtureState.fields,
          selectedFieldFilterId: store.state.worksheetState.selectedFieldFilterId,
          onFieldFilterSelect: (newValue) => print(newValue),
          onDebugButtonPressed: () => store.dispatch(InitMockData()),
          onAddFixtureButtonPressed: () => store.dispatch(buildWorksheet()),
          isFixtureEditEnabled: store.state.worksheetState.selectedCells.isNotEmpty,
          onValueUpdate: (String newValue) => store.dispatch(updateFixtureValues(store.state.worksheetState.selectedCells, newValue)),
        );
      },
    );
  }
}