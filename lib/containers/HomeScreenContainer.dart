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
          onDebugButtonPressed: () => store.dispatch(InitMockData()),
          onAddFixtureButtonPressed: () => store.dispatch(AddBlankFixture()),
        );
      },
    );
  }
}