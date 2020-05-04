import 'dart:math';

import 'package:darkwrong/Field.dart';
import 'package:darkwrong/FieldValue.dart';
import 'package:darkwrong/Fixture.dart';
import 'package:darkwrong/enums.dart';
import 'package:darkwrong/mock_data/mockInstrumentTypes.dart';
import 'package:darkwrong/mock_data/mockPositions.dart';
import 'package:darkwrong/redux/actions/SyncActions.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:uuid/uuid.dart';

AppState appStateReducer(AppState state, dynamic action) {
  if (action is InitMockData) {
    final _random = Random();
    final uuid = Uuid();

    final String firstId = uuid.v4();
    final String secondId = uuid.v4();
    final String thirdId = uuid.v4();
    final String fourthId = uuid.v4();
    final String fifthId = uuid.v4();
    final String sixthId = uuid.v4();
    final String seventhId = uuid.v4();
    final String eighthId = uuid.v4();

    final fields = <String, FieldModel>{
      firstId:
          FieldModel(uid: firstId, name: 'Unit Number', type: FieldType.text),
      secondId: FieldModel(
        uid: secondId,
        name: 'Position',
        type: FieldType.text,
      ),
      thirdId: FieldModel(
        uid: thirdId,
        name: 'Instrument Type',
        type: FieldType.text,
      ),
      fourthId: FieldModel(
        uid: fourthId,
        name: 'Instrument Type 2',
        type: FieldType.text,
      ),
      fifthId: FieldModel(
        uid: fifthId,
        name: 'Instrument Type 3',
        type: FieldType.text,
      ),
      sixthId: FieldModel(
        uid: sixthId,
        name: 'Instrument Type 4',
        type: FieldType.text,
      ),
      seventhId: FieldModel(
        uid: seventhId,
        name: 'Instrument Type 5',
        type: FieldType.text,
      ),
      eighthId: FieldModel(
        uid: eighthId,
        name: 'Instrument Type 6',
        type: FieldType.text,
      )
    };

    final fixtures = List.generate(2000, (index) {
      return FixtureModel(uid: uuid.v4(), fieldValues: <String, FieldValue>{
        firstId: FieldValue((index + 1).toString()), // Unit Number
        secondId: FieldValue(
            mockPositions[_random.nextInt(mockPositions.length)]), // Position
        thirdId: FieldValue(
            mockInstrumentTypes[_random.nextInt(mockInstrumentTypes.length)]),

        fourthId: FieldValue(
            mockInstrumentTypes[_random.nextInt(mockInstrumentTypes.length)]),

        fifthId: FieldValue(
            mockInstrumentTypes[_random.nextInt(mockInstrumentTypes.length)]),

        sixthId: FieldValue(
            mockInstrumentTypes[_random.nextInt(mockInstrumentTypes.length)]),

        seventhId: FieldValue(
            mockInstrumentTypes[_random.nextInt(mockInstrumentTypes.length)]),

        eighthId: FieldValue(mockInstrumentTypes[
            _random.nextInt(mockInstrumentTypes.length)]), // Instrument Type
      });
    });

    return state.copyWith(
        fields: fields,
        fixtures: fixtures,
        maxFieldLengths: _buildMaxFieldLengths(fixtures));
  }

  return state;
}

Map<String, int> _buildMaxFieldLengths(List<FixtureModel> fixtures) {
  final Map<String, int> maxLengths = {};

  for (var fixture in fixtures) {
    for (var fieldValue in fixture.fieldValues.entries) {
      // Place an entry if one doesn't already exist.
      if (maxLengths.containsKey(fieldValue.key) == false) {
        maxLengths[fieldValue.key] = 0;
      }

      // Update the max length if greater than existing value.
      if (maxLengths[fieldValue.key] < fieldValue.value.length) {
        maxLengths[fieldValue.key] = fieldValue.value.length;
      }
    }
  }

  return maxLengths;
}
