import 'package:darkwrong/config/FieldMetadataDescriptors.dart';
import 'package:darkwrong/enums.dart';
import 'package:darkwrong/mock_data/mockFieldNames.dart';
import 'package:darkwrong/models/Field.dart';
import 'package:darkwrong/models/FieldValuesStore.dart';
import 'package:darkwrong/redux/state/AppState.dart';
import 'package:darkwrong/util/getUid.dart';
import 'package:random_words/random_words.dart';

AppState initMockData(AppState state) {
  final fields = <FieldModel>[
    FieldModel(
      uid: 'instrument-name',
      name: 'Instrument Name',
      encoding: ValueEncoding.text,
      type: FieldType.instrumentName,
      valueMetadataDescriptors: FieldMetadataDescriptors.instrumentName,
    ),
    FieldModel(
      uid: 'position',
      name: 'Position',
      encoding: ValueEncoding.text,
      type: FieldType.position,
      valueMetadataDescriptors: FieldMetadataDescriptors.position,
    ),
    FieldModel(
      uid: 'channel',
      name: 'Channel',
      encoding: ValueEncoding.number,
      type: FieldType.channel,
      valueMetadataDescriptors: FieldMetadataDescriptors.channel,
    ),
    FieldModel(
      uid: 'unit-number',
      name: 'Unit Number',
      encoding: ValueEncoding.number,
      type: FieldType.unitNumber,
      valueMetadataDescriptors: FieldMetadataDescriptors.unitNumber,
    )
  ];

  return state.copyWith(
      fixtureState: state.fixtureState.copyWith(
    fields: Map<String, FieldModel>.fromEntries(
        fields.map((item) => MapEntry(item.uid, item))),
  ),
  worksheet: state.worksheetState.copyWith(
    displayedFields: fields,
  ));
}

// AppState initMockData(AppState state) {
//   const desiredFieldCount =
//       10; // Set by the ammount of fieldNames in mockFieldNames.
//   const desiredFixtureCount = 20;
//   const wordCount = 10;

//   final wordPairs = generateWordPairs().take(wordCount).toList();

//   final fields = mockFieldNames
//       .map((item) => FieldModel(
//           name: item,
//           encoding: ValueEncoding.text,
//           type: FieldType.custom,
//           uid: getUid(),
//           valueMetadataDescriptors: FieldMetadataDescriptors.custom))
//       .toList();

//   fields.add(FieldModel(
//     uid: 'instrument-name',
//     name: 'Instrument Name',
//     encoding: ValueEncoding.text,
//     type: FieldType.instrumentName,
//     valueMetadataDescriptors: FieldMetadataDescriptors.instrumentName,
//   ));

//   return state.copyWith(
//       fixtureState: state.fixtureState.copyWith(
//     //fixtures: Map<String, FixtureModel>.fromEntries(
//     //fixtures.map((item) => MapEntry(item.uid, item))),
//     //fieldValues: FieldValuesStore(valueMap: fieldValues),
//     fields: Map<String, FieldModel>.fromEntries(
//         fields.map((item) => MapEntry(item.uid, item))),
//   ));
// }
