import 'package:darkwrong/presentation/field_editor/FieldAndValuesEditor.dart';
import 'package:darkwrong/presentation/field_editor/FieldListTile.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:darkwrong/view_models/FieldAndValuesEditorViewModel.dart';
import 'package:darkwrong/view_models/FieldViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class FieldAndValuesEditorContainer extends StatelessWidget {
  const FieldAndValuesEditorContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FieldAndValuesEditorViewModel>(
      builder: (context, viewModel) =>
          FieldAndValuesEditor(viewModel: viewModel),
      converter: (store) => _converter(store, context),
    );
  }

  FieldAndValuesEditorViewModel _converter(
      Store<AppState> store, BuildContext context) {
    return FieldAndValuesEditorViewModel(
        selectedFieldId: store.state.worksheetNavState.selectedFieldId,
        fieldValues: store.state.fixtureState.fieldValues,
        tabIndex: store.state.worksheetNavState.fieldsAndValuesEditorTabIndex,
        onAddNewField: (fieldName, encoding) => store
            .dispatch(AddCustomField(fieldName: fieldName, encoding: encoding)),
        fieldViewModels: store.state.fixtureState.fields.values
            .map((item) => FieldViewModel(
                  data: item,
                  onDeletePressed: () =>
                      store.dispatch(DeleteCustomField(fieldId: item.uid)),
                  onViewValuesPressed: () {},
                  onChanged: (request) => store.dispatch(
                      UpdateField(fieldId: item.uid, request: request)),
                ))
            .toList(),
        onTabChanged: (index) =>
            store.dispatch(SetFieldsAndValuesEditorTabIndex(index: index)));
  }
}
