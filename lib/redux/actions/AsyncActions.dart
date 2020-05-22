import 'package:darkwrong/constants.dart';
import 'package:darkwrong/enums.dart';
import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValue.dart';
import 'package:darkwrong/models/FieldValueKey.dart';
import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/models/Fixture.dart';
import 'package:darkwrong/models/NewFixturesRequest.dart';
import 'package:darkwrong/models/SelectedCell.dart';
import 'package:darkwrong/models/WorksheetCell.dart';
import 'package:darkwrong/models/WorksheetHeader.dart';
import 'package:darkwrong/models/WorksheetRow.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:darkwrong/redux/state/WorksheetState.dart';
import 'package:darkwrong/util/getCellId.dart';
import 'package:darkwrong/util/getUid.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<AppState> addNewFixtures(NewFixturesRequest request) {
  return (Store<AppState> store) async {
    if (request.isBlank) {
      return;
    }

    FieldValuesStore existingFieldValues = store.state.fixtureState.fieldValues;
    // Process the request object into new Fixtures.
    Map<String, FixtureModel> fixtures = {};
    Map<String, Map<FieldValueKey, FieldValue>> updatedFieldValues = {};

    final int multiplier = request.multiplier == 0 ? 1 : request.multiplier;
    for (int count = 1; count <= multiplier; count++) {
      // Add existingValues.
      final valueKeys =
          Map<String, FieldValueKey>.from(request.existingValueKeys);

      // Add new Values (Checking that they are indeed still new even after enumeration).
      for (var entry in request.newValues.entries) {
        // TODO: The code in this loop seems to be very similar to the code inside the UpdateFixturesAndFields reducer.
        final fieldId = entry.key;
        final rawValue = entry.value;

        // Enumerate value if it needs to be enumerated.
        final value = _needsEnumeration(rawValue)
            ? _enumerateValue(rawValue, count)
            : rawValue;

        // Build a valueKey from the new value then check if it already exists within fieldValues.
        final valueKey = FieldValueKey.fromText(value);
        if (existingFieldValues.containsValue(fieldId, valueKey) == false) {
          // It is definately a new value, add it to updatedFieldValues.
          if (updatedFieldValues[fieldId] == null) {
            updatedFieldValues[fieldId] = <FieldValueKey, FieldValue>{};
          }
          updatedFieldValues[fieldId][valueKey] =
              FieldValue.fromText(value, valueKey);
        }

        // Add a reference to the fixture valueKeys.
        valueKeys[fieldId] = valueKey;
      }

      final fixture = FixtureModel(uid: getUid(), valueKeys: valueKeys);

      // Add to fixtures.
      fixtures[fixture.uid] = fixture;
    }

    store.dispatch(AddNewFixtures(
        fixtures: fixtures,
        fieldValues: store.state.fixtureState.fieldValues
            .copyWithNewValues(updatedFieldValues)));
  };
}

String _enumerateValue(String value, int count) {
  // Positive Enumeration
  if (value.contains(positiveValueEnumerationIndicator)) {
    final int enumerationStepQuanity =
        _getEnumerationStepQuantity(value, FieldEnumeration.postive);
    final int baseNumber = int.tryParse(
        value.substring(0, value.indexOf(positiveValueEnumerationIndicator)));
    return (baseNumber * count * enumerationStepQuanity).toString();
  }

  // Negative enumeration.
  if (value.contains(negativeValueEnumerationIndicator)) {
    final int enumerationStepQuanity =
        _getEnumerationStepQuantity(value, FieldEnumeration.negative);

    final int baseNumber = int.tryParse(
        value.substring(0, value.indexOf(negativeValueEnumerationIndicator)));
    return (baseNumber * count * enumerationStepQuanity).toString();
  }

  return 'fail';
}

int _getEnumerationStepQuantity(
    String value, FieldEnumeration fieldEnumeration) {
  if (fieldEnumeration == FieldEnumeration.none) {
    return 1;
  }

  final String enumerationIndicator =
      fieldEnumeration == FieldEnumeration.postive
          ? positiveValueEnumerationIndicator
          : negativeValueEnumerationIndicator;

  final stepQuanitySection =
      value.substring(value.indexOf(enumerationIndicator));

  return int.tryParse(stepQuanitySection) ?? 1;
}

bool _needsEnumeration(String value) {
  // Checks if value provided contains a '++', then if '++' is removed checks if only digits are left over. Repeats process again for '--'.
  final regex = RegExp(r"^\d+$"); // Match only Digits.
  return (value.contains(positiveValueEnumerationIndicator) &&
          regex.hasMatch(
              value.replaceAll(positiveValueEnumerationIndicator, ''))) ||
      (value.contains(negativeValueEnumerationIndicator) &&
          regex.hasMatch(
              value.replaceAll(negativeValueEnumerationIndicator, '')));
}

ThunkAction<AppState> removeFixtures(Set<String> fixtureIds) {
  return (Store<AppState> store) async {
    // TODO: Possible Candiate for created a Batched Action.
    store.dispatch(RemoveWorksheetRows(rowIds: fixtureIds));
    store.dispatch(RemoveFixtures(fixtureIds: fixtureIds));
  };
}

ThunkAction<AppState> addFieldValueQueries(
    String selectedFieldQueryId, Set<FieldValueKey> valueKeys) {
  return (Store<AppState> store) async {
    store.dispatch(AddFieldValueQueries(
        fieldId: selectedFieldQueryId,
        valueKeys: valueKeys,
        fixtures: store.state.fixtureState.fixtures,
        fieldValues: store.state.fixtureState.fieldValues));
  };
}

ThunkAction<AppState> removeFieldValueQueries(
    String selectedFieldQueryId, Set<FieldValueKey> valueKeys) {
  return (Store<AppState> store) async {
    store.dispatch(RemoveFieldValueQueries(
        fieldId: selectedFieldQueryId,
        valueKeys: valueKeys,
        fixtures: store.state.fixtureState.fixtures,
        fieldValues: store.state.fixtureState.fieldValues));
  };
}

ThunkAction<AppState> updateFixtureValues(
    Map<String, SelectedCellModel> selectedCells, String newValue) {
  return (Store<AppState> store) async {
    // Iterate through selectedCells, build new updated fixtures and fieldValues as required.
    // If a matching value doesn't already exist within fieldValues, create it. Then attach the fixture to that value.
    final fieldValues = store.state.fixtureState.fieldValues;
    final updatedFieldValues = <String, Map<FieldValueKey, FieldValue>>{};
    final updatedFixtures = <String, FixtureModel>{};

    for (var cell in selectedCells.values) {
      final fixtureId = cell.rowId;
      final fieldId = cell.columnId;
      final fixture = store.state.fixtureState.fixtures[fixtureId];
      final newValueKey = FieldValueKey.fromText(newValue);
      final oldValue =
          fieldValues.getValue(fieldId, fixture.valueKeys[fieldId]);

      if (oldValue.asText == newValue) {
        // No update required.
        continue;
      }

      // If fieldValues doesn't already contain the new value we add it.
      if (fieldValues.containsValue(fieldId, newValueKey) == false) {
        // Ensure a map exists at the fieldId location first.
        if (updatedFieldValues[fieldId] == null) {
          updatedFieldValues[fieldId] = <FieldValueKey, FieldValue>{};
        }

        updatedFieldValues[fieldId][newValueKey] =
            FieldValue(newValue, newValueKey);
      }

      // Create a new updated Fixture or use an existing one if we have already updated this fixture previously in the loop.
      if (updatedFixtures.containsKey(fixtureId)) {
        updatedFixtures[fixtureId] = updatedFixtures[fixtureId]
            .copyWithUpdatedValue(fieldId, newValueKey);
      } else {
        updatedFixtures[fixtureId] =
            fixture.copyWithUpdatedValue(fieldId, newValueKey);
      }
    }

    // Update State.
    store.dispatch(UpdateFixturesAndFieldValues(
      fixtureUpdates: updatedFixtures,
      fieldValueUpdates: FieldValuesStore(valueMap: updatedFieldValues),
      existingFieldValues: store.state.fixtureState.fieldValues,
    ));
  };
}

ThunkAction<AppState> buildWorksheet() {
  return (Store<AppState> store) async {
    final watch = Stopwatch();
    watch.start();
    final worksheet = _buildWorksheet(
        store.state.worksheetState,
        store.state.fixtureState.fixtures,
        store.state.fixtureState.fieldValues,
        store.state.fixtureState.fields);

    print('Completed in ${watch.elapsedMilliseconds}ms');
    watch.stop();
    watch.reset();

    store.dispatch(BuildWorksheetState(state: worksheet));
  };
}

WorksheetState _buildWorksheet(
    WorksheetState existingWorksheet,
    Map<String, FixtureModel> fixtures,
    FieldValuesStore fieldValuesStore,
    Map<String, FieldModel> fields) {
  final Map<String, WorksheetRowModel> rows = {};
  final Map<String, int> maxFieldLengths = {};
  final displayedFields =
      fields; // Actual implementation of Filtering and sorting to be completed at a later date.

  // Iterate through Fixtures then each Fixtures fieldEntrys to build Cells into the Rows. Also collect the maxFieldLengths.
  for (var fixture in fixtures.values) {
    final String rowId = fixture.uid;
    final Map<String, WorksheetCellModel> cells = {};

    for (var fieldsEntry in displayedFields.entries) {
      // Build the Cell.
      final fieldValue = fieldValuesStore.getValue(
          fieldsEntry.key, fixture.valueKeys[fieldsEntry.key]);

      cells[fieldsEntry.key] = WorksheetCellModel(
        cellId: getCellId(rowId, fieldsEntry.key),
        columnId: fieldsEntry.key,
        rowId: rowId,
        value: fieldValue?.value ?? '',
      );

      // Update maxFieldLengths.
      final coercedValueLength = fieldValue?.length ?? 0;
      if (maxFieldLengths.containsKey(fieldsEntry.key) == false) {
        maxFieldLengths[fieldsEntry.key] = coercedValueLength;
      }

      if (coercedValueLength > maxFieldLengths[fieldsEntry.key]) {
        maxFieldLengths[fieldsEntry.key] = coercedValueLength;
      }
    }

    rows[rowId] = WorksheetRowModel(
      rowId: rowId,
      cells: cells,
    );
  }

  return existingWorksheet.copyWith(
      rows: rows,
      headers: Map<String, WorksheetHeaderModel>.from(existingWorksheet.headers)
        ..updateAll((key, value) {
          return WorksheetHeaderModel(
              uid: key,
              title: value.title,
              maxFieldLength: maxFieldLengths[key] ?? 0);
        }));
}
