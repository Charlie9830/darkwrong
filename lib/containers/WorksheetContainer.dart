import 'package:darkwrong/Worksheet.dart';
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
      fields: store.state.fields,
      fixtures: store.state.fixtures,
      maxFieldLengths: store.state.maxFieldLengths,
    );
  }
}