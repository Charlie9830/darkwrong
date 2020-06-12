import 'package:darkwrong/redux/actions/AsyncActions.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:darkwrong/screens/HomeScreen.dart';
import 'package:darkwrong/view_models/HomeScreenViewModel.dart';
import 'package:darkwrong/view_models/WorksheetLeftRailViewModel.dart';
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
          worksheetLeftRailViewModel: _buildLeftRailViewModel(store),
          fields: store.state.fixtureState.fields,
          selectedFieldFilterId:
              store.state.worksheetState.selectedFieldQueryId,
          onFieldFilterSelect: (newValue) =>
              store.dispatch(SelectFieldQueryId(fieldId: newValue)),
          onDebugButtonPressed: () => store.dispatch(InitMockData()),
          onAddFixtureButtonPressed: () => store.dispatch(buildWorksheet()),
          isFixtureEditEnabled:
              store.state.worksheetState.selectedCellIds.isNotEmpty,
          onDeleteFixtures: () => store.dispatch(removeFixtures(
              Set<String>.from(store.state.worksheetState.selectedCellIds
                  .map((item) => item.rowId)))),
        );
      },
    );
  }

  WorksheetLeftRailViewModel _buildLeftRailViewModel(Store<AppState> store) {
    return WorksheetLeftRailViewModel(
      selectedTool: store.state.worksheetNavState.selectedLeftRailTool,
      onToolSelect: (value) =>
          store.dispatch(SelectWorksheetLeftTool(value: value)),
      isPersistent: store.state.worksheetNavState.isLeftRailPersistent,
      onPersistButtonPressed: (currentValue) => store.dispatch(SetWorksheetLeftRailPersistence(persist: !currentValue))
    );
  }
}
