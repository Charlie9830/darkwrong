import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/presentation/field_editor/FieldAndValuesEditor.dart';
import 'package:darkwrong/redux/actions/AsyncActions.dart';
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
    final selectedFieldId = store.state.worksheetNavState.selectedFieldId;

    return FieldAndValuesEditorViewModel(
        selectedFieldId: selectedFieldId,
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
            store.dispatch(SetFieldsAndValuesEditorTabIndex(index: index)),
        onFieldSelect: (FieldModel field) => store.dispatch(
            SetFieldsAndValuesEditorSelectedFieldId(fieldId: field?.uid ?? '')),
        onMetadataValueChanged: (fieldValueKey, propertyName, newValue) =>
            store.dispatch(UpdateFieldMetadataValue(
                fieldValueKey: fieldValueKey,
                propertyName: propertyName,
                newValue: newValue)),
        onFieldValueChanged: (fieldValueKey, newValue) => store.dispatch(
            updateFieldValue(selectedFieldId, fieldValueKey, newValue)));
  }
}
