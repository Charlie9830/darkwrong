import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/presentation/worksheet_navigation_drawer/WorksheetNavigationDrawer.dart';
import 'package:darkwrong/redux/actions/AsyncActions.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:darkwrong/view_models/WorksheetNavigationDrawerViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class WorksheetNavigationDrawerContainer extends StatelessWidget {
  const WorksheetNavigationDrawerContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WorksheetNavigationDrawerViewModel>(
      builder: (context, viewModel) =>
          WorksheetNavigationDrawer(viewModel: viewModel),
      converter: (store) => _converter(store, context),
    );
  }

  WorksheetNavigationDrawerViewModel _converter(
      Store<AppState> store, BuildContext context) {
    final worksheetState = store.state.worksheetState;
    final fixtureState = store.state.fixtureState;
    final selectedFieldQueryId =
        store.state.worksheetState.selectedFieldQueryId;

    return WorksheetNavigationDrawerViewModel(
        fieldName: fixtureState.fields[selectedFieldQueryId]?.name ?? '',
        fieldValues:
            fixtureState.fieldValues.getFieldContents(selectedFieldQueryId),
        activeFieldValueQueries: worksheetState.fieldValueQueries,
        onAddFieldValueSelection: (FieldValueKey valueKey) => store.dispatch(
            addFieldValueQueries(
                selectedFieldQueryId, <FieldValueKey>{valueKey})),
        onRemoveFieldValueSelection: (FieldValueKey valueKey) => store.dispatch(
            removeFieldValueQueries(
                selectedFieldQueryId, <FieldValueKey>{valueKey})),
        onShowAllFieldValues: () => store.dispatch(
              removeFieldValueQueries(
                  selectedFieldQueryId, worksheetState.fieldValueQueries),
            ));
  }
}
