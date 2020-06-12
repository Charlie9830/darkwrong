import 'package:darkwrong/presentation/fixture_creator/FixtureCreator.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:darkwrong/view_models/FixtureCreatorViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:darkwrong/redux/actions/AsyncActions.dart';

class FixtureCreatorContainer extends StatelessWidget {
  const FixtureCreatorContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FixtureCreatorViewModel>(
      builder: (context, viewModel) => FixtureCreator(viewModel: viewModel),
      converter: (store) => _converter(store, context),
    );
  }

  FixtureCreatorViewModel _converter(
      Store<AppState> store, BuildContext context) {
    final fixtureState = store.state.fixtureState;
    return FixtureCreatorViewModel(
        fieldValues: fixtureState.fieldValues,
        fields: fixtureState.fields.values.toList(),
        onAddButtonPressed: (Map<String, String> values, int multiplier) =>
            store.dispatch(addNewFixtures(values, multiplier)));
  }
}
