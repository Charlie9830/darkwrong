import 'package:darkwrong/presentation/Worksheet.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:darkwrong/view_models/WorksheetViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class WorksheetContainer extends StatelessWidget {
  const WorksheetContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, WorksheetViewModel>(
      builder: (context, viewModel) => Worksheet(viewModel: viewModel),
      converter: (store) => _converter(store, context),
    );
  }

  WorksheetViewModel _converter(Store<AppState> store, BuildContext context) {
    return WorksheetViewModel(
      state: store.state.worksheetState,
      onCellSelect: (String rowId, String columnId, String cellId) => store.dispatch(SelectWorksheetCell(rowId: rowId, columnId: columnId, cellId: cellId)),
      onCellDeselect: (String rowId, String columnId, String cellId) => store.dispatch(DeselectWorksheetCell(rowId: rowId, columnId: columnId, cellId: cellId))
    );
  }
}